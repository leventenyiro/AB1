-- 8.1
/* Írjunk meg egy függvényt, amelyik eldönti egy számról, hogy prím-e. igen/nem -> 1/0 */
CREATE OR REPLACE FUNCTION prim(n integer) RETURN number IS
    i number;
    temp number;
begin
i := 2;
temp := 1;

  for i in 2..n/2
    loop
        if mod(n, i) = 0
        then
            temp := 0;
            exit;
        end if;
    end loop;
   
    if temp = 1
    then
        return 1;
    else
        return 0;
    end if;
end;

-- 8.2
/* Írjunk meg egy procedúrát, amelyik kiírja az n-edik Fibonacchi számot 
   fib_1 = 0, fib_2 = 1, fib_3 = 1, fib_4 = 2 ... fib_i = a megelőző kettő összege
*/
set serveroutput on
CREATE OR REPLACE PROCEDURE fib(n integer) IS
    first number := 0;
    second number := 1;
    temp number;
    i number;
begin
    if n = 1 then
        temp := first;
    /*elsif n = 2 then
        temp := second;*/
    else
        for i in 2..n-1 loop
            temp := first + second;
            first := second;
            second := temp;
        end loop;
    end if;
    dbms_output.put_line(temp);
end;

execute fib(10);

-- 8.3
/* Írjunk meg egy függvényt, amelyik visszaadja két szám legnagyobb közös osztóját */
CREATE OR REPLACE FUNCTION lnko(p1 integer, p2 integer) RETURN number IS
    num1 number;
    num2 number;
    temp number;
begin
    num1 := p1;
    num2 := p2;
    while mod(num2, num1) != 0 loop
        temp := mod(num2, num1);
        num2 := num1;
        num1 := temp;
    end loop;
    return num1;
end;

select lnko(9,15) from dual
SELECT lnko(3570,7293) FROM dual;

-- 8.4
/* Írjunk meg egy függvényt, amelyik visszaadja n faktoriálisát */
CREATE OR REPLACE FUNCTION faktor(n integer) RETURN integer IS
    fac number := 1;
    num number := n;
begin
    while num > 0 loop
        fac := num * fac;
        num := num - 1;
    end loop;
    return fac;
end;

SELECT faktor(10) FROM dual;

-- 8.5
/* Írjunk meg egy függvényt, amelyik megadja, hogy hányszor fordul elő egy 
   karakterláncban -> p1 egy másik részkarakterlánc -> p2 */
CREATE OR REPLACE FUNCTION hanyszor(p1 VARCHAR2, p2 VARCHAR2) RETURN integer IS
    cnt number := 0;
begin
    for i in 1..length(p1) - 1 loop
        if substr(p1, i, 2) = p2 then
            cnt := cnt + 1;
        end if;
    end loop;
    return cnt;
end;

SELECT hanyszor ('ab c ab ab de ab fg', 'ab') FROM dual;

-- 8.6
/* Írjunk meg egy függvényt, amelyik visszaadja a paraméterként szereplő '+'-szal 
   elválasztott számok összegét. */
CREATE OR REPLACE FUNCTION osszeg(p_char VARCHAR2) RETURN number IS
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
    return cnt;
end;

SELECT osszeg('1 + 4 + 13 + -1 + 0') FROM dual;
