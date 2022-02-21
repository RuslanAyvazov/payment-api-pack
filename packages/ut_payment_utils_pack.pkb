create or replace package body ut_payment_utils_pack is

procedure run_tests(p_package_name user_objects.object_name%type := null) is

  v_text_header varchar2(1000 char);
  v_sql_cmd varchar2(30000 char);
  v_test_header_for_success varchar2(1000 char);
  v_test_header_for_failure varchar2(1000 char);
begin
  <<pkg_loop>>
  for pkg in (select us.text, us.name
              from user_source us 
              where 1 = 1
                        and us.text like ('%--%suite(Unit-tests for payment%') 
                        and us.name = nvl(upper(p_package_name), us.name)
                        and us.name in (upper('ut_payment_api_pack'), upper('ut_payment_detail_api_pack'))
              ) loop
              
    
    dbms_output.put_line('==' || trim(pkg.name)); 
    dbms_output.put_line(trim(pkg.text));       
 
    
    <<prc_loop>>
    for prc in (select 
                  lower('begin ' || pkg.name || '.' || substr(trim(us2.text), instr(trim(us2.text), ' ', 1)+1, length(trim(us2.text))) || 'end;') as text, 
                  trim(us2.text) as text2
                from user_source us2
                where 1 = 1
                          and us2.name = pkg.name
                          and us2.type = 'PACKAGE'
                          and (us2.text like ('%procedure%') or us2.text like ('%--%test%'))
                order by us2.line) loop
     
     if prc.text2 like '%--%test%' then
       v_text_header := prc.text2; 
       v_test_header_for_success := 'Тест "' || substr(v_text_header, instr(v_text_header, '(', 1) + 1, length(v_text_header) - instr(v_text_header, '(', 1) - 2) || '" прошел успешно!';
       v_test_header_for_failure := 'Тест "' || substr(v_text_header, instr(v_text_header, '(', 1) + 1, length(v_text_header) - instr(v_text_header, '(', 1) - 2) || '" не прошел успешно: ';
       continue;
     end if;
     
     v_sql_cmd := prc.text;
     

     
    begin 
      savepoint sp1;
      execute immediate v_sql_cmd;
      rollback to sp1;
      dbms_output.put_line(v_test_header_for_success);
    exception 
      when others then 
        rollback to sp1;
        dbms_output.put_line(v_test_header_for_failure || sqlerrm);   
    end;
   
    end loop prc_loop;
    dbms_output.put_line(null);
    
  end loop pkg_loop;
  rollback;
end;

end ut_payment_utils_pack;
/