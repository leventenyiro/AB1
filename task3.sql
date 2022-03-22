-- orai munka
create table gyak3 as
select dolgozo.dnev Név, fonok.dnev FőnökNév
from vzoli.dolgozo dolgozo, vzoli.dolgozo fonok
where dolgozo.fonoke = fonok.dkod and length(dolgozo.dnev) = length(fonok.dnev);
GRANT select on gyak3 to PUBLIC;