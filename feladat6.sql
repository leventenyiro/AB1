DROP TABLE dolg2;
CREATE TABLE dolg2 AS SELECT * FROM vzoli.dolgozo;
CREATE TABLE oszt2 AS SELECT * FROM vzoli.osztaly;
--UPDATE dolg2 ...
--Ellenőrzés: SELECT ... FROM dolg2 ...         

-- 6.1 Töröljük azokat a dolgozókat, akiknek jutaléka NULL.
delete from dolg2 where jutalek is null

-- 6.2 Töröljük azokat a dolgozókat, akiknek a belépési dátuma 1982 előtti.
delete from dolg2 where belepes < to_date('1982-01-01', 'yyyy-MM-dd')

-- 6.3 Töröljük azokat a dolgozókat, akik osztályának telephelye DALLAS.
delete from dolg2 where dkod in (select dkod
from dolg2
natural join vzoli.osztaly
where telephely = 'DALLAS')

-- 6.4 Töröljük azokat a dolgozókat, akiknek a fizetése kisebb, mint az átlagfizetés.
delete from dolg2
where fizetes < (select avg(fizetes) from dolg2)

-- 6.5 Töröljük a jelenleg legjobban kereső dolgozót.
delete from dolg2 where fizetes = 
(select max(fizetes) from dolg2)

-- 6.6 Töröljük ki azokat az osztályokat, amelyeknek van olyan dolgozója, aki a 2-es fizetési kategóriába esik (lásd még Fiz_kategoria táblát).
--  (Adjuk meg azon osztályok nevét, amelyeknek van olyan dolgozója, aki a 2-es fizetési kategóriába esik)
delete from gyak6 where oazon in (select distinct oazon
    from vzoli.dolgozo, vzoli.fiz_kategoria
    where fizetes >= also
    and fizetes <= felso
    and kategoria = 2);

-- 6.7 Töröljük ki azon osztályokat, amelyeknek 2 olyan dolgozója van, aki a 2-es fizetési kategóriába esik.
delete from oszt2 where oazon in (select oazon from dolg2, fiz_kategoria
    where fizetes >= also
    and fizetes <= felso
    and kategoria = 2
    group by oazon
    having count(*) = 2)

-- INSERT