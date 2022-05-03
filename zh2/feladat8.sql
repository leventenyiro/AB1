-- 8.1
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

-- 8.2 - MÉG NEM JÓ
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
        for i in 2..n loop
            temp := first + second;
            first := second;
            second := temp;
        end loop;
    end if;
    dbms_output.put_line(temp);
end;

execute fib(3);