select *
from dolgozo natural join osztaly

select *
from dolgozo, osztaly
where dolgozo.oazon = osztaly.oazon (+);
union
select *
from dolgozo, osztaly
where dolgozo.oazon (+) = osztaly.oazon;
--
select *
from dolgozo join osztaly using (oazon)
--
select *
from dolgozo join osztaly on (dolgozo.oazon = osztaly.oazon)

-- cross join - végesszámú

where dolgozo.oazon = osztaly.oazon

-- megerőltetem, hogy ne legyen veszteség - aki még nincs osztályhoz rendelve
-- null értékkel kiegészíti
select *
from dolgozo
left outer join osztaly on (dolgozo.oazon = osztaly.oazon)

-- right: jobboldali táblának, ha lenne veszteséges sora, nem hagyja veszni - akinek még nincs dolgozója
select *
from dolgozo
right outer join osztaly on (dolgozo.oazon = osztaly.oazon)

-- full: mind a jobb mind a bal oldali tábla, csak outer joinban lehet
select NVL(onev, 'nincs osztalyhoz rendelve'), NVL(dnev, 'nincs dolgozoja')
from dolgozo
full outer join osztaly on (dolgozo.oazon = osztaly.oazon)

-- Subquery (allekérdezés)

-- gyak5
DROP TABLE SZERET; 

CREATE TABLE SZERET
    (NEV         VARCHAR2(15),
     GYUMOLCS    VARCHAR2(15));

INSERT INTO SZERET VALUES ('Malacka','alma');
INSERT INTO SZERET VALUES ('Micimackó','alma');
INSERT INTO SZERET VALUES ('Malacka','körte');
INSERT INTO SZERET VALUES ('Micimackó','körte');
INSERT INTO SZERET VALUES ('Kanga','körte');
INSERT INTO SZERET VALUES ('Tigris','körte');
INSERT INTO SZERET VALUES ('Micimackó','málna');
INSERT INTO SZERET VALUES ('Malacka','málna');
INSERT INTO SZERET VALUES ('Kanga','málna');
INSERT INTO SZERET VALUES ('Tigris','málna');
INSERT INTO SZERET VALUES ('Nyuszi','eper');
INSERT INTO SZERET VALUES ('Malacka','eper');

COMMIT; 

GRANT SELECT ON SZERET TO PUBLIC;

CREATE TABLE gyak5 AS SELECT * FROM szeret;
GRANT SELECT on gyak5 to public

-- feladat 12 - órai munka
create table gyak5 as select nev
from szeret
GROUP BY nev
having count(gyumolcs) = (SELECT count(distinct gyumolcs) as gyumolcsszam FROM szeret);

GRANT SELECT ON gyak5 TO PUBLIC;



select onev, sum(fizetes)
from dolgozo natural join osztaly
group by onev
having sum(fizetes) > 10000;

select *
from (select onev, sum(fizetes) ossz
    from dolgozo natural join osztaly
    group by onev)
where ossz > 10000

-- ez nem egy átlátható példa
select *
from (select onev, sum(fizetes) ossz
    from dolgozo natural join osztaly
    group by onev)
where ossz > (select sum(ossz) / count(*)
        from (select onev, sum(fizetes) ossz 
            from dolgozo 
            natural join osztaly
            group by onev))

-- kiknek van a legkevesebb fizuja - sokféleképp lehet
select *
from dolgozo
where fizetes = (select min(fizetes)
    from dolgozo)

select *
from dolgozo natural join (select min(fizetes), fizetes from dolgozo)

select *
from dolgozo join (select min(fizetes), fizetes from dolgozo) using (fizetes)

select fizetes, dnev from dolgozo
minus
select dl.fizetes, d1.dnev
from dolgozo dl, dolgozo d2
where d1.fizetes > d2.fizetes