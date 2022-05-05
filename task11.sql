--select hova from jaratok where honnan = 'Denver'

-- közvetett járatok
/*select distinct j2.hova from jaratok j1, jaratok j2
where j1.honnan = 'Denver' and j1.hova = j2.honnan*/

/*select  LPAD(' ', 4*(LEVEL-1)) ||nev, apja, vagyon
from nikovits.vagyonok
start with nev = 'ABEL'
CONNECT BY PRIOR apja = nev;*/

select  LPAD(' ', 4*(LEVEL-1)) ||nev, apja, vagyon
from nikovits.vagyonok
where level = 3 -- kain unokái
start with nev = 'KAIN'
CONNECT BY PRIOR nev = apja;

-- egy feladat rekurzív lesz

