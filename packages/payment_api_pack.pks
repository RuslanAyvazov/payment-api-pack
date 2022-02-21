create or replace package payment_api_pack is
/*Автор: Айвазов Руслан
Описание скрипта: API для сущностей "Платеж" и "Детали платежа"*/

--константы
--статус создания id платежа
c_status_payment_created constant payment.status%type default 0;
--статус успешного создания платежа
c_status_payment_successfully_created constant payment.status%type := 1; 
--статус сброса платежа
c_status_payment_reset_in_error constant payment.status%type default 2;
--статус отмены платежа
c_status_payment_canceled constant payment.status%type := 3;

--создание платежа - функция create_payment
function create_payment(p_summa payment.summa%type,
                        p_currency_id payment.currency_id%type,
                        p_from_client_id payment.from_client_id%type,
                        p_to_client_id payment.to_client_id%type,
                        p_payment_detail t_payment_detail_array)
return payment.payment_id%type;

--сброс платежа в ошибочный статус - процедура fail_payment
procedure fail_payment(p_payment_id payment.payment_id%type,
                       p_reason payment.status_change_reason%type);

--отмена платежа - процедура cancel_payment
procedure cancel_payment(p_payment_id payment.payment_id%type,
                         p_reason payment.status_change_reason%type);

--успешное завершение платежа - процедура successful_finish_payment
procedure successful_finish_payment(p_payment_id payment.payment_id%type);

--блокировка платежа для изменения 
procedure try_lock_payment(p_payment_id payment.payment_id%type);

----Триггеры

--проверка на значение флажка, вызываемая из триггера
procedure is_changes_through_api;

--проверка на возможность удалять данные
procedure check_payment_delete_restriction;

end payment_api_pack;
/