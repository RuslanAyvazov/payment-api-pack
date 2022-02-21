-- create table
create table client
(
  client_id         number(30)                        not null,
  is_active         number(1)    default 1            not null,
  is_blocked        number(1)    default 0            not null,
  blocked_reason    varchar2(1000 char),
  create_dtime_tech timestamp(6) default systimestamp not null,
  update_dtime_tech timestamp(6) default systimestamp not null
);

-- add comments to the table 
comment on table client                    is 'Клиент';
-- add comments to the columns 
comment on column client.client_id         is 'Уникальный ID клиента';
comment on column client.is_active         is 'Активен ли клиент. 1 - да, 0 - нет.';
comment on column client.is_blocked        is 'Заблокирован ли клиент. 1 - да, 0 - нет.';
comment on column client.blocked_reason    is 'Причина блокировки'; 
comment on column client.create_dtime_tech is 'Техническое поле. Дата создания записи';
comment on column client.update_dtime_tech is 'Техническое поле. Дата обновления записи';

-- create/recreate primary, unique and foreign key constraints 
alter table client add constraint client_pk primary key (client_id);

-- create/recreate check constraints 
alter table client add constraint client_active_chk       check (is_active in (0, 1));
alter table client add constraint client_blocked_chk      check (is_blocked in (0, 1));
alter table client add constraint client_block_reason_chk check ((is_blocked = 1 and blocked_reason is not null) or (is_blocked = 0));
alter table client add constraint client_tech_dates_chk   check (create_dtime_tech <= update_dtime_tech);

