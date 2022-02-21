create or replace package ut_payment_common_pack is

  -- Author  : РУСЛАН
  -- Purpose : Общие объекты, модули и др для организации Unit-тестов

--поля детелей платежа
c_client_software  constant payment_detail_field.field_id%type := 1;
c_ip               constant payment_detail_field.field_id%type := 2;
c_note             constant payment_detail_field.field_id%type := 3;
c_is_checked_fraud constant payment_detail_field.field_id%type := 4;

c_non_existing_payment_id constant payment.payment_id%type := -777;

--генерация значений полей деталей платежа
function get_random_client_software                               return payment_detail_field.description%type;
function get_random_ip                                            return payment_detail_field.description%type;
function get_random_note                                          return payment_detail_field.description%type;
function get_random_is_checked_fraud                              return payment_detail_field.description%type;
function get_random_payment_sum                                   return payment.summa%type;
function get_random_currency                                      return currency.currency_id%type;
function get_random_from_client_and_to_client(p_direction number) return client.client_id%type;

-- Сообщения об ошибках
c_error_msg_test_failed constant varchar2(100 char) := 'Unit-тест не прошел';

-- Коды ошибок
c_error_code_test_failed constant number(10) := -20999;
  
--создание платежа и его деталей
function create_default_payment(p_payment_data t_payment_detail_array := null) return payment.payment_id%type;

function get_payment_info(p_payment_id payment.payment_id%type) return payment%rowtype;

-- Получить данные по полю платежа
function get_payment_field_value(p_payment_id payment_detail.payment_id%type,
                                 p_field_id payment_detail.field_id%type) return payment_detail.field_value%type;

--возбуждение исключения
procedure ut_failed;

end ut_payment_common_pack;
/