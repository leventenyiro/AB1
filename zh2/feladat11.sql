-- 11.1
/* START WITH CONNECT BY 
Írjunk meg egy procedúrát, amelyik a NIKOVITS.VAGYONOK tábla alapján kiírja azoknak
a személyeknek a nevét, akikre igaz, hogy van olyan leszármazottjuk, akinek nagyobb
a vagyona, mint az illető vagyona. */
CREATE OR REPLACE PROCEDURE gazdag_leszarmazott IS
    cursor c1 is select distinct apja from nikovits.vagyonok where connect_by_root vagyon < vagyon connect by prior nev = apja;
    rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        dbms_output.put_line(rec.apja);
    end loop;
end;

set serveroutput on
execute gazdag_leszarmazott();

-- 11.2
/* Írjunk meg egy procedúrát, amelyik a NIKOVITS.VAGYONOK tábla alapján kiírja azoknak
a személyeknek a nevét, vagyonát, valamint leszármazottainak átlagos vagyonát, akikre igaz, 
hogy a leszármazottainak átlagos vagyona nagyobb, mint az illető vagyona.
A program tehát soronként 3 adatot ír ki: név, vagyon, leszármazottak átlagos vagyona */
create or replace function vagyon_avg(input_nev varchar2) return number is
    res number;
begin
    select avg(vagyon) as atlag into res
    from nikovits.vagyonok
    where level > 1
    start with nev = input_nev
    connect by prior nev = apja
    group by connect_by_root nev;
    
    return res;
end;

CREATE OR REPLACE PROCEDURE gazdag_leszarmazottak IS
    cursor c1 is select nev, vagyon, nvl(vagyon_avg(nev), 0) as leszarmazott from nikovits.vagyonok;
    rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        if rec.vagyon < rec.leszarmazott then
            dbms_output.put_line(rec.nev || ' - ' || rec.vagyon || ' - ' || rec.leszarmazott);
        end if;
    end loop;
end;

set serveroutput on
execute gazdag_leszarmazottak();

-- 11.3
/*
Írjunk meg egy procedúrát, amelyik a NIKOVITS.JARATOK tábla alapján kiírja azoknak az irányított
köröknek a csomópontjait (városait), amelyek a paraméterként megadott várossal kezdődnek és végződnek.
Tetszőleges elválasztó karakter használható. 
Példa egy kiírásra: Dallas-Chicago-Denver-Dallas */
CREATE OR REPLACE PROCEDURE kor_kereso(kezdopont VARCHAR2) IS
    cursor c1 is select connect_by_root honnan as indulas, hova as cel, level as hossz sys_connect_by_path(honnan, '-') || '-' || hova as utvonal
        from nikovits.jaratok
        start with honnan = kezdopont
        connect by nocycle prior hova = honnan and hova = kezdopont
        order by level;
    rec c1%rowtype;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        if rec.indulas = rec.cel then
            dbms_output.put_line(rec.utvonal);
    end loop;
    close c1;
end;

-- nem jó

set serveroutput on
execute kor_kereso('Denver');

-- 11.4
-- https://github.com/Szelethus/Adatbazisok1-2/blob/c22f0426bb6f5776a15b4a98d94001e93cf723a3/adatb1/2zh/feladat10_plsql_megoldasok.txt
