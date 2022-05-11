-- 10.1
/*  Összetettebb feladat, amely kis gondolkodással egyszerűsíthető
Írjunk meg egy procedúrát, amely a következők szerint módosítja egyes dolgozók fizetését.
Vegyük minden osztályon a legrégebben belépett dolgozót, és növeljük meg a fizetését
annyiszor 100-zal, ahány dolgozó még rajta kívül az osztályon dolgozik.
(Ha több legrégebben belépett dolgozó is van, akkor mindegyikük fizetését növeljük meg.)
A módosítások után a program írja ki az új átlagfizetést két tizedesre kerekítve. 
A procedúra a kiírás után adjon ki egy ROLLBACK utasítást, hogy megmaradjanak az eredeti fizetések,
így a procedúrát többször is futtatni tudják. */
CREATE OR REPLACE PROCEDURE fiz_mod IS
    cursor c1 is select min(dkod) as min_dkod, oazon, min(belepes) as min_belepes, (select count(*) from dolgozo where oazon = d1.oazon) - 1 as rajta_kivul
        from dolgozo d1
        group by oazon;
    --rec c1%rowtype;
begin
    /*open c1;
    loop
        fetch c1 into rec;
        update dolgozo set fizetes = fizetes + rec.rajta_kivul * 100 where dkod = rec.min_dkod;
        exit when c1%notfound;
        for item in (select dkod, fizetes, oazon from dolgozo where dkod = rec.min_dkod) loop
            dbms_output.put_line(item.dkod || ' ' || item.fizetes);
        end loop;

    end loop;
    close c1;*/
    for sor in c1 loop
        update dolgozo set fizetes = fizetes + sor.rajta_kivul * 100 where dkod = sor.min_dkod;
    end loop;
    
    rollback;
end;

-- még nem jó

set serveroutput on
execute fiz_mod();

-- 10.2
/* Módosítás kurzorral
Írjunk meg egy procedúrát, amelyik módosítja a paraméterében megadott osztályon a fizetéseket, és 
kiírja a dolgozó nevét és új fizetését.  A módosítás mindenki fizetéséhez adjon hozzá n*10 ezret, 
ahol n a dolgozó nevében levő magánhangzók száma (A, E, I, O, U).
A procedúra a kiírás után adjon ki egy ROLLBACK utasítást, hogy megmaradjanak az eredeti fizetések,
így a procedúrát többször is futtatni tudják. */

-- még nincs kész

-- 10.3
/* Exception
Írjunk meg egy függvényt, amelyik egy karakteres típusú paraméterben egy dátumot 
kap a következő formátumban: 'éééé.hh.nn' vagy 'nn.hh.éééé'. 
A függvény adja vissza a nap nevét, pl. 'kedd'.
Ha a megadott karakterlánc nem egy érvényes dátum, akkor adja vissza, hogy 'rossz dátum'.
*/
CREATE OR REPLACE FUNCTION nap_nev(p_kar VARCHAR2) RETURN VARCHAR2 IS
begin
    if regexp_like(p_kar, '^[0-9]{4}.[0-9]{2}.[0-9]{2}$')
    then
        return to_char(to_date(p_kar, 'yyyy.MM.dd'), 'day');
    elsif regexp_like(p_kar, '^[0-9]{2}.[0-9]{2}.[0-9]{4}$')
    then
        return to_char(to_date(p_kar, 'dd.MM.yyyy'), 'day');
    else
        return 'rossz dátum';
    end if;
    exception
        when others then
            return 'rossz dátum';
end;

SELECT nap_nev('2017.05.01'), nap_nev('02.05.2017'), nap_nev('2017.13.13') FROM dual;

-- 10.4
/* Exception, SQLCODE
Írjunk meg egy procedúrát, amelyik a paraméterében kapott számra külön sorokba kiírja 
annak reciprokát, négyzetgyökét, és faktoriálisát. Ha bármelyik nem értelmezhető vagy
túlcsordulást okoz, akkor erre a részre írja ki a kapott hibakódot. (SQLCODE). */
CREATE OR REPLACE PROCEDURE szamok(n number) IS
begin
-- reciprok
    dbms_output.put_line(1/n);
-- négyzetgyök
    dbms_output.put_line(sqrt(n));
-- faktoriális
    dbms_output.put_line(faktor(n));
    exception
        when others then
            dbms_output.put_line(sqlerrm);
end;

set serveroutput on
execute szamok(0);
execute szamok(-2);
execute szamok(40);

-- 10.5
/*
Írjunk meg egy függvényt, amelyik visszaadja a paraméterként szereplő '+'-szal 
elválasztott számok és kifejezések összegét. Ha valamelyik kifejezés nem szám,
akkor azt az összeadásnál hagyja figyelmen kívül, vagyis 0-nak tekintse. */

...
CREATE OR REPLACE FUNCTION osszeg2(p_char VARCHAR2) RETURN NUMBER IS
    cnt number := 0;
    pos number := 1;
    digits integer;
begin
    digits := regexp_substr(p_char, '[^+]+', 1, pos);

    while digits is not null loop
        cnt := cnt + to_number(digits);
        pos := pos + 1;
        digits := regexp_substr(p_char, '[^+]+', 1, pos);
    end loop;
    exception when others then
        digits := 0;
    return cnt;
end;

SELECT osszeg2('1+21 + bubu + y1 + 2 + -1 ++') FROM dual;