create or replace package body payment_common_pack is

g_enable_manual_changes boolean := false;  --разрешены ли изменения объектов не через API

--включение разрешения менять вручную данные объектов
procedure enable_manual_changes is 
begin
  g_enable_manual_changes := true;
end;

--отключение разрешения менять вручную данные объектов
procedure disable_manual_changes is
begin
  g_enable_manual_changes := false;  
end;

--разрешены ли ручные изменения на глобальном уровне
function is_manual_changes_allowed return boolean is
begin
  return g_enable_manual_changes;
end;

end payment_common_pack;
/