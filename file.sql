SET SERVEROUTPUT ON;

--  Problem1
declare
namee varchar2(20) := 'Koti Reddy';
eid varchar2(5):= 'E460';
BEGIN

dbms_output.put_line(namee);
dbms_output.put_line(eid);
END;



--  Problem2

DECLARE
  num NUMBER(2) :=1;
BEGIN
  WHILE num<=20
  LOOP
    INSERT INTO assign2 VALUES(num);
    num := num+1;
  END LOOP;
END;


DECLARE
     CURSOR C IS SELECT num FROM assign2 ;
     V_num assign2%ROWTYPE;
BEGIN
     OPEN C;
     LOOP
        FETCH C INTO V_num;
        EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Num = ' || V_num.NUM);
     END LOOP;
     CLOSE C;
END;



--  Problem3
CREATE OR REPLACE
PROCEDURE facto(i IN INT,j out int)
IS
  output   INT :=1;
  loop_var INT;
BEGIN
  FOR loop_var IN 1 ..i
  LOOP
    output := output*loop_var;
  END LOOP;
  j := output;
 -- dbms_output.put_line('Factorial of '|| i || ' is ' ||output);

END;

declare
output int;
input_number int;
BEGIN
  facto(&input_number,output);
  dbms_output.put_line('Factorial of '||input_number||' is ' ||output);
END;



--  Problem4

CREATE OR REPLACE  FUNCTION leap(y IN INT)
    RETURN VARCHAR2
    AS
    res VARCHAR2(30);
  BEGIN
    IF mod(y,400)=0 THEN
      res       := y || ' is Leap Year';
    ELSIF mod(y,100)=0 THEN 
        res       := y||' is not Leap Year';
      ELSIF mod(y,4)=0 THEN
          res     := y || ' is Leap Year';
      END IF;
        RETURN res;
  END;
   
DECLARE
  val VARCHAR2(30);
  input_year int;
BEGIN
  val := leap(&input_year);
  dbms_output.put_line(val);
END;



--  Problem5

declare
cursor emp_cur is select * from emp_1;
 V_num emp_1%ROWTYPE;
BEGIN
     OPEN emp_cur;
     LOOP
        FETCH emp_cur INTO V_num;
        EXIT WHEN emp_cur%NOTFOUND;
       IF V_num.sal>17000 and V_num.hiredate > '01-FEB-1988' THEN
        DBMS_OUTPUT.PUT_LINE(V_num.ename || ' earns ' || V_num.sal||' and joined the organisation on '||V_num.hiredate);
        end if;
     END LOOP;
     CLOSE emp_cur;
END;

--  Problem6
declare
cursor emp_cur is select * from emp_detail;
 V_num emp_detail%ROWTYPE;
BEGIN
     OPEN emp_cur;
     LOOP
        FETCH emp_cur INTO V_num;
        EXIT WHEN emp_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Job ID: '||V_num.job_id || ' Title' || V_num.title|| ' Sal ' || V_num.sal);
     END LOOP;
     CLOSE emp_cur;
END;
--  Test Procedure
CREATE OR REPLACE
PROCEDURE facto(i IN INT,j out int)
IS
  output   INT :=1;
  loop_var INT;
BEGIN
  FOR loop_var IN 1 ..i
  LOOP
    output := output*loop_var;
  END LOOP;
  j := output;
 -- dbms_output.put_line('Factorial of '|| i || ' is ' ||output);

END;

--  Test Cursor
DECLARE
     CURSOR C IS SELECT * FROM job1 ;
     V_num job1%ROWTYPE;
BEGIN
     OPEN C;
     LOOP
        FETCH C INTO V_num;
        EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Jobid= ' || V_num.JOBID||' job title= '||V_num.JOBTITLE||' minsal='||V_num.MINSAL||' maxsal='||V_num.MAXSAL);
     END LOOP;
     CLOSE C;
END;



--  Probelm6

CREATE OR REPLACE
PROCEDURE addjobs(
    jobid    IN NUMBER,
    jobtitle IN VARCHAR2,
    minsal   IN NUMBER
    )
IS
  maxsal INT;
BEGIN
  maxsal := minsal*2;
  INSERT INTO job1 VALUES
    (jobid,jobtitle,minsal,maxsal);
  COMMIT;
END;

BEGIN
  addjobs(1234,'Trainee',4000);
