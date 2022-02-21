create or replace package body payment_api_pack is
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
g_is_api boolean := false; --признак, выполняется ли изменение через API

--процедура включения возможности использования прямого DML
procedure allow_changes is
begin
  g_is_api := true;
end;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

--процедура отключения возможности использования прямого DML
procedure disallow_changes is
begin
  g_is_api := false;
end;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
procedure is_changes_through_api is
begin
  if not g_is_api and not payment_common_pack.is_manual_changes_allowed() then
    raise_application_error(payment_common_pack.c_error_code_manual_changes, 
                            payment_common_pack.c_error_msg_manual_changes);
  end if;
end;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

procedure check_payment_delete_restriction is
begin
  if not payment_common_pack.is_manual_changes_allowed() then
    raise_application_error(payment_common_pack.c_error_code_delete_forbidden, 
                            payment_common_pack.c_error_msg_delete_forbidden);
  end if;
end;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

--процедура блокировки платежа для изменения 
procedure try_lock_payment(p_payment_id payment.payment_id%type) is
  v_status payment.status%type;
begin
  select p.status
  into v_status
  from payment p
  where p.payment_id = p_payment_id
  for update nowait;

  if v_status in (c_status_payment_successfully_created, 
                  c_status_payment_reset_in_error, 
                  c_status_payment_canceled) then

    raise_application_error(payment_common_pack.c_error_code_finally_status_object, payment_common_pack.c_error_msg_finally_status_object);
  end if;

exception
  when no_data_found then
    raise_application_error(payment_common_pack.c_error_code_object_notfound, payment_common_pack.c_error_msg_object_notfound);
  when payment_common_pack.e_row_locked then
    raise_application_error(payment_common_pack.c_error_code_object_already_locked, payment_common_pack.c_error_msg_object_already_locked);

end;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

function create_payment(p_summa payment.summa%type,
                        p_currency_id payment.currency_id%type,
                        p_from_client_id payment.from_client_id%type,
                        p_to_client_id payment.to_client_id%type,
                        p_payment_detail t_payment_detail_array) 
return payment.payment_id%type is
 v_payment_id payment.payment_id%type;
begin
  --включаем возможность использования прямого DML
  allow_changes();
  --создание платежа
  insert into payment(payment_id, 
                      create_dtime, 
                      summa, 
                      currency_id, 
                      from_client_id, 
                      to_client_id)
  values (payment_seq.nextval, 
          systimestamp, 
          p_summa, 
          p_currency_id, 
          p_from_client_id, 
          p_to_client_id)
  returning payment_id into v_payment_id;
  
  --добавление платежных данных данных
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id, 
                                                          p_payment_detail =>p_payment_detail);
  --отключаем возможность использования прямого DML
  disallow_changes();

  return v_payment_id;

exception
  --в случае возникновения исключения, необходимо вручную сбросить флажок(g_is_api := false), в противном случае g_is_api := true
  when others then
    disallow_changes();
    raise;
end create_payment;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

procedure fail_payment(p_payment_id payment.payment_id%type,
                       p_reason payment.status_change_reason%type) is
begin
  if p_payment_id is null then
       raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_payment_id_can_not_be_empty);
       return;
  end if;

  if p_reason is null then
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_reason_to_fail_payment);
  end if;
  
  --пытаемся заблокировать платеж
  try_lock_payment(p_payment_id => p_payment_id);
  
  --включаем возможность использования прямого DML
  allow_changes();
  
  --если платеж в статусе 0, то можем сбросить его. В противном случае сброс платежа невозможен
  update payment t
  set t.status = c_status_payment_reset_in_error, status_change_reason = p_reason
  where 1 = 1
  and t.payment_id = p_payment_id
  and t.status = c_status_payment_created;
  
  --отключаем возможность использования прямого DML
  disallow_changes();
  
exception
  --в случае возникновения исключения, необходимо вручную сбросить флажок(g_is_api := false), в противном случае g_is_api := true
  when others then
    disallow_changes();
    raise;
end fail_payment;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

procedure cancel_payment(p_payment_id payment.payment_id%type,
                         p_reason payment.status_change_reason%type) is
begin
  if p_payment_id is null then
       raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_payment_id_can_not_be_empty);
  end if;

  if p_reason is null then
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_reason_to_cancel_payment);
  end if;

  --пытаемся заблокировать платеж
  try_lock_payment(p_payment_id => p_payment_id);
  
  --включаем возможность использования прямого DML
  allow_changes();
  
  --если платеж в статусе 0, то можем отмениь его. В противном случае отмена платежа невозможна
  update payment t
    set t.status = c_status_payment_canceled, status_change_reason = p_reason
  where 1=1
          and t.payment_id = p_payment_id
          and t.status = c_status_payment_created;

  --отключаем возможность использования прямого DML
  disallow_changes();
  
exception
  --в случае возникновения исключения, необходимо вручную сбросить флажок(g_is_api := false), в противном случае g_is_api := true
  when others then
    disallow_changes();
    raise;
end cancel_payment;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

procedure successful_finish_payment(p_payment_id payment.payment_id%type) is
begin
  if p_payment_id is null then
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_payment_id_can_not_be_empty);
  end if;
  
  --пытаемся заблокировать платеж
  try_lock_payment(p_payment_id => p_payment_id);

  --включаем возможность использования прямого DML
  allow_changes();
  
  -- обновляем платеж
  update payment p
     set p.status = c_status_payment_successfully_created,
         p.status_change_reason = null
   where 1 = 1
     and p.payment_id = p_payment_id
     and p.status = c_status_payment_created;

  --отключаем возможность использования прямого DML
  disallow_changes();
  
exception
  --в случае возникновения исключения, необходимо вручную сбросить флажок(g_is_api := false), в противном случае g_is_api := true
  when others then
    disallow_changes();
    raise;
end successful_finish_payment;


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------


end payment_api_pack;
/