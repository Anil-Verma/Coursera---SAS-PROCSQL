*creating the libname sq****;
libname sq '/home/PATH/ESQ1M6/data';

**********		self join	*****;
PROC SQL NUMBER;
	SELECT E.EMPLOYEEID, E.EMPLOYEENAME,
			E.STARTDATE FORMAT=DATE9.,
			E.MANAGERID, 
			M.EMPLOYEENAME AS MANAGER_NAME
	FROM SQ.EMPLOYEE AS E INNER JOIN SQ.EMPLOYEE AS M
		ON E.MANAGERID = M.EMPLOYEEID
		ORDER BY MANAGER_NAME;
QUIT;


*****************		FUNCTION TO JOIN TABLES			*******;
****	EXPLORING THE TABLES;

PROC SQL OUTOBS=2;
	TITLE "TABLE : TRANSACTION FULL";
	DESCRIBE TABLE SQ.TRANSACTIONFULL;
	SELECT * FROM SQ.TRANSACTIONFULL;
	
	TITLE "TABLE : STATECODE";
	DESCRIBE TABLE SQ.STATECODE;
	SELECT * FROM SQ.STATECODE;
	
QUIT;
TITLE;

***	FIND THE CUSTOMER AND STATE***;
PROC SQL OUTOBS=10 NUMBER;
	TITLE "TRANSACTION WITH STATE INFO";
	SELECT CUSTOMERNAME,
			STATENAME
	FROM SQ.TRANSACTIONFULL AS T INNER JOIN SQ.STATECODE AS S
		ON SUBSTR(T.STATEID, 1, 2) = S.STATECODE;
QUIT;

TITLE;

/***********		ACTIVITY 1		*************/

proc sql inobs=10 number;
select StateID, CustomerName, StateName
    from sq.transactionfull as t inner join 
         sq.statecode as s
      on t.StateID = s.StateCode;
quit;

PROC SQL OUTOBS=10 NUMBER;
	TITLE "TRANSACTION WITH STATE INFO";
	SELECT STATEID, 
			CUSTOMERNAME,
			STATENAME
	FROM SQ.TRANSACTIONFULL AS T INNER JOIN SQ.STATECODE AS S
		ON SUBSTR(T.STATEID, 1, 2) = S.STATECODE;
QUIT;

TITLE;



/****************		ACTIVITY 2		**************/
proc sql;
create table customerzip
	(CustomerID num,
     ZipCode char(5),
     Gender char(1),
     Employed char(1));
insert into customerzip
    values(1,"14580","M","Y")
	values(2,"04429","M","Y")
	values(3,"50101","M","Y")
	values(4,"27519","M","Y")
	values(5,"14216","M","Y")
;
quit;



proc sql;
select c.CustomerID, c.ZipCode, c.Gender, 
       z.Zip, z.City, z.StateCode
    from customerzip as c inner join 
         sashelp.zipcode as z
      on c.ZipCode = z.Zip;
quit;



*******		CONVERTING THE COLUMN	********;
PROC SQL NUMBER;
	SELECT C.CUSTOMERID,
			C.ZIPCODE,
			C.GENDER,
			Z.ZIP,
			Z.CITY,
			Z.STATECODE
	FROM CUSTOMERZIP AS C INNER JOIN SASHELP.ZIPCODE AS Z
		ON C.ZIPCODE = PUT(Z.ZIP, Z5.);
QUIT;



