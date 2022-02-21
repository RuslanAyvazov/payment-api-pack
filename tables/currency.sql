-- create table
create table currency
(
  currency_id number(3)          not null,
  alfa3       char(3 char)       not null,
  description varchar2(100 char) not null
);

-- add comments to the table 
comment on table currency              is '—правочник валют (ISO-4217)';
-- add comments to the columns 
comment on column currency.currency_id is '“рЄхзначный цифровой (number-3) код валюты';
comment on column currency.alfa3       is '“рЄхбуквенный алфавитный (alfa-3) код валюты';
comment on column currency.description is 'ќписание валюты';

-- create/recreate primary, unique and foreign key constraints 
alter table currency add constraint currency_pk        primary key (currency_id);

-- create/recreate check constraints 
alter table currency add constraint currency_alfa3_chk check (alfa3 = upper(alfa3));

--filling table
insert into currency(currency_id, alfa3, description) values(634, 'RUB', 'Российский рубль');
insert into currency(currency_id, alfa3, description) values(840, 'USD', 'Доллар США');
insert into currency(currency_id, alfa3, description) values(978, 'EUR', 'Евро');
commit;