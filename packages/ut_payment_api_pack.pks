create or replace package ut_payment_api_pack is

  -- Author  : РУСЛАН
  -- Purpose : Unit-тесты для API по платежу

  --%suite(Unit-tests for payment) 
  
  --%test(Создание платежа)
  procedure create_payment;

  --%test(Сброс платежа)
  procedure fail_payment;
  
  ----Негативные тесты
  
  --%test(Удаление платежа без API)
  procedure drop_payment_without_api_should_be_failed;
  
  --%test(Вставка платежа без API)
  procedure direct_insert_payment_without_api_should_be_failed; 

end ut_payment_api_pack;
/