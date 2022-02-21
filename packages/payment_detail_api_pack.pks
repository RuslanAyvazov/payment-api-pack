create or replace package payment_detail_api_pack is
/*Автор: Айвазов Руслан
Описание скрипта: API для сущностей "Платеж" и "Детали платежа"*/



--вставка/обновление деталей платежа - процедура insert_or_update_payment_detail
procedure insert_or_update_payment_detail(p_payment_id payment.payment_id%type,
                                          p_payment_detail t_payment_detail_array);

--удаление деталей платежа - delete_payment_detail
procedure delete_payment_detail(p_payment_id payment.payment_id%type,
                                p_delete_field_ids t_number_array);
                                

----Триггеры
                             
--проверка на значение флажка, вызываемая из триггера
procedure is_changes_through_api;



end payment_detail_api_pack;
/