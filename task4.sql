-- CTAS
create table dolgozo as select * from vzoli.dolgozo
create table osztaly AS (select * from nikovits.osztaly)
create table fiz_kategoria AS (select * from nikovits.fiz_kategoria)

-- beépített adatok
select sysdate from dual
select trunc(sysdate, 'month'), to_char(trunc(sysdate, 'month'), 'day') from dual
select rpad('#', round(1200, -3) / 1000, '#') from dual

-- egy oszlopban legyenek
select round(10/100, 2), to_char(round(10/100, 2), '0.99') from dual

-- feladat3.txt utolsóelőtti
select distinct onev, telephely
from dolgozo
natural join osztaly, fiz_kategoria
where fizetes between also and felso and kategoria = 1

-- feladat3.txt utolsó
select onev, telephely
from osztaly;

minus

select distinct onev, telephely
from dolgozo
natural join osztaly, fiz_kategoria
where fizetes between also and felso and kategoria = 1

-- létezik legalább 1-es fizkategóriája
select *
from (select distinct oazon
        from dolgozo, fiz_kategoria
        where fizetes between also and felso
        and kategoria = 1)

--
select *
from osztaly
where oazon = (select distinct min(oazon)
        from dolgozo, fiz_kategoria
        where fizetes between also and felso
        and kategoria = 1)
-- legalább egy esetben true
select *
from osztaly
where oazon IN (select distinct oazon
        from dolgozo, fiz_kategoria
        where fizetes between also and felso
        and kategoria = 1)

select *
from osztaly
where oazon NOT IN (select distinct oazon
        from dolgozo, fiz_kategoria
        where fizetes between also and felso
        and kategoria = 1)

-- biztos nincs a jobb és a bal oldalon se
select *
from osztaly
where nvl(oazon, 0) NOT IN (select distinct nvl(oazon, 0)
        from dolgozo, fiz_kategoria
        where fizetes between also and felso
        and kategoria = 1)