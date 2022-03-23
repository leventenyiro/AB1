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

-- órai feladat
CREATE TABLE gyak1 AS SELECT * from vzoli.szeret;
GRANT SELECT ON gyak1 TO PUBLIC;


-- CTAS
create table gyak2 as select * from gyak1

-- 1
SELECT GYUMOLCS FROM SZERET WHERE NEV LIKE "Micimackó"

SELECT GYUMOLCS 
FROM GYAK1
MINUS
SELECT DISTINCT GYUMOLCS FROM GYAK1
WHERE NEV = "Micimackó"

-- direktszorzat
select distinct s1.nev
from gyak1 s1, gyak2 s2
where s1.nev = s2.nev
and s1.gyumolcs = s2.gyumolcs
