SELECT SAL
FROM EMP
WHERE ENAME = 'JONES';

SELECT *
FROM EMP
WHERE SAL > 2975;

SELECT *
FROM EMP
WHERE SAL > (SELECT SAL
            FROM EMP
            WHERE ENAME = 'JONES'
            ORDER BY SAL DESC);
            
SELECT *
FROM EMP
WHERE HIREDATE < (SELECT HIREDATE
                    FROM EMP
                    WHERE ENAME = 'JONES');
                    
SELECT E.EMPNO, E.ENAME, E.JOB, E.SAL, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND E.DEPTNO = 20
    AND E.SAL > (SELECT AVG(SAL)
                    FROM EMP);
                    
SELECT *
FROM EMP
WHERE DEPTNO IN (20, 30);

SELECT *
FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
                FROM EMP
                GROUP BY DEPTNO);
                
SELECT *
FROM EMP
WHERE SAL = ANY (SELECT MAX(SAL)
                    FROM EMP
                    GROUP BY DEPTNO);
                    
SELECT *
FROM EMP
WHERE SAL = SOME (SELECT MAX(SAL)
                    FROM EMP
                    GROUP BY DEPTNO);
                    
-- 둘이 같음

SELECT *
FROM EMP
WHERE SAL < ANY (SELECT SAL
                    FROM EMP
                    WHERE DEPTNO = 30)
ORDER BY SAL, EMPNO;

SELECT *
FROM EMP
WHERE SAL < (SELECT MAX(SAL)
                    FROM EMP
                    WHERE DEPTNO = 30)
ORDER BY SAL, EMPNO;

---

SELECT *
FROM EMP
WHERE SAL > ANY (SELECT SAL
                    FROM EMP
                    WHERE DEPTNO = 30)
ORDER BY SAL, EMPNO;

SELECT *
FROM EMP
WHERE SAL > (SELECT MIN(SAL)
                    FROM EMP
                    WHERE DEPTNO = 30)
ORDER BY SAL, EMPNO;

---

SELECT *
FROM EMP
WHERE SAL < ALL (SELECT SAL
                FROM EMP
                WHERE DEPTNO = 30);
                
SELECT *
FROM EMP
WHERE SAL > ALL (SELECT SAL
                FROM EMP
                WHERE DEPTNO = 30);
                
SELECT *
FROM EMP
WHERE EXISTS (SELECT DNAME
            FROM DEPT
            WHERE DEPTNO = 10);
               
SELECT *
FROM EMP
WHERE EXISTS (SELECT DNAME
            FROM DEPT
            WHERE DEPTNO = 50);
           
SELECT *
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                        FROM EMP
                        GROUP BY DEPTNO);
                        
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROM (SELECT * FROM EMP WHERE DEPTNO = 10) E10,
    (SELECT * FROM DEPT) D
WHERE E10.DEPTNO = D.DEPTNO;

WITH
E10 AS (SELECT * FROM EMP WHERE DEPTNO = 10),
D AS (SELECT * FROM DEPT)

SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROM E10, D
WHERE E10.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E1
WHERE SAL > (SELECT MIN(SAL)
            FROM EMP E2
            WHERE E2.DEPTNO = E1.DEPTNO);
            
---

SELECT EMPNO, ENAME, JOB, SAL,
    (SELECT GRADE
    FROM SALGRADE
    WHERE E.SAL BETWEEN LOSAL AND HISAL)AS SALGRADE,
    DEPTNO,
    (SELECT DNAME
    FROM DEPT
    WHERE E.DEPTNO = DEPT.DEPTNO) AS DNAME
FROM EMP E;

SELECT EMPNO, ENAME, JOB, SAL,
    DEPTNO
FROM EMP E;

SELECT *
FROM DEPT

-- 연습문제

-- 1

SELECT E.JOB, E.EMPNO, E.ENAME, E.DEPTNO, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND JOB = (SELECT JOB
            FROM EMP
            WHERE ENAME = 'ALLEN');
            
SELECT E.JOB, E.EMPNO, E.ENAME, E.DEPTNO, D.DNAME
FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
WHERE JOB = (SELECT JOB
            FROM EMP
            WHERE ENAME = 'ALLEN');
            
-- 2

SELECT E.EMPNO, E.ENAME, D.DNAME, E.HIREDATE, D.LOC, E.SAL, S.GRADE
FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
    JOIN SALGRADE S ON (E.SAL BETWEEN S.LOSAL AND S.HISAL)
WHERE E.SAL > (SELECT AVG(SAL)
                FROM EMP)
ORDER BY E.SAL DESC, E.EMPNO ASC;

-- 3

SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
WHERE D.DEPTNO = 10
    AND JOB NOT IN (SELECT JOB
                    FROM EMP
                    WHERE DEPTNO = 30);
                    
-- 4

SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E JOIN SALGRADE S ON (E.SAL BETWEEN S.LOSAL AND S.HISAL)
WHERE SAL > (SELECT MAX(SAL)
            FROM EMP
            WHERE JOB = 'SALESMAN')
ORDER BY EMPNO ASC;

SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E JOIN SALGRADE S ON (E.SAL BETWEEN S.LOSAL AND S.HISAL)
WHERE SAL > ALL (SELECT SAL
            FROM EMP
            WHERE JOB = 'SALESMAN')
ORDER BY EMPNO ASC;