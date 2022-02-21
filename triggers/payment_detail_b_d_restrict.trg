create or replace trigger payment_detail_b_d_restrict
before delete on payment_detail
begin
 payment_detail_api_pack.is_changes_through_api;
end;
/
