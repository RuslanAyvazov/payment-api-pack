-- create table
create table payment
(
  payment_id           number(38)                              not null,
  create_dtime         timestamp(6)                            not null,
  summa                number(30,2)                            not null,
  currency_id          number(3)                               not null,
  from_client_id       number(30)                              not null,
  to_client_id         number(30)                              not null,
  status               number(10)         default 0            not null,
  status_change_reason varchar2(200 char),
  create_dtime_tech    timestamp(6)       default systimestamp not null,
  update_dtime_tech    timestamp(6)       default systimestamp not null
);

-- add comments to the table 
comment on table payment                       is 'Платеж';
-- add comments to the columns 
comment on column payment.payment_id           is 'Уникальный ID платежа';
comment on column payment.create_dtime         is 'Дата создания платежа';
comment on column payment.summa                is 'Сумма платежа';
comment on column payment.currency_id          is 'В какой валюте производился платеж';
comment on column payment.from_client_id       is 'Клиент-отправитель'; 
comment on column payment.to_client_id         is 'Клиент-получатель';
comment on column payment.status               is 'Статус платежа. 0 - создан, 1 - проведен, 2 - ошибка проведения, 3 - отмена платежа';
comment on column payment.status_change_reason is 'Причина изменения стуса платежа. Заполняется для статусов "2" и "3"';
comment on column payment.create_dtime_tech    is 'Техническое поле. Дата создания записи';
comment on column payment.update_dtime_tech    is 'Техническое поле. Дата обновления записи';

-- create/recreate indexes 
create index payment_from_client_i on payment (from_client_id);
create index payment_to_client_i on payment (to_client_id);

-- create/recreate primary, unique and foreign key constraints 
alter table payment add constraint payment_pk                primary key (payment_id);
alter table payment add constraint payment_currency_id_fk    foreign key (currency_id)    references currency (currency_id);
alter table payment add constraint payment_from_client_id_fk foreign key (from_client_id) references client (client_id);
alter table payment add constraint payment_to_client_id_fk   foreign key (to_client_id)   references client (client_id);

-- create/recreate check constraints 
alter table payment add constraint payment_reason_chk     check ((status in (2,3) and status_change_reason is not null) or (status not in (2, 3)));
alter table payment add constraint payment_status_chk     check (status in (0, 1, 2, 3));
alter table payment add constraint payment_tech_dates_chk check (create_dtime_tech <= update_dtime_tech);
