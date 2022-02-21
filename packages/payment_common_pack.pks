create or replace package payment_common_pack is

  -- Author  : РУСЛАН
  -- Purpose : Общие объекты
  
--сообщения об ошибках
с_field_id_can_not_be_empty constant varchar2(100 char):='ID поля не может быть пустым!';
c_field_value_can_not_be_empty constant varchar2(100 char):='Значение в поле field_value не может быть пустым';
c_collection_is_empty constant varchar2(100 char):='Коллекция не содержит данных!';
c_payment_id_can_not_be_empty constant varchar2(100 char):='ID объекта не может быть пустым';
c_reason_to_cancel_payment constant varchar2(100 char):='Необходимо указать причину отмены платежа!';
c_reason_to_fail_payment constant varchar2(100 char):='Необходимо указать причину сброса платежа!';
c_error_msg_delete_forbidden constant varchar2(100 char) := 'Удаление объекта запрещено!';
c_error_msg_manual_changes constant varchar2(100 char) := 'Изменения должны выполняться только через API!';
c_error_msg_finally_status_object constant varchar2(100 char) := 'Объект в конечном статусе. Изменения невозможны!';
c_error_msg_object_notfound constant varchar2(100 char) := 'Объект не найден!';
c_error_msg_object_already_locked constant varchar2(100 char) := 'Объект уже заблокирован!';

--коды ошибок
c_error_code_invalid_input_parameter constant number(10) := -20001;
c_error_code_delete_forbidden constant number(10) := -20002;
c_error_code_manual_changes constant number(10) := -20003;
c_error_code_finally_status_object constant number(10) := -20004;
c_error_code_object_notfound constant number(10) := -20005;
c_error_code_object_already_locked constant number(10) := -20006;


--объекты ошибок
e_invalid_input_parameter exception;
pragma exception_init(e_invalid_input_parameter, c_error_code_invalid_input_parameter);
e_delete_forbidden exception;
pragma exception_init(e_delete_forbidden, c_error_code_delete_forbidden);
e_manual_changes exception;
pragma exception_init(e_manual_changes, c_error_code_manual_changes);
e_finally_status_object exception;
pragma exception_init(e_finally_status_object, c_error_code_finally_status_object);
e_object_notfound exception;
pragma exception_init(e_object_notfound, c_error_code_object_notfound);
e_row_locked exception;
pragma exception_init(e_row_locked, -00054);
e_object_already_locked exception;
pragma exception_init(e_object_already_locked, c_error_code_object_already_locked);

--включение/отключения разрешения менять вручную данные объектов
procedure enable_manual_changes;
procedure disable_manual_changes;
--разрешены ли ручные изменения на глобальном уровне
function is_manual_changes_allowed return boolean;

end payment_common_pack;
/