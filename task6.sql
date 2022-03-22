--gamma - distinct
--    minden mindennel
--    X-1
--    Y-2...

--feladat5.pdf egy mintazh

-- orai munka
create table gyak6 as select *
from vzoli.osztaly;

delete from gyak6 where oazon in (select distinct oazon
    from vzoli.dolgozo, vzoli.fiz_kategoria
    where fizetes >= also
    and fizetes <= felso
    and kategoria = 2);
    
COMMIT;

GRANT SELECT ON gyak6 TO PUBLIC;

-- előző órai munka
-- kik nem szeretik az összes gyümölcsöt
select nev from vzoli.szeret
minus
(select distinct nev
from (select * 
    from (select distinct nev from vzoli.szeret), (select distinct gyumolcs from vzoli.szeret)
minus
select * from vzoli.szeret))

-- legszegényebb főnök
select min(fonok.fizetes)
from dolgozo dolg, dolgozo fonok
where dolg.fonoke = fonok.dkod


--COMMIT nélkül félbenlévő tranzakció ablakot dob fel
    -- ezzel véglegesítjük a tranzakciót

-- select - update - select

-- zh: feladat_gyakorlo.txt
CREATE TABLE cikk AS SELECT * FROM nikovits.cikk;
CREATE TABLE projekt AS SELECT * FROM nikovits.projekt;
CREATE TABLE szallito AS SELECT * FROM nikovits.szallito;
CREATE TABLE szallit AS SELECT * FROM nikovits.szallit;

-- alap select tábla
select *
from szallit -- ez az alap tábla
natural join szallito natural join cikk natural join projekt --ezzel tudunk mindent

-- 1. Adjuk meg azon cikkek kódját és nevét, amelyeket valamelyik pécsi ('Pecs') szállító szállít. [ckod, cnev]
select ckod, cnev from szallit
natural join szallito
natural join cikk
where telephely = 'Pecs'

-- másik megoldás tanár
select * from (select distinct ckod from szallit
natural join szallito
where telephely = 'Pecs') natural join cikk