-- orai
create or replace function nap_nev(input_date varchar) return varchar is
begin
    if regexp_like(input_date, '^[0-9]{4}.[0-9]{2}.[0-9]{2}$')
    then
        return to_char(to_date(input_date, 'yyyy.MM.dd'), 'day');
    elsif regexp_like(input_date, '^[0-9]{2}.[0-9]{2}.[0-9]{4}$')
    then
        return to_char(to_date(input_date, 'dd.MM.yyyy'), 'day');
    else
        return 'rossz dátum';
    end if;
end;

create table gyak10 as
select dnev, belepes, nap_nev(belepes) as belepesi_datum_nap_nev
from vzoli.dolgozo
where fizetes > (select avg(fizetes) from vzoli.dolgozo);

-- más feladatok

create table emp as select * from vzoli.emp;
create table dept as select * from vzoli.dept;

set serveroutput on
DECLARE 
  CURSOR curs1 IS 
  WITH
  tmp1 AS (
    SELECT deptno, round(AVG(sal)) dept_avg FROM emp
    GROUP BY deptno),
  tmp2 AS (
    SELECT round(AVG(sal)) gen_avg FROM emp)
  SELECT dname, dept_avg, gen_avg, dept_avg-gen_avg diff
  FROM tmp1, tmp2, dept WHERE tmp1.deptno = dept.deptno;
  rec curs1%ROWTYPE;
BEGIN
  OPEN curs1;
  LOOP
    FETCH curs1 INTO rec;
    EXIT WHEN curs1%NOTFOUND;
    dbms_output.put_line(rec.dname||' | '||rec.dept_avg||' | '||rec.diff);
  END LOOP;
  CLOSE curs1;
END;
