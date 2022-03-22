-- DOLGOZO
-- 1.1 Adjuk meg azon dolgozókat, akik fizetése osztható 15-tel.
select * from dolgozo
where mod(fizetes, 15) = 0

-- 1.2 Kik azok a dolgozók, akik 1982.01.01 után léptek be a céghez? (Aktuális dátumformátumot lásd -> SYSDATE fv.)
select *
from dolgozo
where belepes > to_date('1982-01-01', 'yyyy-MM-dd')

-- 1.3 Adjuk meg azon dolgozókat, akik nevének második betűje 'A'. (használjuk a substr függvényt)
select *
from dolgozo
where substr(dnev, 2, 1) like 'A'

-- 1.4 Adjuk meg azon dolgozókat, akik nevében van legalább két 'L' betű. (használjuk az instr függvényt)
select *
from dolgozo
where instr(dnev, 'L', 1, 2) <> 0 -- hanyadik karaktertől és hanyadik előfordulás a fontos

-- 1.5 Adjuk meg a dolgozók nevének utolsó három betűjét. (substr fv.)
select substr(dnev, -3)
from dolgozo

-- 1.6 Adjuk meg azon dolgozókat, akik nevének utolsó előtti betűje 'T'. (substr fv.)
select *
from dolgozo
where substr(dnev, -2, 1) = 'T'

-- 1.7 Adjuk meg a dolgozók fizetéseinek négyzetgyökét két tizedesre, és ennek egészrészét. (round, sqrt, trunc fv-ek)
select round(sqrt(fizetes), 2), trunc(round(sqrt(fizetes), 2))
from dolgozo

-- 1.8 Adjuk meg, hogy hány napja dolgozik a cégnél ADAMS és milyen hónapban lépett be. (dátumaritmetika + dátum függvények)
select belepes, trunc(sysdate - belepes)
from dolgozo
where dnev like 'ADAMS'

-- 1.9 Adjuk meg azokat a dolgozókat, akik keddi napon léptek be. (to_char fv.) (Vigyázzunk a visszaadott értékkel, és annak hosszával!)
select *
from dolgozo
where to_char(belepes, 'D') = 2

-- 1.10 Adjuk meg azokat a (név, főnök) párokat, ahol a két ember neve ugyanannyi betűből áll. (length fv.)
select d1.dnev, d2.dnev
from dolgozo d1, dolgozo d2
where d1.fonoke = d2.dkod
    and length(d1.dnev) = length(d2.dnev)

-- 1.11 Adjuk meg azon dolgozókat, akik az 1-es fizetési kategóriába tartoznak.
select *
from dolgozo, fiz_kategoria
where fizetes >= also
    and fizetes <= felso
    and kategoria = 1

-- 1.12 Adjuk meg azon dolgozókat, akiknek a fizetési kategóriája páros szám. (mod() függvény)
select *
from dolgozo, fiz_kategoria
where fizetes >= also
    and fizetes <= felso
    and mod(kategoria, 2) = 0

-- 1.13 Adjuk meg, hogy hány nap volt KING és JONES belépési dátuma között?
select distinct (select belepes
    from dolgozo
    where dnev like 'KING') - (select belepes
    from dolgozo
    where dnev like 'JONES')
from dolgozo

-- 1.14 Adjuk meg, hogy milyen napra esett KING belépési dátuma hónapjának utolsó napja. (last_day() függvény)
select to_char(last_day(belepes), 'D')
from dolgozo
where dnev like 'KING'

-- 1.15 Adjuk meg, hogy milyen napra esett KING belépési dátuma hónapjának első napja. (trunc fv. dátumra)
select to_char(trunc(belepes), 'D')
from dolgozo
where dnev like 'KING'

-- 1.16 Adjuk meg azon dolgozók nevét, akik osztályának nevében van 'C' betű és fizetési kategóriájuk >=4.
select *
from dolgozo, fiz_kategoria
where fizetes >= also
    and fizetes <= felso
    and dnev like '%C%'
    and kategoria >= 4

-- 1.6 példa Listázzuk ki a dolgozók nevét és fizetését, valamint jelenítsük meg a fizetést grafikusan úgy, hogy a fizetést 1000 Ft-ra kerekítve, minden 1000 Ft-ot egy '#' jel jelöl. (például 5000 -> #####, 800 -> #)
select dnev, fizetes, rpad('#', round(fizetes, -3) / 1000, '#')
from dolgozo, fiz_kategoria
where fizetes >= also
    and fizetes <= felso