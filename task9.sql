ACCEPT v2 date format 'yyyy.mm.dd' default "1982.01.01" prompt 'dátum (formátum: 2013.01.30)' -- ez törzsanyag
set verify on
set serveroutput on
declare v_oss

-- orai feladat
create or replace function get_foglalkozas(input_onev varchar) return varchar is
    foglalkozasok varchar(100);
begin
    for item in (select distinct foglalkozas
        from vzoli.dolgozo
        natural join vzoli.osztaly
        where onev = input_onev
        order by foglalkozas asc)
    loop
        foglalkozasok := concat(foglalkozasok, item.foglalkozas || '-');
    end loop;
    foglalkozasok := substr(foglalkozasok, 0, length(foglalkozasok) - 1);
    return foglalkozasok;
end;

create table gyak9 as
select distinct onev, get_foglalkozas(onev) as foglalkozasok
from vzoli.dolgozo
natural join vzoli.osztaly
where get_foglalkozas(onev) <> 'NULL';

-- https://people.inf.elte.hu/vzoli/Adatbazisok_1/PLSQL/

-- cursors

set serveroutput on
declare
    cursor c_curs1(oa number) is select oazon, dnev from dolgozo where oazon = oa;
    rec c_curs1%rowtype;
begin
    open c_curs1(10);
    loop
        fetch c_curs1 into rec;
        exit when c_curs1%notfound; -- ha nem található, akkor off
        dbms_output.put_line(to_char(rec.oazon) || ' - ' || rec.dnev);
    end loop;
    close c_curs1;
end;

-- zh: készítsük el azt a tárolt eljárást (procedure)
    -- ilyenkor nem lehet selecttel helyettesíteni
    
-- zh
    -- egymásba ágyazott 2 kurzor
    -- példa pl_03_kurzor.txt
    
-- with
    -- ki szállítja a legtöbb cikket
    -- meg kell nézni ki mit szállít, és meg kell nézni a maxot (2 lépcsős mechanizmu
    -- count distinct kod

-- végig kéne nézni a pdf-eket az sql-ről (with utasítás)
