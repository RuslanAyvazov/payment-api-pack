create or replace package body payment_detail_api_pack is
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

--вставка/обновление деталей платежа - процедура insert_or_update_payment_detail
procedure insert_or_update_payment_detail(p_payment_id payment.payment_id%type,
                                          p_payment_detail t_payment_detail_array)
is
begin
  --проверка на инициализацию коллекции
  if p_payment_detail is not empty then

    for i in p_payment_detail.first..p_payment_detail.last loop
      --проверка на пустоту поля field_id объекта t_payment_detail в коллекции p_payment_detail типа t_payment_detail_array
      if p_payment_detail(i).field_id is null then
        raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.с_field_id_can_not_be_empty);
      end if;
      --проверка на пустоту поля field_value объекта t_payment_detail в коллекции p_payment_detail типа t_payment_detail_array
      if p_payment_detail(i).field_value is null then
        raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_field_value_can_not_be_empty);
      end if;
    end loop;

  else
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_collection_is_empty);
  end if;

  if p_payment_id is null then
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_payment_id_can_not_be_empty);
  end if;
  
  --пытаемся заблокировать платеж
  payment_api_pack.try_lock_payment(p_payment_id => p_payment_id);
  
  --включаем возможность использования прямого DML
  allow_changes();
  
  merge into payment_detail t
  using (select
           p_payment_id payment_id, value(t).field_id field_id, value(t).field_value field_value
         from table(p_payment_detail) t) o
  on (o.payment_id = t.payment_id and o.field_id = t.field_id)
  when matched then
    update set t.field_value = o.field_value
  when not matched then
    insert(t.payment_id, t.field_id, t.field_value)
    values(o.payment_id, o.field_id, o.field_value);
    
  --отключаем возможность использования прямого DML
  disallow_changes();
  
exception
  --в случае возникновения исключения, необходимо вручную сбросить флажок(g_is_api := false), в противном случае g_is_api := true
  when others then
    disallow_changes();
    raise;
end insert_or_update_payment_detail;

procedure delete_payment_detail(p_payment_id payment.payment_id%type,
                                p_delete_field_ids t_number_array)
is
begin

  --проверка на инициализацию коллекции
  if p_delete_field_ids is empty or p_delete_field_ids is null then
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_collection_is_empty);
  end if;

  if p_payment_id is null then
    raise_application_error(payment_common_pack.c_error_code_invalid_input_parameter, payment_common_pack.c_payment_id_can_not_be_empty);
  end if;
  
  --пытаемся заблокировать платеж
  payment_api_pack.try_lock_payment(p_payment_id => p_payment_id);
    
  --включаем возможность использования прямого DML
  allow_changes();
  
  delete from payment_detail pd
  where 1=1
          and pd.payment_id = p_payment_id
          and pd.field_id in (select value(t) from table(p_delete_field_ids) t);

  --отключаем возможность использования прямого DML
  disallow_changes();
  
exception
  --в случае возникновения исключения, необходимо вручную сбросить флажок(g_is_api := false), в противном случае g_is_api := true
  when others then
    disallow_changes();
    raise;

end delete_payment_detail;

end payment_detail_api_pack;
/
