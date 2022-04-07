ACCEPT v2 date format 'yyyy.mm.dd' default "1982.01.01" prompt 'dátum (formátum: 2013.01.30)' -- ez törzsanyag
set verify on
set serveroutput on
declare v_oss

-- orai feladat
create or replace function get_foglalkozas(input_onev varchar) return varchar is
    foglalkozasok varchar(100);
begin
    for item in (select distinct foglalkozas
        from dolgozo
        natural join osztaly
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
