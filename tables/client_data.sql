-- create table
create table client_data
(
  client_id   number(30)         not null,
  field_id    number(10)         not null,
  field_value varchar2(200 char) not null
);

-- add comments to the table 
comment on table client_data              is 'Данные клиента';
-- add comments to the columns 
comment on column client_data.client_id   is 'ID клиента'; 
comment on column client_data.field_id    is 'ID поля';
comment on column client_data.field_value is 'Значение поля (сами данные)';

-- create/recreate indexes 
create index client_data_field_i on client_data (field_id);

-- create/recreate primary, unique and foreign key constraints 
alter table client_data add constraint client_data_pk        primary key (client_id, field_id);
alter table client_data add constraint client_data_client_fk foreign key (client_id)            references client (client_id);
alter table client_data add constraint client_data_field_fk  foreign key (field_id)             references client_data_field (field_id);
