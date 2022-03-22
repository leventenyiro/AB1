-- 1.1 Mekkora a maximális fizetés a dolgozók között?
select max(fizetes)
from dolgozo

-- 1.2 Mennyi a dolgozók összfizetése?
select sum(fizetes)
from dolgozo

-- 1.3 Mennyi a 20-as osztályon az összfizetes és az átlagfizetés? (Atlag, Össz)
select sum(fizetes), avg(fizetes)
from dolgozo
where oazon = 20


-- 1.4 Adjuk meg, hogy hány különböző foglalkozás fordul elő a dolgozók között. 
select count(distinct foglalkozas)
from dolgozo
where foglalkozas <> 'null'

-- 1.5 Hány olyan dolgozó van, akinek a fizetése > 2000? 
select count(*)
from dolgozo
where fizetes > 2000

-- 1.6 Adjuk meg osztályonként az átlagfizetést (oazon, atl_fiz).
select oazon, avg(fizetes) atl_fiz
from dolgozo
group by oazon

-- 1.7 Adjuk meg osztályonként a telephelyet és az átlagfizetést (oazon, telephely, atl_fiz).
select oazon, telephely, (select avg(fizetes) from dolgozo group by oazon having oazon = o.oazon)
from osztaly o

-- VAGY

SELECT dolgozo.oazon, osztaly.telephely, avg(dolgozo.fizetes) FROM dolgozo LEFT JOIN osztaly ON osztaly.oazon = dolgozo.oazon group by dolgozo.oazon, osztaly.telephely

-- 1.8 Adjuk meg, hogy az egyes osztályokon hány ember dolgozik. (oazon, mennyi)
select oazon, count(*)
from dolgozo
group by oazon

-- 1.9 Adjuk meg azokra az osztályokra az átlagfizetést, ahol ez nagyobb mint 2000. (oazon, atlag)
select oazon, avg(fizetes)
from dolgozo
group by oazon
having avg(fizetes) > 2000

-- 1.10 Adjuk meg az átlagfizetést azokon az osztályokon, ahol legalább 4-en dolgoznak (oazon, atlag)
select oazon, avg(fizetes)
from dolgozo
group by oazon
having count(*) >= 4

-- 1.11 Adjuk meg az átlagfizetést és telephelyet azokon az osztályokon, ahol legalább 4-en dolgoznak. (oazon, telephely, atlag)
select oazon, avg(fizetes), (select telephely from osztaly where oazon = d.oazon)
from dolgozo d
group by oazon
having count(*) >= 4

-- 1.12 Adjuk meg azon osztályok nevét és telephelyét, ahol az átlagfizetés nagyobb mint 2000. (onev, telephely)
select oazon, avg(fizetes), (select telephely from osztaly where oazon = d.oazon)
from dolgozo d
group by oazon
having avg(fizetes) > 2000

-- 1.13 Adjuk meg azokat a fizetési kategóriákat, amelybe pontosan 3 dolgozó fizetése esik.
select (select onev from osztaly where oazon = d.oazon), (select telephely from osztaly where oazon = d.oazon)
from dolgozo d
group by oazon
having avg(fizetes) > 2000

-- 1.14 Adjuk meg azokat a fizetési kategóriákat, amelyekbe eső dolgozók mindannyian ugyanazon az osztályon dolgoznak. (kategoria)
select *
from dolgozo, fiz_kategoria
where fizetes >= also
    and fizetes <= felso
-- MÉG NINCS KÉSZ

-- 1.15 Adjuk meg azon osztályok nevét és telephelyét, amelyeknek van 1-es fizetési kategóriájú dolgozója. (onev, telephely)


-- 1.16 Adjuk meg azon osztályok nevét és telephelyét, amelyeknek legalább 2 fő 1-es fizetési kategóriájú dolgozója van.

-- 1.17 (Feladatgyűjtemény: 2.17 feladat) Készítsünk listát a páros és páratlan azonosítójú (dkod) dolgozók számáról. (paritás, szám)

-- 1.18 (Feladatgyűjtemény: 2.23 feladat) Listázzuk ki foglalkozásonként a dolgozók számát, átlagfizetését (kerekítve) numerikusan és grafikusan is. 200-anként jelenítsünk meg egy '#'-ot. (foglalkozás, szám, átlag, grafika)