END;



--  Problem7
CREATE OR REPLACE
PROCEDURE updsal(
    jobid2  IN NUMBER,
    minsal2 IN NUMBER,
    maxsal2 IN NUMBER)
IS
  maxsal_lessthan_minsal EXCEPTION;
  minimumsal job1.minsal%TYPE;
BEGIN
  SELECT minsal INTO minimumsal FROM job1 WHERE jobid=jobid2;
  IF maxsal2<minimumsal THEN
    raise maxsal_lessthan_minsal;
  END IF;
  UPDATE job1 SET minsal=minsal2,maxsal=maxsal2 WHERE jobid=jobid2;
  dbms_output.put_line('Data Updated Successfully');
EXCEPTION
WHEN maxsal_lessthan_minsal THEN
  dbms_output.put_line('MaxSal given is Less Than Minsal');
WHEN no_data_found THEN
  dbms_output.put_line('No Data Found with the given JobID:'||jobid2);
END;

BEGIN
  updsal(786,2134,20000);
END;



--  Problem8
CREATE OR REPLACE
PACKAGE empjobpkg
AS
  CURSOR emp_cur
  IS
    SELECT * FROM emp_1;
  PROCEDURE addjobs(
      jobid    IN NUMBER,
      jobtitle IN VARCHAR2,
      minsal   IN NUMBER);
  PROCEDURE updsal(
      jobid2  IN NUMBER,
      minsal2 IN NUMBER,
      maxsal2 IN NUMBER);
END empjobpkg;

create or replace package body empjobpkg as

CURSOR C IS SELECT num FROM assign2 ;
     V_num assign2%ROWTYPE;
PROCEDURE addjobs(
    jobid    IN NUMBER,
    jobtitle IN VARCHAR2,
    minsal   IN NUMBER
    )
IS
  maxsal INT;
BEGIN
  maxsal := minsal*2;
  INSERT INTO job1 VALUES
    (jobid,jobtitle,minsal,maxsal);
  COMMIT;
END addjobs;

PROCEDURE updsal(
    jobid2  IN NUMBER,
    minsal2 IN NUMBER,
    maxsal2 IN NUMBER)
IS
  maxsal_lessthan_minsal EXCEPTION;
  minimumsal job1.minsal%TYPE;
BEGIN
  SELECT minsal INTO minimumsal FROM job1 WHERE jobid=jobid2;
  IF maxsal2<minimumsal THEN
    raise maxsal_lessthan_minsal;
  END IF;
  UPDATE job1 SET minsal=minsal2,maxsal=maxsal2 WHERE jobid=jobid2;
  dbms_output.put_line('Data Updated Successfully');
EXCEPTION
WHEN maxsal_lessthan_minsal THEN
  dbms_output.put_line('MaxSal given is Less Than Minsal');
WHEN no_data_found THEN
  dbms_output.put_line('No Data Found with the given JobID:'||jobid2);
END updsal;

end empjobpkg;

BEGIN
  empjobpkg.updsal(786,2134,20000);
  empjobpkg.addjobs(1234,'Public relation Manager',6250);
END;



--  Problem9

DECLARE
  --job_name varchar2(20);
  CURSOR sal
  IS
    SELECT sal FROM emp_1 WHERE job='sr.clerk';
  salary emp_1.job%TYPE ;
BEGIN
  OPEN sal;
  --loop
  FETCH sal INTO salary;
  --exit when sal%NOTFOUND;
  dbms_output.put_line(salary);
  --end loop;
  CLOSE sal;
  UPDATE emp_1 SET sal=sal+sal*0.10 WHERE job='clerk' AND (sal-salary)>=1000;
END;



--    Problem10
CREATE OR REPLACE TRIGGER chksalesjob before
  INSERT OR
  UPDATE OF job_id ON emp_detail FOR EACH row DECLARE job_id_exception EXCEPTION;
  BEGIN
    IF ((:old.job_id!='SA_MAN') OR (:old.job_id != 'SA_REP')) THEN
      raise job_id_exception;
    END IF;
  EXCEPTION
  WHEN job_id_exception THEN
    dbms_output.put_line('New Job ID Should be SA_MAN or SA_REP');
  END chksalesjob;

BEGIN
  INSERT INTO emp_detail VALUES
    ('SA_REP','title',10000
    );
END;
