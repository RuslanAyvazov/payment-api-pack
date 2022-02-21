create or replace package ut_payment_utils_pack is

  -- Author  : РУСЛАН
  -- Purpose : Служебные модули, объекты для организации Unit-тестирования (фреймворка)
  
  procedure run_tests(p_package_name user_objects.object_name%type := null);

end ut_payment_utils_pack;
/
