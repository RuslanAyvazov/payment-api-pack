set serveroutput on

whenever sqlerror continue

prompt =======delete tables for payment=======
drop table payment_detail;
drop table payment_detail_field;
drop table payment;

prompt =======delete tables for client=======
drop table client_data;
drop table client_data_field;
drop table client;

prompt =======delete table for currency=======
drop table currency;

prompt =======delete sequances=======
drop sequence client_seq;
drop sequence payment_seq;

prompt =======delete types=======
drop type t_number_array;
drop type t_payment_detail_array;
drop type t_payment_detail;
drop type t_client_data_array;
drop type t_client_data;

prompt =======delete packages=======

drop package client_api_pack;
drop package client_data_api_pack;
drop package payment_common_pack;
drop package client_common_pack;
drop package payment_api_pack;
drop package payment_detail_api_pack;
drop package ut_client_common_pack;
drop package ut_payment_common_pack;
drop package ut_payment_api_pack;
drop package ut_payment_detail_api_pack;
drop package ut_payment_utils_pack;


exit;