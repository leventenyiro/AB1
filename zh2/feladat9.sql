-- 9.1A
/* SELECT ... INTO v1
Írjunk meg egy függvényt, amelyik visszaadja egy adott fizetési kategóriába tartozó
dolgozók átlagfizetését. - 3 megoldás */
CREATE OR REPLACE FUNCTION kat_atlag(n integer) RETURN number IS
    cursor c1 is select avg(fizetes) from vzoli.dolgozo, vzoli.fiz_kategoria where fizetes >= also and fizetes <= felso and kategoria = n;
    avg1 number;
begin
    open c1;
    loop
        fetch c1 into avg1;
        exit when c1%notfound;
    end loop;
    close c1;
    return avg1;
end;

-- 9.1B
CREATE OR REPLACE FUNCTION kat_atlag(n integer) RETURN number IS
    avg1 number;
begin
    for item in (select round(avg(fizetes)) as avg1 from vzoli.dolgozo d, vzoli.fiz_kategoria f where d.fizetes >= f.also and d.fizetes <= f.felso and kategoria = 1)
    loop
        avg1 := to_number(item.avg1);
    end loop;
    return avg1;
end;

-- 9.1C
CREATE OR REPLACE FUNCTION kat_atlag(n integer) RETURN number IS
    avg1 number;
begin
    select round(avg(fizetes)) into avg1 from vzoli.dolgozo d, vzoli.fiz_kategoria f where d.fizetes >= f.also and d.fizetes <= f.felso and kategoria = n;
    return avg1;
end;

SELECT kat_atlag(1) FROM dual;

-- 9.2
/* SELECT ... INTO v1, v2
Írjunk meg egy procedúrát, amelyik kiírja azon dolgozók számát és átlagfizetését,
akiknek a belépési dátuma a paraméterül megadott nevű napon (pl. 'Hétfő') volt.*/
CREATE OR REPLACE PROCEDURE nap_atl(d varchar2) IS
begin
    for item in (select count(*) as cnt_employees, avg(fizetes) as avg_salary
        from vzoli.dolgozo
        where to_char(belepes, 'Day', 'nls_date_language=hungarian') like d || '%') loop
        dbms_output.put_line('dolgozok szama: ' || item.cnt_employees || ' atlag fizetes:' || item.avg_salary);
    end loop;
end;

set serveroutput on
call nap_atl('Csütörtök');

-- 9.3
/* Insert, Delete, Update 
Írjunk meg egy procedúrát, amelyik megnöveli azoknak a dolgozóknak a fizetését, akiknek a 
fizetési kategóriája ugyanaz, mint a procedúra paramétere. A növelés mértéke a dolgozó
osztályában előforduló legkisebb fizetés legyen.
A procedúra a módosítás után írja ki a módosított (új) fizetések átlagát két tizedesjegyre kerekítve. */
CREATE OR REPLACE PROCEDURE kat_novel(p_kategoria NUMBER) IS
    cursor c1 is select * from dolgozo join fiz_kategoria on fizetes between also and felso where kategoria = p_kategoria for update of fizetes;
    min_fizetes number;
    db int := 0;
    osszeg int := 0;
begin
    select min(fizetes) into min_fizetes from dolgozo join fiz_kategoria on fizetes between also and felso where kategoria = p_kategoria;
    for rec in c1 loop
        update dolgozo set fizetes = fizetes + min_fizetes where current of c1;
        db := db + 1;
        osszeg := osszeg + rec.fizetes + 1;
    end loop;
    dbms_output.put_line(round(osszeg/db, 2));
end;

set serveroutput on
call kat_novel(2);

-- 9.4
/* Cursor (több soros SELECT)
Írjunk meg egy procedúrát, amelyik veszi a paraméterül megadott osztály dolgozóit ábécé 
szerinti sorrendben, és kiírja a foglalkozásaikat egy karakterláncban összefűzve.
*/
CREATE OR REPLACE PROCEDURE print_foglalkozas(o_nev varchar2) IS
    foglalkozasok varchar(100);
