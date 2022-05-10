-- akik a n számú osztályon dolgoznak
create or replace procedure dolgozo_osztaly(n number) is
    cursor c1 is select * from dolgozo where oazon = n;
    rec c1%rowtype;
    --type t_tab is table of record(dolgozo.dnev%type) index by pls_integer;
    --v_tab t_tab;
    --cnt pls_integer := 0;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        --v_tab(cnt) := rec.dnev;
        --cnt := cnt + 1;
        dbms_output.put_line(rec.dkod || ' ' || rec.dnev);
    end loop;
    close c1;
end;

set serveroutput on
call dolgozo_osztaly(20);


-- akik a n számú osztályon dolgoznak
create or replace procedure dolgozo_osztaly(n number) is
    cursor c1 is select * from dolgozo where oazon = n;
    rec c1%rowtype;
    type t_tab is table of dolgozo.dnev%type index by pls_integer;
    v_tab t_tab;
    cnt pls_integer := 0;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        v_tab(cnt) := rec.dnev;
        cnt := cnt + 1;
    end loop;
    close c1;
    
    for i in 0..cnt loop
        dbms_output.put_line(v_tab(i));
    end loop;
end;

set serveroutput on
call dolgozo_osztaly(20);

-- akik a n számú osztályon dolgoznak
create or replace procedure dolgozo_osztaly(n number) is
    cursor c1 is select dnev from dolgozo where oazon = n;
    type t_tab is table of dolgozo.dnev%type index by pls_integer;
    v_tab t_tab;
    l_index pls_integer := 0;
begin
    open c1;
    fetch c1 bulk collect into v_tab;
    close c1;
    
    l_index := v_tab.first;
    while l_index is not null loop
        dbms_output.put_line(v_tab(l_index));
        l_index := v_tab.next(l_index);
    end loop;
end;

set serveroutput on
call dolgozo_osztaly(20);


-- VÉGLEGES
create or replace procedure dolgozo_osztaly(n number) is
    cursor c1 is select dkod, dnev from dolgozo where oazon = n;
    type emp_rec_type is record(dk dolgozo.dkod%type, dn dolgozo.dnev%type);
    type t_tab is table of emp_rec_type index by pls_integer;
    v_tab t_tab;
    l_index pls_integer;
    v_tab_empty_error exception;
begin
    open c1;
    fetch c1 bulk collect into v_tab;
    close c1;
    
    l_index := v_tab.first;
    if l_index is null then
        raise v_tab_empty_error;
    end if;
    while l_index is not null loop
        dbms_output.put_line(v_tab(l_index).dk || ' ' || v_tab(l_index).dn);
        l_index := v_tab.next(l_index);
    end loop;
    exception
        when v_tab_empty_error then
            dbms_output.put_line('Nincs ezen az osztalyon dolgozo');
end;

set serveroutput on
call dolgozo_osztaly(20);

-- hierarchical queries
select distinct apja from nikovits.vagyonok connect by prior nev = apja;

select nev, apja from nikovits.vagyonok
start with nev = 'ADAM'
connect by prior nev = apja;
