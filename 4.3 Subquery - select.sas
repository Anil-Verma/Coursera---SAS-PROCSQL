*creating the libname sq****;
libname sq '/home/PATH/ESQ1M6/data';


**	finding the population estimate percntage per state **;
PROC SQL NUMBER;
	SELECT NAME, 
			POPESTIMATE1/(SELECT SUM(POPESTIMATE1) FROM SQ.STATEPOPULATION) 
			AS PCT_POP FORMAT=PERCENT7.3
	FROM SQ.STATEPOPULATION
	ORDER BY PCT_POP DESC;
QUIT;
			

****	REMERGING QUERRIES	***;
PROC SQL NUMBER;
	SELECT NAME,
			POPESTIMATE1/SUM(POPESTIMATE1) AS POP_PCT FORMAT=PERCENT7.3
	FROM SQ.STATEPOPULATION 
	ORDER BY POP_PCT DESC;
QUIT;


****		CONTROLLING REMERGING		****;

PROC SQL NUMBER;
	SELECT REGION,
			SUM(POPESTIMATE1) AS TOTAL_REGION FORMAT=COMMA14.
	FROM SQ.STATEPOPULATION; 
QUIT;


PROC SQL NOREMERGE NUMBER;
	SELECT REGION,
			SUM(POPESTIMATE1) AS TOTAL_REGION FORMAT=COMMA14.
	FROM SQ.STATEPOPULATION; 
QUIT;


PROC SQL NOREMERGE NUMBER;
	SELECT REGION,
			SUM(POPESTIMATE1) AS TOTAL_REGION FORMAT=COMMA14.
	FROM SQ.STATEPOPULATION 
	GROUP BY REGION
	ORDER BY CALCULATED TOTAL_REGION DESC;
QUIT;


/***		REMERGING GROUP BY STATISTICS		*******/
PROC SQL NUMBER;
	SELECT REGION, NAME, POPESTIMATE1, 
			SUM(POPESTIMATE1) AS TOTAL_REGION_EST FORMAT=COMMA14.,
			POPESTIMATE1/CALCULATED TOTAL_REGION_EST AS PCT_REGION FORMAT=PERCENT7.3
	FROM SQ.STATEPOPULATION
	GROUP BY REGION
	ORDER BY REGION, PCT_REGION DESC;
QUIT;


/************		ACTIVITY 1			*************/

PROC SQL NUMBER;
	SELECT  NAME,
			BIRTHS1/SUM(BIRTHS1) AS PctBirth format=percent7.2
	FROM SQ.STATEPOPULATION
	order by PctBirth desc;
QUIT;
	
	

			
/************		ACTIVITY 2		*********************/
/***
	Find the top 10 countries that have the highest percentage 
	of estimated global population using the population estimates 
	of ages 15+ in the sq.globalfull table
***/

proc sql outobs=5 number;
	select * from sq.globalfull;
quit;


proc sql number;
	select distinct CountryCode, EstYear1Pop format=comma16.,
	sum(EstYear1Pop) as EstPct format=comma16.
	from sq.globalfull;
quit;


proc sql outobs=10 number;
	select distinct CountryCode, shortname,
			EstYear1Pop/ sum(EstYear1Pop) as PctPop fromat=percent7.2
	from sq.globalfull
	order by PctPop desc;
quit;



title 'Estimated Population of Ages 15+ for Next Year';
proc sql;
select sum(EstYear1Pop) as EstPct format=comma16.
    from (select distinct CountryCode, EstYear1Pop
              from sq.globalfull);
quit;
title;


title 'Top 10 Countries by Estimate Population';
title2 'Ages 15+';
proc sql outobs=10;
select distinct CountryCode, ShortName, 
       EstYear1Pop/
               (select sum(EstYear1Pop) as EstPct format=comma16.
                    from (select distinct CountryCode, EstYear1Pop
                              from sq.globalfull)) 
                                   as PctPop format=percent7.2
    from sq.globalfull
    order by PctPop desc;
quit;
title;