begin
    for item in (select distinct foglalkozas
        from vzoli.dolgozo
        natural join vzoli.osztaly
        where onev = o_nev
        order by foglalkozas asc)
    loop
        foglalkozasok := concat(foglalkozasok, item.foglalkozas || '-');
    end loop;
    foglalkozasok := substr(foglalkozasok, 0, length(foglalkozasok) - 1);
    dbms_output.put_line(foglalkozasok);
end;

set serveroutput on
call print_foglalkozas('ACCOUNTING');

-- 9.5
/* Cursor (több soros SELECT)
Írjunk meg egy függvényt, amelyik veszi a paraméterül megadott osztály dolgozóit ábécé 
szerinti sorrendben, és visszaadja a foglalkozásaikat egy karakterláncban összefűzve.
*/
CREATE OR REPLACE FUNCTION get_foglalkozas(o_nev varchar2) RETURN varchar2 IS
    foglalkozasok varchar(100);
begin
    for item in (select distinct foglalkozas
        from vzoli.dolgozo
        natural join vzoli.osztaly
        where onev = o_nev
        order by foglalkozas asc)
    loop
        foglalkozasok := concat(foglalkozasok, item.foglalkozas || '-');
    end loop;
    foglalkozasok := substr(foglalkozasok, 0, length(foglalkozasok) - 1);
    return foglalkozasok;
end;

SELECT get_foglalkozas('ACCOUNTING') FROM dual; -- példa output: MANAGER-PRESIDENT-CLERK

-- 9.6
/* Asszociatív tömb  --> TABLE OF ... INDEX BY ...
Írjunk meg egy procedúrát, amelyik veszi az első n prímszámot (1. prímszám: 2, 2. prímszám: 3, stb.)
és beleteszi azokat egy asszociatív tömbbe. A procedúra a végén írja ki a tömb utolsó elemét és a
prímszámok összegét. */
create or replace PROCEDURE primes(n integer) IS
    type t_primes_type is table of integer index by pls_integer;
    t_primes t_primes_type;
    cnt pls_integer := 0;
    i integer := 2;
    is_prime boolean;

    summ integer := 0;
    l_index pls_integer;
begin
    while (cnt < n) loop
        is_prime := true;
        for j in 2..i/2 loop
            if mod(i, j) = 0 then
                is_prime := false;
                exit;
            end if;
        end loop;
        if is_prime then
            t_primes(cnt) := i;
            cnt := cnt + 1;
        end if;
        i := i + 1;
    end loop;

    l_index := t_primes.first;
    while l_index is not null loop
        summ := summ + t_primes(l_index);
        l_index := t_primes.next(l_index);
    end loop;

    dbms_output.put_line(t_primes(t_primes.last));
    dbms_output.put_line(summ);
end;

set serveroutput on
call primes(5)

-- 9.7
/* Cursor és asszociatív tömb 
Írjunk meg egy procedúrát, amelyik veszi a dolgozókat ábácé szerinti sorrendben, 
és minden páratlan sorszámú dolgozó nevét és fizetését beleteszi egy asszociatív tömbbe. 
A procedúra a végén írja ki a tömb utolsó előtti elemében szereplő nevet és fizetést. */
CREATE OR REPLACE PROCEDURE curs_tomb IS
    cursor c1 is select dkod, dnev, fizetes from dolgozo order by dnev;
    rec c1%rowtype;
    type emp_rec_type is record(dn dolgozo.dnev%type, fiz dolgozo.fizetes%type);
    type t_tab is table of emp_rec_type index by pls_integer;
    v_tab t_tab;
    l_index pls_integer := 0;
begin
    open c1;
    loop
        fetch c1 into rec;
        exit when c1%notfound;
        if mod(rec.dkod, 2) = 1 then
            v_tab(l_index).dn := rec.dnev;
            v_tab(l_index).fiz := rec.fizetes;
            l_index := l_index + 1;
        end if;
    end loop;
    close c1;
    
    dbms_output.put_line(v_tab(l_index - 2).dn || ' ' || v_tab(l_index - 1).fiz);
end;

execute curs_tomb();
