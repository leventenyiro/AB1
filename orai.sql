CREATE TABLE gyak1 AS SELECT * from vzoli.szeret;
GRANT SELECT ON gyak1 TO PUBLIC;

create table gyak2 as
select nev from vzoli.szeret
where gyumolcs = 'alma'
intersect
select nev from vzoli.szeret
where gyumolcs = 'körte';
GRANT select on gyak2 to PUBLIC;

create table gyak3 as
select dolgozo.dnev Név, fonok.dnev FőnökNév
from vzoli.dolgozo dolgozo, vzoli.dolgozo fonok
where dolgozo.fonoke = fonok.dkod and length(dolgozo.dnev) = length(fonok.dnev);
GRANT select on gyak3 to PUBLIC;

create table gyak4 as
select oazon Oazon, Telephely, avg(fizetes) AtlagFiz
from vzoli.dolgozo
natural join vzoli.osztaly
group by oazon, telephely;
GRANT select on gyak4 to PUBLIC;

create table gyak5 as select nev
from vzoli.szeret
GROUP BY nev
having count(gyumolcs) = (SELECT count(distinct gyumolcs) as gyumolcsszam FROM vzoli.szeret);
GRANT select on gyak5 to PUBLIC;