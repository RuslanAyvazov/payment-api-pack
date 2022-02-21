create or replace package body ut_payment_detail_api_pack is

  procedure insert_or_update_payment_detail is
    v_note_to_payment payment_detail.field_value%type := ut_payment_common_pack.get_random_note();
    v_fraud_flag payment_detail.field_value%type := ut_payment_common_pack.get_random_is_checked_fraud();
    
    v_payment_detail t_payment_detail_array:= t_payment_detail_array(t_payment_detail(ut_payment_common_pack.c_note, v_note_to_payment),
                                                                     t_payment_detail(ut_payment_common_pack.c_is_checked_fraud, v_fraud_flag));
    v_payment_id payment.payment_id%type;
  begin
    --setup
    v_payment_id := ut_payment_common_pack.create_default_payment;
    
    --тестируемое API
    payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id, 
                                                            p_payment_detail => v_payment_detail);
                                                            
    --получаем данные и сравниваем с тем, что было до
    if v_note_to_payment != ut_payment_common_pack.get_payment_field_value(p_payment_id => v_payment_id, p_field_id => ut_payment_common_pack.c_note) or
       v_fraud_flag != ut_payment_common_pack.get_payment_field_value(p_payment_id => v_payment_id, p_field_id => ut_payment_common_pack.c_is_checked_fraud) then
       
       ut_payment_common_pack.ut_failed();
      
    end if;
    
  end;

  procedure delete_payment_detail is
    v_delete_field_ids t_number_array := t_number_array(ut_payment_common_pack.c_note, ut_payment_common_pack.c_is_checked_fraud);
    v_payment_id payment.payment_id%type;
    
    v_note_to_payment payment_detail.field_value%type;
    v_fraud_flag payment_detail.field_value%type;
    
  begin
     --setup
     v_payment_id := ut_payment_common_pack.create_default_payment();
     --тестируемое API
     payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, 
                                                   p_delete_field_ids => v_delete_field_ids);
     --проверка данных
     v_note_to_payment := ut_payment_common_pack.get_payment_field_value(p_payment_id => v_payment_id, 
                                                                 p_field_id => ut_payment_common_pack.c_note);
                                                                 
     v_fraud_flag := ut_payment_common_pack.get_payment_field_value(p_payment_id => v_payment_id, 
                                                            p_field_id => ut_payment_common_pack.c_is_checked_fraud);
                                                            
     if (v_note_to_payment is not null or v_fraud_flag is not null) then
       ut_payment_common_pack.ut_failed();
     end if;
  end;

  ----Ќегативные тесты

  procedure insert_or_update_payment_detail_with_empty_array_should_be_failed is
    v_payment_detail t_payment_detail_array;
    v_payment_id payment.payment_id%type;
  begin
   --setup
   v_payment_id := ut_payment_common_pack.create_default_payment();
   --“естируемое API
   payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id, 
                                                           p_payment_detail => v_payment_detail);
   ut_payment_common_pack.ut_failed();
  exception
    when payment_common_pack.e_invalid_input_parameter then
      null; 
  end;


  procedure delete_payment_detail_with_empty_array_should_be_failed is
    v_delete_field_ids t_number_array;
    v_payment_id payment.payment_id%type;
  begin
     --setup
     v_payment_id := ut_payment_common_pack.create_default_payment();
     --“естируемое API
     payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, 
                                                   p_delete_field_ids => v_delete_field_ids);
     ut_payment_common_pack.ut_failed();
  exception
    when payment_common_pack.e_invalid_input_parameter then
      null; 
  end;


end;
/
