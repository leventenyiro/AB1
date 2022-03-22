-- KELL RelaX is

-- 1.1 Kik azok a dolgozók, akiknek a fizetése nagyobb, mint 2800?
select * from dolgozok where fizetes > 2800
π dnev σ fizetes > 2800 Dolgozo

-- 1.2 Kik azok a dolgozók, akik a 10-es vagy a 20-as osztályon dolgoznak?
select * from dolgozok where oazon between 10 and 20
π dnev σ oazon = 10 or oazon = 20 Dolgozo

-- 1.3 Kik azok, akiknek a jutaléka nagyobb, mint 600?
select * from dolgozok where jutalek > 600
π dnev σ jutalek > 600 Dolgozo

-- 1.4 Kik azok, akiknek a jutaléka nem nagyobb, mint 600?
select * from dolgozok where not jutalek > 600
π dnev σ ¬(jutalek > 600) Dolgozo

-- 1.5 Kik azok a dolgozók, akiknek a jutaléka ismeretlen (nincs kitöltve, vagyis NULL)?
select * from dolgozok where jutalek = null
π dnev σ jutalek = null Dolgozo

-- 1.6 Adjuk meg a dolgozók között előforduló foglalkozások neveit.
select distinct foglalkozas from dolgozok
π foglalkozas Dolgozo

-- 1.7 Adjuk meg azoknak a nevét és kétszeres fizetését, akik a 10-es osztályon dolgoznak.
select dnev, fizetes * 2 from dolgozok where oazon = 10

-- 1.8 Kik azok a dolgozók, akik 1982.01.01 után léptek be a céghez?
select * from dolgozok where belepes > '1982.01.01'

-- 1.9 Kik azok, akiknek nincs főnöke?
select * from dolgozok where fonok = null

-- 1.10 Kik azok a dolgozók, akiknek a nevében van 'A' betű?
select * from dolgozok where dnev like "%a%"

-- 1.11 Kik azok a dolgozók, akiknek a nevében van két 'L' betű?
select * from dolgozok where dnev like "%l%l%"

-- 1.12 Kik azok a dolgozók, akiknek a fizetése 2000 és 3000 között van?
select * from dolgozok where fizetes between 2000 and 3000

-- 1.13 Adjuk meg a dolgozók adatait fizetés szerint növekvő sorrendben.
select * from dolgozo order by fizetes asc

-- 1.14 Adjuk meg a dolgozók adatait fizetés szerint csökkenő, azon belül név szerinti sorrendben.
select * from dolgozo order by fizetes desc, dnev asc

-- 1.15 Kik azok a dolgozók, akiknek a főnöke KING? (egyelőre leolvasva a képernyőről)
select * from dolgozo where fonoke = (select dkod from dolgozo where dnev like 'KING')

-- SZERET
-- 2.1 Melyek azok a gyümölcsök, amelyeket Micimackó szeret?
select gyumolcs from vzoli.szeret where nev like 'Micimackó'

-- 2.2 Melyek azok a gyümölcsök, amelyeket Micimackó nem szeret? (de valaki más igen)
select gyumolcs from vzoli.szeret
minus
select gyumolcs from vzoli.szeret where nev like 'Micimackó'

-- 2.3 Kik szeretik az almát?
select nev from vzoli.szeret where gyumolcs like 'alma'

-- 2.4 Kik nem szeretik a körtét? (de valami mást igen)
select nev from vzoli.szeret
minus
select nev from vzoli.szeret where gyumolcs like 'körte'

-- 2.5 Kik szeretik vagy a dinnyét vagy a körtét?
select distinct nev from vzoli.szeret where gyumolcs like 'dinnye' or gyumolcs like 'körte';

select nev from vzoli.szeret where gyumolcs like 'dinnye'
union
select nev from vzoli.szeret where gyumolcs like 'körte'

-- 2.6 Kik szeretik az almát is és a körtét is?
select nev from vzoli.szeret where gyumolcs like 'alma'
intersect
select nev from vzoli.szeret where gyumolcs like 'körte'

-- 2.7 Kik azok, akik szeretik az almát, de nem szeretik a körtét?
select nev from vzoli.szeret where gyumolcs like 'alma'
minus
select nev from vzoli.szeret where gyumolcs like 'körte'