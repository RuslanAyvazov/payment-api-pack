prompt >>>>> client packages

prompt ==========client_api_pack==========
@@client_api_pack.pks
@@client_api_pack.pkb

prompt ==========client_common_pack==========
@@client_common_pack.pks
@@client_common_pack.pkb

prompt ==========client_data_api_pack==========
@@client_data_api_pack.pks
@@client_data_api_pack.pkb



prompt >>>>> payment packages
prompt ==========payment_api_pack==========
@@payment_api_pack.pks
@@payment_api_pack.pkb

prompt ==========payment_common_pack==========
@@payment_common_pack.pks
@@payment_common_pack.pkb

prompt ==========payment_detail_api_pack==========
@@payment_detail_api_pack.pks
@@payment_detail_api_pack.pkb


ALTER PACKAGE CLIENT_API_PACK         COMPILE;
ALTER PACKAGE CLIENT_DATA_API_PACK    COMPILE;
ALTER PACKAGE PAYMENT_COMMON_PACK     COMPILE;
ALTER PACKAGE CLIENT_COMMON_PACK      COMPILE;
ALTER PACKAGE PAYMENT_API_PACK        COMPILE;
ALTER PACKAGE PAYMENT_DETAIL_API_PACK COMPILE;


