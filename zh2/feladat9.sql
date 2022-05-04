-- 9.1
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

CREATE OR REPLACE FUNCTION kat_atlag(n integer) RETURN number IS
    avg1 number;
begin
    for item in (select round(avg(fizetes)) as avg1 from vzoli.dolgozo d, vzoli.fiz_kategoria f where d.fizetes >= f.also and d.fizetes <= f.felso and kategoria = 1)
    loop
        avg1 := to_number(item.avg1);
    end loop;
    return avg1;
end;

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
select to_char(to_date('2022.05.04', 'yyyy.MM.dd'), 'day') as nap from dual
CREATE OR REPLACE PROCEDURE nap_atl(d varchar2) IS
begin
    select * 
from vzoli.dolgozo
where to_char(belepes, 'day') like 'wednesday'
end;

