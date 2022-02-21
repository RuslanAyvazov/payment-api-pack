create or replace package body ut_payment_common_pack is

--генерация софта, через который совершался платеж
function get_random_client_software return payment_detail_field.description%type is
begin
  return 'mob. app. ' || dbms_random.string('1', 10);
end;

--генерация ip адреса плательщика
function get_random_ip return payment_detail_field.description%type is
begin
  return trunc(dbms_random.value(1, 10)) || '.' || 
         trunc(dbms_random.value(100, 999)) || '.' || 
         trunc(dbms_random.value(100, 999)) || '.' || 
         trunc(dbms_random.value(10, 99));
end;

--генерация примечания к переводу
function get_random_note return payment_detail_field.description%type is
begin
  return 'Тестовый перевод суммы № ' || trunc(dbms_random.value(1, 32000000));
end;

--генерация проверен ли платеж в системе "антифрод"
function get_random_is_checked_fraud return payment_detail_field.description%type is
begin
  return trunc(dbms_random.value(0, 1));
end;

--генерация суммы платежа
function get_random_payment_sum return payment.summa%type is
begin
  return trunc(dbms_random.value(1, 20000));
end;

--генерация выбора валюты
function get_random_currency return currency.currency_id%type is
  type collection is table of currency.currency_id%type;
  col collection;
begin
  select cur.currency_id
  bulk collect into col
  from currency cur;
  
  return col(trunc(dbms_random.value(1, 4)));
end;

--генерация случайного выбора от кого и кому
function get_random_from_client_and_to_client(p_direction number) return client.client_id%type is
  v_min_id client.client_id%type;
  v_max_id client.client_id%type;
  v_from client.client_id%type;
  v_to client.client_id%type;
begin
  
  select min(client_id), max(client_id) 
  into v_min_id, v_max_id 
  from client cl
  where cl.is_active = 1;
  
  v_from := trunc(dbms_random.value(v_min_id, v_max_id));
  v_to := trunc(dbms_random.value(v_min_id, v_max_id));
  
  while v_from = v_to loop
    v_to := trunc(dbms_random.value(v_min_id, v_max_id));
  end loop;
  
  if p_direction = 0 then 
     return v_from;
  else 
    return v_to;
  end if;
 
end;


--создание платежа и его деталей
function create_default_payment(p_payment_data t_payment_detail_array := null) return payment.payment_id%type is
  v_payment_data t_payment_detail_array := p_payment_data;
  
begin
  if (v_payment_data is null or v_payment_data is empty) then
    v_payment_data := t_payment_detail_array(t_payment_detail(c_client_software, get_random_client_software()),
                                             t_payment_detail(c_ip, get_random_ip()),
                                             t_payment_detail(c_note, get_random_note()),
                                             t_payment_detail(c_is_checked_fraud, get_random_is_checked_fraud()));
  end if;

  return payment_api_pack.create_payment(p_summa          => get_random_payment_sum(),
                                         p_currency_id    => get_random_currency(),
                                         p_from_client_id => ut_client_common_pack.create_default_client,
                                         p_to_client_id   => ut_client_common_pack.create_default_client,
                                         p_payment_detail => v_payment_data);
end;

--получение информации по сущности "Платеж"
function get_payment_info(p_payment_id payment.payment_id%type) return payment%rowtype is
  v_payment payment%rowtype;                    
begin
  
  select p.* 
  into v_payment
  from payment p 
  where p.payment_id = p_payment_id;
  
  return v_payment;
end;

-- Получить данные по полю платежа
function get_payment_field_value(p_payment_id payment_detail.payment_id%type,
                                 p_field_id payment_detail.field_id%type) return payment_detail.field_value%type is
  v_field_value payment_detail.field_value%type;                   
begin
  select max(pd.field_value)
  into v_field_value
  from payment_detail pd
  where 1 = 1 
            and pd.payment_id = p_payment_id
            and pd.field_id = p_field_id;
            
  return v_field_value;
end;

--возбуждение исключения
procedure ut_failed is
begin
  raise_application_error(c_error_code_test_failed, c_error_msg_test_failed);
end;

  
end ut_payment_common_pack;
/