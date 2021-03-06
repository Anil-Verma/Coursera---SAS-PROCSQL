*creating the libname sq****;
libname sq '/home/PATH/ESQ1M6/data';

*** NO JOINS, FULL TABLES	**;
PROC SQL NUMBER;
	SELECT * 
	FROM SQ.SMALLCUSTOMER, SQ.SMALLTRANSACTION;
QUIT;
	

/**	ACTIVITY 1	***/
** EXPLORING SMALL CUSTOMER, SMALL TRANSACTION TABLES***;


PROC SQL NUMBER;
TITLE "TABLE : SMALL CUSTOMER TABLE";
	SELECT * 
	FROM SQ.SMALLCUSTOMER;

TITLE "TABLE : SMALL TRANSACTION TABLE ";
	SELECT *
	FROM SQ.SMALLTRANSACTION;
QUIT;

TITLE;


***	CREATING THE DEFAULT JOIN	***;
TITLE1 "DEFAULT CARTESIAN JOIN";
PROC SQL NUMBER;
	SELECT *
	FROM SQ.SMALLCUSTOMER, SQ.SMALLTRANSACTION;
QUIT;

TITLE;



/*************	INNER JOIN		*************/

PROC SQL NUMBER;
	SELECT FIRSTNAME,
			LASTNAME,
			STATE,
			INCOME,
			DATETIME,
			AMOUNT
	FROM 
		SQ.SMALLCUSTOMER INNER JOIN SQ.SMALLTRANSACTION
		ON SMALLCUSTOMER.ACCOUNTID = SMALLTRANSACTION.ACCOUNTID;
QUIT;


****	FIND THE CUSTOMER TRANSACTIONS THAT BELONGS TO NY	***;
PROC SQL NUMBER;
	SELECT FIRSTNAME,
			LASTNAME,
			SMALLCUSTOMER.ACCOUNTID,
			STATE,
			INCOME,
			DATETIME,
			AMOUNT
	FROM 
		SQ.SMALLCUSTOMER INNER JOIN SQ.SMALLTRANSACTION
		ON SMALLCUSTOMER.ACCOUNTID = SMALLTRANSACTION.ACCOUNTID
	WHERE STATE='NY'
	ORDER BY AMOUNT DESC;
QUIT;


****	JOINING WITH ALIAS		******;
PROC SQL NUMBER;
	SELECT FIRSTNAME, LASTNAME, STATE, INCOME, DATETIME, 
			C.ACCOUNTID
	FROM 
		SQ.SMALLCUSTOMER AS C INNER JOIN SQ.SMALLTRANSACTION AS T
		ON C.ACCOUNTID = T.ACCOUNTID;
QUIT;



/********	ACTIVITY 2		*************/
PROC SQL NUMBER;
TITLE1 "STATE POPULATION";
	SELECT *
	FROM SQ.STATEPOPULATION(OBS=10);

TITLE2 "STATE CODE";
	SELECT * 
	FROM SQ.STATECODE(OBS=10);
QUIT;

TITLE;


*** CREATING INNER JOIN	***;

PROC SQL OUTOBS=100 NUMBER;
TITLE1 "STATEPOPULATION WITH FULL NAME";

	SELECT NAME,
			STATENAME,
			POPESTIMATE1,
			POPESTIMATE2,
			POPESTIMATE3
	FROM SQ.STATEPOPULATION AS P INNER JOIN SQ.STATECODE AS S
		ON P.NAME = S.STATECODE;
QUIT;
TITLE;


***********			NATURAL JOIN		********;
PROC SQL NUMBER;
	SELECT *
	FROM SQ.SMALLCUSTOMER AS C
			NATURAL JOIN
		SQ.SMALLTRANSACTION AS T;
QUIT;


/******			SELECTING DATA FROM MORE THAN 2 TABLES		*****/

****	FINDING TABLES HAVING COLUMNS BANKID AND MERCHANT ID	***;
PROC SQL NUMBER;
	TITLE1 "BANKID COLUMN IN TABLES";
	SELECT MEMNAME, NAME
	FROM DICTIONARY.COLUMNS 
	WHERE LIBNAME='SQ' AND
			UPCASE(NAME) = 'BANKID';
			
	TITLE2 "MERCHANTID COLUMN IN TABLES";
	SELECT MEMNAME, NAME
	FROM DICTIONARY.COLUMNS
	WHERE LIBNAME='SQ' AND
			UPCASE(NAME) = 'MERCHANTID';
	
