-- create table
create table client_data_field
(
  field_id    number(10)         not null,
  name        varchar2(100 char) not null,
  description varchar2(200 char) not null
);

-- add comments to the table 
comment on table client_data_field              is 'Справочник полей данных клиента';
-- add comments to the columns 
comment on column client_data_field.field_id    is 'Уникальный ID поля'; 
comment on column client_data_field.name        is 'Название - код';
comment on column client_data_field.description is 'Описание';

-- create/recreate primary, unique and foreign key constraints 
alter table client_data_field add constraint client_data_field_pk       primary key (field_id);

-- create/recreate check constraints 
alter table client_data_field add constraint client_data_field_name_chk check (name = upper(name));

--filling table
insert into client_data_field(field_id, name, description) values(1, 'EMAIL',        'E-mail пользователя');
insert into client_data_field(field_id, name, description) values(2, 'MOBILE_PHONE', 'Номер мобильного телефона');
insert into client_data_field(field_id, name, description) values(3, 'INN',          'ИНН');
insert into client_data_field(field_id, name, description) values(4, 'BIRTHDAY',     'Дата рождения');
commit;