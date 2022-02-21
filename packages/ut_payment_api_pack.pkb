create or replace package body ut_payment_api_pack is

  procedure create_payment is
    v_payment_id payment.payment_id%type;
    v_payment payment%rowtype;
    --setup
    v_summa          payment.summa%type          := ut_payment_common_pack.get_random_payment_sum();
    v_currency_id    payment.currency_id%type    := ut_payment_common_pack.get_random_currency();
    v_from_client_id payment.from_client_id%type := ut_client_common_pack.create_default_client;
    v_to_client_id   payment.to_client_id%type   := ut_client_common_pack.create_default_client;
    v_payment_detail t_payment_detail_array      := t_payment_detail_array(
                                                                           t_payment_detail(ut_payment_common_pack.c_client_software, 
                                                                                            ut_payment_common_pack.get_random_client_software()),
                                                                               
                                                                           t_payment_detail(ut_payment_common_pack.c_ip, 
                                                                                            ut_payment_common_pack.get_random_ip()),
                                                                               
                                                                           t_payment_detail(ut_payment_common_pack.c_note, 
                                                                                            ut_payment_common_pack.get_random_note()),
                                                                               
                                                                           t_payment_detail(ut_payment_common_pack.c_is_checked_fraud, 
                                                                                            ut_payment_common_pack.get_random_is_checked_fraud()));
  begin

    --тестируем создание
    v_payment_id := payment_api_pack.create_payment(p_summa          => v_summa,
                                                    p_currency_id    => v_currency_id,
                                                    p_from_client_id => v_from_client_id,
                                                    p_to_client_id   => v_to_client_id,
                                                    p_payment_detail => v_payment_detail);
    
    --получаем данные платежа после создания
    v_payment := ut_payment_common_pack.get_payment_info(v_payment_id);
    
    --проверяем что было записано во все поля
    if (v_payment.summa != v_summa or 
        v_payment.currency_id != v_currency_id or
        v_payment.from_client_id != v_from_client_id or 
        v_payment.to_client_id != v_to_client_id or
        v_payment.status != payment_api_pack.c_status_payment_created or 
        v_payment.status_change_reason is not null) then
       
       ut_payment_common_pack.ut_failed();
       
    end if;
    
    --проверка работы триггеров
    if v_payment.create_dtime_tech != v_payment.update_dtime_tech then
      ut_payment_common_pack.ut_failed();
    end if;
    
  end;

  procedure fail_payment is
    v_payment_id payment.payment_id%type;
    v_reason payment.status_change_reason%type := dbms_random.string('a', 10);    
    v_payment payment%rowtype;
  begin
    --setup
    v_payment_id := ut_payment_common_pack.create_default_payment();
    
    -- вызов тестируемой функции
    payment_api_pack.fail_payment(p_payment_id => v_payment_id, 
                                  p_reason => v_reason);
    
    --получаем данные по платежу
    v_payment := ut_payment_common_pack.get_payment_info(v_payment_id);
    
    -- проверка правильного заполнения полей
    if (v_payment.status != payment_api_pack.c_status_payment_reset_in_error 
        or 
        v_payment.status_change_reason is null) then
      
      ut_payment_common_pack.ut_failed();
    
    end if;
    
    -- проверка работы триггера по изменению технических полей
    if v_payment.create_dtime_tech = v_payment.update_dtime_tech then
      ut_payment_common_pack.ut_failed();
    end if;
    
  end;
  
  ----Негативные тесты

  procedure drop_payment_without_api_should_be_failed is
    v_payment_id payment.payment_id%type:= ut_payment_common_pack.c_non_existing_payment_id;
  begin
    delete from payment p where p.payment_id = v_payment_id;

    ut_payment_common_pack.ut_failed();
  exception
    when payment_common_pack.e_delete_forbidden then   --если возбуждено исключение, то тест пройден
      null; 
  end;


  procedure direct_insert_payment_without_api_should_be_failed is
    v_payment_id payment.payment_id%type:= ut_payment_common_pack.c_non_existing_payment_id;
  begin
    insert into payment(payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id, status_change_reason)
    values(v_payment_id, systimestamp, 200, 634, 1, 2, null);

    ut_payment_common_pack.ut_failed();
  exception
    when payment_common_pack.e_manual_changes then
      --если возбуждено это исключение, то тест пройден
      null; 
  end;

end;
/