QUIT;

TITLE;


/**********			DEMO 2		**************/
* EXPLORING THE TABLES ;
* SMALLCUSTOMER, SMALLTRANSACTION;
* MERCHANT, BANK;

PROC SQL INOBS=5;
	TITLE "TABLE :  SMALLCUSTOMER";
	SELECT *
	FROM SQ.SMALLCUSTOMER;
	
	TITLE "TABLE : SMALL TRANSACTION";
	SELECT *
	FROM SQ.SMALLTRANSACTION;
	
	TITLE "TABLE : MERCHANT";
	SELECT *
	FROM SQ.MERCHANT;
	
	TITLE "TABLE : BANK";
	SELECT *
	FROM SQ.BANK;
QUIT;

TITLE;


***		CREATING INNER JOIN IN 4 TABLES 	*******;
PROC SQL;
	SELECT FIRSTNAME,
			LASTNAME,
			C.STATE,
			INCOME FROMAT=DOLLAR16.,
			DATEPART(DATETIME) AS DATE FROMAT=DATE9.,
			MERCHANTNAME,
			AMOUNT FORMAT=DOLLAR16.,
			C.ACCOUNTID,
			NAME LABEL="BANK NAME"
	FROM 
			SQ.SMALLCUSTOMER AS C INNER JOIN SQ.SMALLTRANSACTION AS T
			ON C.ACCOUNTID = T.ACCOUNTID INNER JOIN SQ.MERCHANT AS M
			ON T.MERCHANTID = M.MERCHANTID INNER JOIN SQ.BANK AS B
			ON T.BANKID = B.BANKID;
QUIT;


/*******		HANDLING MISSING VALUES			*******/

PROC SQL NUMBER;
	SELECT *
	FROM SQ.SMALLCUSTOMER2 AS C INNER JOIN
			SQ.SMALLTRANSACTION2 AS T
		ON C.ACCOUNTID = T.ACCOUNTID
		AND C.ACCOUNTID IS NOT NULL;
QUIT;



/******* 		NON-EQUI JOINS			**********/
PROC SQL;
	SELECT FIRSTNAME, LASTNAME, INCOME, TAXBRACKET
	FROM SQ.SMALLCUSTOMER AS C 
		INNER JOIN SQ.TAXBRACKET AS T
		ON C.INCOME >= T.LOWINCOME AND
			C.INCOME <= T.HIGHINCOME;
QUIT;


PROC SQL NUMBER;
	SELECT FIRSTNAME,
			LASTNAME,
			INCOME FORMAT=DOLLAR9.,
			TAXBRACKET
	FROM SQ.SMALLCUSTOMER AS C
			INNER JOIN 
		SQ.TAXBRACKET AS T
		ON C.INCOME >= T.LOWINCOME AND
			C.INCOME <= T.HIGHINCOME
	ORDER BY TAXBRACKET DESC, INCOME DESC;
QUIT;


/**********				ACTIVITY 2			********/
PROC SQL NUMBER;
CREATE TABLE WORK.NYC AS
	SELECT FIRSTNAME, LASTNAME, EMPLOYED, MARITALSTATUS
	FROM SQ.CUSTOMER AS C INNER JOIN SQ.MARITALCODE AS M
		ON C.MARRIED = M.MARITALCODE
	WHERE ZIP=10001;
QUIT;


title 'Marital Status by Employment for NYC Customers'; 
PROC FREQ DATA=WORK.NYC ORDER=FREQ;
	TABLES MARITALSTATUS * EMPLOYED;
RUN;
TITLE;



/********		ACTIVITY 3			*********/

PROC SQL NUMBER;
CREATE TABLE WORK.GENERATION AS  	
	SELECT FIRSTNAME, LASTNAME, 
			YEAR(C.DOB) AS YEAR_C,
			NAME
	FROM SQ.CUSTOMER AS C INNER JOIN SQ.AGEGROUP AS A
			ON YEAR(C.DOB) >= A.STARTYEAR AND
				YEAR(C.DOB) <= A.ENDYEAR;
QUIT;



/*Run the Visualization on the Newly Created Table*/
title 'Count of Customers by Generation';
proc sgplot data=work.generation noautolegend;
    hbar Name / 
          stat=freq
          dataskin=sheen 
          categoryorder=respdesc 
          datalabel 
          datalabelattrs=(size=9pt) 
          FILLATTRS=(color=cx6f7eb3);
          yaxis label="Generation";
          xaxis grid label="Count";
run;
title;



