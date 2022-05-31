-- nevek, akik moszkvai kiadású könyveket olvasnak
select nev
from szemely sz
inner join konyv ko on sz.isbn = ko.isbn
inner join kiad ki on ko.cim = ki.k_cim and ko.iro = ki.k_iro
where sz.kor = 20 and ki.varos = "Moszkva"

-- opcionálisabb lekérés
select nev
from (select nev, isbn from szemely sz where kor = 20 inner join
    (select isbn from konyv ko inner join (select k_cim, k_iro from kiado ki where ki.varos = "Moszkva") on cim = k_cim and iro = k_iro) as ko
    on isbn = ko.isbn)

-- akik 1000 forintos könyvet vásároltak és még nincsenek 40 évesek vagy moszkvaiak és orosz kiadású könyvet vettek

-- IN
-- EXISTS
-- ANY
-- ALL <>, =, >=
-- UNION, INTERSECT, MINUS - EXCEPT