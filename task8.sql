set serveroutput on -- kiíratás, alapbeállítása off
begin
    dbms_output.put_line('Hello');
end;

-- számosság
set serveroutput on -- kiíratás, alapbeállítása off
declare l_db number(3); --local
begin
    select count(*) into l_db from dolgozo; --implicit groupby
    dbms_output.put_line('Db: ' || l_db);
end;

-- struktúra
set serveroutput on
declare
    l_sor dolgozo%rowtype;
begin
    select * into l_sor from dolgozo where dkod = 7900;
    dbms_output.put_line('Dolgozo: ' || l_sor.dnev);
end;

-- típuslekérés
set serveroutput on
declare
    l_fiz dolgozo.fizetes%type; --le lehet kérni a típusát
begin
    select fizetes into l_fiz from dolgozo where dkod = 7900;
    dbms_output.put_line('Fizetes: ' || l_fiz);
end;

-- rollback
set serveroutput on
declare
    l_dkod number := 8001;
begin
    l_dkod := 8001;
    delete from dolgozo where dkod = l_dkod;
    dbms_output.put_line(sql%rowcount || ' rows deleted.');
    rollback; -- visszavonás
end;

-- exception
set serveroutput on
declare
    v number := 0;
begin
    dbms_output.put_line('Ez még lefutott...');
    v := 1/v;
    dbms_output.put_line('Ez már nem fog...');

exception
    when others then
        dbms_output.put_line('Nullával való osztás.');
end;

-- órai feladat
--create table GYAK8 as (select dkod, dnev from vzoli.dolgozo where mod(dkod, 2) = 0
--function is_prime
create or replace function prim(n integer) return number is
    i number;
    temp number;
begin
i := 2;
temp := 1;

  for i in 2..n/2
    loop
        if mod(n, i) = 0
        then
            temp := 0;
            exit;
        end if;
    end loop;
   
    if temp = 1
    then
        return 1;
    else
        return 0;
    end if;
end;

create table gyak8 as select * from vzoli.dolgozo where prim(dkod) = 1;