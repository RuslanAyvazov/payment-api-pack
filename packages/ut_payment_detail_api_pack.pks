create or replace package ut_payment_detail_api_pack is

  -- Author  : РУСЛАН
  -- Purpose : Unit-тесты для API данных по платежу 
  
  --%suite(Unit-tests for payment detail)
  
  --%test(Проверка вставка/обновление деталей платежа)
  procedure insert_or_update_payment_detail;

  --%test(Проверка удаление деталей платежа)
  procedure delete_payment_detail;

  ----Негативные тесты
  
  --%test(Проверка вставка/обновление деталей платежа без деталей)
  procedure insert_or_update_payment_detail_with_empty_array_should_be_failed;

  --%test(Проверка удаление деталей платежа без деталей)
  procedure delete_payment_detail_with_empty_array_should_be_failed;

end ut_payment_detail_api_pack;
/