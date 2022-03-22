-- SZERET
-- 1.8 Kik szeretnek legalább kétféle gyümölcsöt?
select nev
from vzoli.szeret
group by nev
having count(gyumolcs) >= 2

-- 1.9 Kik szeretnek legalább háromféle gyümölcsöt?
select nev
from vzoli.szeret
group by nev
having count(gyumolcs) >= 3

-- 1.10 Kik szeretnek legfeljebb kétféle gyümölcsöt?
select nev
from vzoli.szeret
group by nev
having count(gyumolcs) <= 2

-- 1.11 Kik szeretnek pontosan kétféle gyümölcsöt?
select nev
from vzoli.szeret
group by nev
having count(gyumolcs) = 2

-- DOLGOZO
-- 2.17 Adjuk meg azoknak a főnököknek a nevét, akiknek a foglalkozása nem 'MANAGER'. (dnev)
select distinct fonok.dnev
from dolgozo dolg, dolgozo fonok
where dolg.fonoke = fonok.dkod
    and fonok.foglalkozas not like 'MANAGER'

-- 2.18 Adjuk meg azokat a dolgozókat, akik többet keresnek a főnöküknél.
select *
from dolgozo dolg, dolgozo fonok
where dolg.fonoke = fonok.dkod
    and dolg.fizetes > fonok.fizetes

-- 2.19 Kik azok a dolgozók, akik főnökének a főnöke KING?
select *
from dolgozo d1, dolgozo d2, dolgozo d3
where d1.fonoke = d2.dkod
    and d2.fonoke = d3.dkod
    and d3.dnev like 'KING'

-- 2.20 Kik azok a dolgozók, akik osztályának telephelye DALLAS vagy CHICAGO?
select *
from dolgozo d
natural join osztaly o
where o.telephely in ('DALLAS', 'CHICAGO')

-- 2.21 Kik azok a dolgozók, akik osztályának telephelye nem DALLAS és nem CHICAGO?
select *
from dolgozo d
natural join osztaly o
where o.telephely not in ('DALLAS', 'CHICAGO')

-- 2.22 Adjuk meg azoknak a nevét, akiknek a fizetése > 2000 vagy a CHICAGO-i osztályon dolgoznak.
select *
from dolgozo d
natural join osztaly o
where d.fizetes > 2000 or o.telephely like 'CHICAGO'

-- 2.23 Melyik osztálynak nincs dolgozója?
select oazon from osztaly
minus
select distinct oazon from dolgozo

-- 2.24 Adjuk meg azokat a dolgozókat, akiknek van 2000-nél nagyobb fizetésű beosztottja.
select distinct d2.*
from dolgozo d1, dolgozo d2
where d1.fonoke = d2.dkod
    and d1.fizetes > 2000

-- 2.25 Adjuk meg azokat a dolgozókat, akiknek nincs 2000-nél nagyobb fizetésű beosztottja.
select distinct d2.dnev
from dolgozo d1, dolgozo d2
where d1.fonoke = d2.dkod
minus
select distinct d2.dnev
from dolgozo d1, dolgozo d2
where d1.fonoke = d2.dkod
    and d1.fizetes > 2000;

-- 2.26 Adjuk meg azokat a telephelyeket, ahol van elemző (ANALYST) foglalkozású dolgozó.
select distinct osztaly.* from dolgozo, osztaly
where dolgozo.oazon = osztaly.oazon
    and foglalkozas like 'ANALYST'

-- 2.27 Adjuk meg azokat a telephelyeket, ahol nincs elemző (ANALYST) foglalkozású dolgozó.
select * from osztaly
minus
select distinct osztaly.* from dolgozo, osztaly
where dolgozo.oazon = osztaly.oazon
    and foglalkozas like 'ANALYST'

-- 2.28 Adjuk meg azoknak a dolgozóknak a nevét, akiknek a legnagyobb a fizetésük.
select dnev
from dolgozo
where fizetes in (select max(fizetes)
    from dolgozo)