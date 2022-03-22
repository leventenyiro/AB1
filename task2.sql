-- 1.  Kik azok a dolgozók, akiknek a fizetése nagyobb, mint 2800?
π dnev, dkod σ fizetes > 2800 Dolgozo

-- egyéb
select dnev, dkod from dolgozo
where jutalek > 600
union
select dnev, dkod from dolgozo
where jutalek <= 600
--
select dnev, dkod from dolgozo
where jutalek is null
union
select dnev, dkod from dolgozo
where jutalek is not null

select dnev, belepes from dolgozo where belepes >= to_date('1982.01.01', 'yyyy.mm.dd')


select dnav, fizetes from dolgozo where dnav like '%L%L%'
order by 2 desc, 1 desc;

select d1.dnev Beosztott, d2.dnev Kozv_Fonoke
from dolgozo d1, dolgozo d2, dolgozo d3
where d1.dkod=d2.fonoke
and d2.fonoke=d3.dkod;

select d1.dnev Beosztott, d2.dnev Kozv_Fonoke
from dolgozo d1, dolgozo d2
where d1.fonoke=d2.dkod
and d1.fizetes > d2.fizetes;

select dnev, fizetes from dolgozo
where mod(fizetes, 15) = 0;

select *
from dolgozo, fiz_kategoria
where fizetes >= also
and fizetes <= felso;

select *
from dolgozo, fiz_kategoria
where fizetes between also and felso;

select * 
from dolgozo d, osztaly o
where d.oazon=o.oazon;

select *
from dolgozo natural join osztaly;

-- orai munka
create table gyak2 as
select nev from vzoli.szeret
where gyumolcs = 'alma'
intersect
select nev from vzoli.szeret
where gyumolcs = 'körte';
GRANT select on gyak2 to PUBLIC;