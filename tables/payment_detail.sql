-- create table
create table payment_detail
(
  payment_id  number(38)         not null,
  field_id    number(10)         not null,
  field_value varchar2(200 char) not null
);

-- add comments to the table 
comment on table payment_detail              is 'Детали платежа';
-- add comments to the columns 
comment on column payment_detail.payment_id  is 'ID платежа';
comment on column payment_detail.field_id    is 'ID поля';
comment on column payment_detail.field_value is 'Значение поля (сами данные)';

-- create/recreate indexes 
create index payment_detail_field_i on payment_detail (field_id);

-- create/recreate primary, unique and foreign key constraints 
alter table payment_detail add constraint payment_detail_pk         primary key (payment_id, field_id);
alter table payment_detail add constraint payment_detail_field_fk   foreign key (field_id)              references payment_detail_field (field_id);
alter table payment_detail add constraint payment_detail_payment_fk foreign key (payment_id)            references payment (payment_id);
