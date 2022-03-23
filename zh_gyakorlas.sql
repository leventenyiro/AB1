/* jegyzet
    delta jelentése: distinct

*/
π A, ad γ A; AVG(S.D)→ad σ R.B ≥ 2 ( R ⨯ S )
γ A; AVG(D) → av (σ B >= 2 (R x S))

-- 1.2
SELECT A, avg(D) as av FROM R natural join S group by A having av > 10
π A, av σ av > 10 γ A; AVG(D)→av ( R ⨝ S )

--1.3
SELECT distinct A as A FROM R, S WHERE R.C = S.C
ρ A←A π A σ R.C = S.C ( R ⨯ S )

-- 1.4
select A, C from R where B = 2 order by A
τ A asc π A, C σ B = 2 R

-- 1.5
select distinct A, B from R, S where R.C = S.C and D = 1

-- 1.6
select A from R 
except 
select A from R, S where R.C = S.C

-- 2.1
    -- X 3
    -- Y 4
select A, AVG(C) as av from R where B >= 2 group by A

-- 2.2
select A, B, SUM(C) as su from R group by A, B

-- 2.3
select A, SUM(B) as sub, SUM(C) as suc from R group by A

-- 2.4
select A, B from R where C >= 4 order by B, A

-- 2.5
select distinct A, B from R where B >= 2

-- 2.7
select lf.minfonfiz, kategoria
from (select min(fonok.fizetes) as minfonfiz
    from Dolgozo as dolg, Dolgozo as fonok
    where dolg.fonoke = fonok.dkod) as lf, Fiz_kategoria
where lf.minfonfiz >= also and lf.minfonfiz <= felso

-- 2.8
select d.foglalkozas, o.onev
from dolgozo d
left join osztaly o on d.oazon = o.oazon
where foglalkozas = 
    (select foglalkozas
    from dolgozo
    group by foglalkozas
    having count(oazon) = 1)