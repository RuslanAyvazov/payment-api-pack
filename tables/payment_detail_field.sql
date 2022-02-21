-- create table
create table payment_detail_field
(
  field_id    number(10)         not null,
  name        varchar2(100 char) not null,
  description varchar2(200 char) not null
);

-- add comments to the table 
comment on table payment_detail_field              is 'Справочник полей данных платежа';
-- add comments to the columns 
comment on column payment_detail_field.field_id    is 'Уникальный ID поля'; 
comment on column payment_detail_field.name        is 'Название - код';
comment on column payment_detail_field.description is 'Описание';

-- create/recreate primary, unique and foreign key constraints 
alter table payment_detail_field add constraint payment_detail_field_pk       primary key (field_id);

-- create/recreate check constraints 
alter table payment_detail_field add constraint payment_detail_field_name_chk check (name = upper(name));

--filling data
insert into payment_detail_field(field_id, name, description) values (1, 'CLIENT_SOFTWARE',  'Софт, через который совершался платеж');
insert into payment_detail_field(field_id, name, description) values (2, 'IP',               'IP адрес плательщика');
insert into payment_detail_field(field_id, name, description) values (3, 'NOTE',             'Примечание к переводу');
insert into payment_detail_field(field_id, name, description) values (4, 'IS_CHECKED_FRAUD', 'Проверен ли платеж в системе "АнтиФрод"');
commit;