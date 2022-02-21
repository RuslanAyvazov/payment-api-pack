--create types
create or replace type t_number_array is table of number(38);
/

create or replace type t_payment_detail is object(
  field_id    number(10),
  field_value varchar2(200 char)
);
/

create or replace type t_payment_detail_array is table of t_payment_detail;
/

create or replace type t_client_data is object
(
  field_id number(10),
  field_value varchar2(200 char)
);
/

create or replace type t_client_data_array is table of t_client_data;
/