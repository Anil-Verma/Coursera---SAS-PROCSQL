*creating the libname sq****;
libname sq '/home/PATH/ESQ1M6/data';


/* SEE THE STRUCTURE OF THE TABLE	**/
PROC SQL;
	DESCRIBE TABLE SQ.CUSTOMER;
QUIT;


** TABLE STRUCTURE WITH PROC CONTENTS		***;
PROC CONTENTS DATA=SQ.CUSTOMER;
RUN;

/**		FINDING THE DATA IN COLUMN		**/
PROC SQL;
	SELECT FIRSTNAME, LASTNAME, STATE
	FROM SQ.CUSTOMER (OBS=10);
QUIT;

