create or replace trigger payment_detail_b_iu_api
before insert or update on payment_detail
begin
  payment_detail_api_pack.is_changes_through_api; --проверка на выполнение команды через API
end;
/
