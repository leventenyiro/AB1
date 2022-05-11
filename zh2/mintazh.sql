-- 1.
create or replace procedure feladat1(str varchar) is
    cursor c1 is select dkod, fizetes from dolgozo join osztaly on dolgozo.oazon = osztaly.oazon where onev like ('%'||str);
    str_length_error exception;
begin
    if length(str) <> 2 then
        raise str_length_error;
    end if;
    
    for sor in c1 loop
        dbms_output.put_line(sor.dkod);
        update dolgozo set fizetes = fizetes * 1.15 where fizetes >= 4000 and dkod = sor.dkod;
    end loop;
    
    rollback;
    
    exception
        when str_length_error then
            dbms_output.put_line('A bemenetnek 2 karakternek kell lennie!');
end;

set serveroutput on
execute feladat1('NG');

-- 2.
-- https://docs.oracle.com/cd/B19306_01/server.102/b14200/queries003.htm
create or replace function prim(num integer) return varchar2 as
isPrime boolean := TRUE;
begin
for i in 2..sqrt(num) loop
if mod(num, i) = 0 then
isPrime := FALSE;
end if;
end loop;

if isPrime = TRUE then
return 'TRUE';
else
return 'FALSE';
end if;
end;

CREATE OR REPLACE PROCEDURE feladat2(input_dnev varchar) IS
    cursor c1 is select distinct dkod, dnev
        from vzoli.dolgozo
        where dnev <> 'KING'
        start with dnev = 'KING'
        connect by prior dkod = fonoke;
    rec c1%rowtype;
    str_is_prime varchar(200);
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        if PRIM(rec.dkod) = 'TRUE' then
            str_is_prime := 'prim';
        else
            str_is_prime := 'nem prim';
        end if;
        dbms_output.put_line(rec.dnev || ' ' || str_is_prime);
    end loop;
    close c1;
end;

execute feladat2('KING');

-- 3.
CREATE OR REPLACE PROCEDURE dolgozo_abc IS
    cursor c1 is select dkod, dnev, fizetes from vzoli.dolgozo order by dnev;
    rec c1%rowtype;
    type emp_rec_type is record(dn dolgozo.dnev%type, fiz dolgozo.fizetes%type);
    type t_tab is table of emp_rec_type index by pls_integer;
    v_tab t_tab;
    l_index pls_integer := 0;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        if mod(rec.dkod, 2) = 1 then
            v_tab(l_index).dn := rec.dnev;
            v_tab(l_index).fiz := rec.fizetes;
            l_index := l_index + 1;
        end if;
    end loop;
    close c1;
    
    dbms_output.put_line(v_tab(l_index - 2).dn || ' ' ||  v_tab(l_index - 2).fiz);
end;

set serveroutput on
execute dolgozo_abc();

-- 4.
create or replace procedure feladat4 is
    cursor c1 is select distinct apja from nikovits.vagyonok where connect_by_root vagyon < vagyon connect by prior nev = apja;
    rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        dbms_output.put_line(rec.apja);
    end loop;
    close c1;
end;

execute feladat4();

-- 5.
create or replace procedure feladat5(str varchar) is
    cursor c1 is select max(fizetes) - min(fizetes) as kulonbseg 
        from vzoli.dolgozo d
        join vzoli.osztaly o
        on d.oazon = o.oazon
        where o.telephely like str;
    rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        dbms_output.put_line(rec.kulonbseg);
    end loop;
    close c1;
end;

execute feladat5('NEW YORK');
