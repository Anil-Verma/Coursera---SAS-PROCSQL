*creating the libname sq****;
libname sq '/home/PATH/ESQ1M6/data';

****	LEFT OUTER JOIN		***;
PROC SQL NUMBER;
	SELECT * 
	FROM SQ.SMALLCUSTOMER AS C LEFT JOIN SQ.SMALLTRANSACTION AS T
		ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;


****	RIGHT OUTER JOIN 		***;
PROC SQL NUMBER;
	SELECT *
	FROM SQ.SMALLCUSTOMER AS C RIGHT JOIN SQ.SMALLTRANSACTION AS T
		ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;


/***********		ACTIVITY 1		********/

*	CHECKING THE VALUE OF ACCOUNTID FROM BOTH THE TABLES IN THE LEFT JOIN***;

PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME, INCOME,
			C.ACCOUNTID "C.ACCOUNTID", T.ACCOUNTID "T.ACCOUNTID",
			DATETIME, MERCHANTID, AMOUNT
	FROM SQ.SMALLCUSTOMER AS C LEFT JOIN SQ.SMALLTRANSACTION AS T
			ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;


PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME, INCOME,
			C.ACCOUNTID "C.ACCOUNTID", 
			DATETIME, MERCHANTID, AMOUNT
	FROM SQ.SMALLCUSTOMER AS C LEFT JOIN SQ.SMALLTRANSACTION AS T
			ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;

PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME, INCOME,
			T.ACCOUNTID "T.ACCOUNTID", 
			DATETIME, MERCHANTID, AMOUNT
	FROM SQ.SMALLCUSTOMER AS C LEFT JOIN SQ.SMALLTRANSACTION AS T
			ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;


********		USING THE COLASCE FUNCTION	***********;
PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME, INCOME,
			COALESCE(C.ACCOUNTID, T.ACCOUNTID) AS ACCOUNTID FORMAT=COMMA12.,
			DATETIME, MERCHANTID, AMOUNT FORMAT=DOLLAR16.
	FROM SQ.SMALLCUSTOMER AS C FULL JOIN SQ.SMALLTRANSACTION AS T
			ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;


**********		SELECT NON-MATCHING ROWS		********;
PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME, INCOME,
			C.ACCOUNTID "C.ACCOUNTID", T.ACCOUNTID "T.ACCOUNTID",
			DATETIME, MERCHANTID
	FROM SQ.SMALLCUSTOMER AS C LEFT JOIN SQ.SMALLTRANSACTION AS T
			ON C.ACCOUNTID = T.ACCOUNTID
	WHERE T.ACCOUNTID IS NULL;
QUIT;


/**********		ACTIVITY 2		*******************/

PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME,
			C.ACCOUNTID "C.ACCOUNTID", T.ACCOUNTID "T.ACCOUNTID",
			DATETIME, MERCHANTID
	FROM SQ.SMALLTRANSACTION2 AS T LEFT JOIN SQ.SMALLCUSTOMER2 AS C
		ON C.ACCOUNTID = T.ACCOUNTID AND T.ACCOUNTID IS NOT NULL
		WHERE C.ACCOUNTID IS NULL ;
QUIT;



/*************		ACTIVITY LEVEL 2	***************/

************	EXPLORING TABLES	*;
PROC SQL OUTOBS=20 NUMBER;
	TITLE " TABLE : GLOBALPOP";
	DESCRIBE TABLE SQ.GLOBALPOP;
	SELECT *
	FROM SQ.GLOBALPOP;
	
	TITLE "TABLE : GLOBALMETADATA";
	DESCRIBE TABLE SQ.GLOBALMETADATA;
	SELECT *
	FROM SQ.GLOBALMETADATA;
QUIT;

TITLE;


****		CREATING LEFT JOIN	********;
PROC SQL NUMBER;
CREATE TABLE WORK.META AS
	SELECT P.COUNTRYCODE,
			SERIESNAME,
			ESTYEAR1,
			ESTYEAR3,
			SHORTNAME,
			INCOMEGROUP
	FROM SQ.GLOBALPOP AS P LEFT JOIN SQ.GLOBALMETADATA AS M
		ON P.COUNTRYCODE = M.COUNTRYCODE;
QUIT;


***		CREATING REPORT FROM NEW TABLE	***;
PROC SQL NUMBER;
	SELECT DISTINCT COUNTRYCODE
	FROM WORK.META
	WHERE SHORTNAME IS NULL
	ORDER BY COUNTRYCODE;
QUIT;


/*************		ACTIVITY LEVEL 3	***************/

PROC SQL NUMBER;
	SELECT BANKID, MARITALSTATUS,
			COUNT(*) AS COUNT
	FROM SQ.CUSTOMER AS C LEFT JOIN SQ.MARITALCODE AS M
		ON C.MARRIED = M.MARITALCODE
	WHERE BANKID IS NOT NULL
	GROUP BY BANKID, MARITALSTATUS
	ORDER BY CALCULATED COUNT DESC;
QUIT;


PROC SQL NUMBER;
	SELECT C.BANKID, M.MARITALSTATUS,
			COUNT(*) AS COUNT,  B.NAME
	FROM SQ.CUSTOMER AS C LEFT JOIN SQ.MARITALCODE AS M
		ON C.MARRIED = M.MARITALCODE LEFT JOIN SQ.BANK AS B
		ON C.BANKID = B.BANKID
	WHERE C.BANKID IS NOT NULL
	GROUP BY C.BANKID, MARITALSTATUS, B.NAME
	ORDER BY CALCULATED COUNT DESC;
QUIT;


