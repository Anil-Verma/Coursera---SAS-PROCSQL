********************************;
*EXPLORE DICTIONARY.TABLES     *;
********************************;
proc sql inobs=100;
describe table dictionary.tables;
select *
	from dictionary.tables;
quit;


proc sql number;
	select *
		from dictionary.tables
		where libname='SQ';
quit;


/*SAS Equivalent of dictionary.tables*/
proc print data=sashelp.vtable;
	where Libname = "SQ";
run;


********************************;
*EXPLORE DICTIONARY.COLUMNS    *;
********************************;
proc sql;
describe table dictionary.columns;
select *
	from dictionary.columns
	where Libname = "SQ";
quit;


/*SAS Equivalent of dictionary.columns*/
proc print data=sashelp.vcolumn(obs=100);
	where Libname = "SQ";
run;


********************************;
*EXPLORE DICTIONARY.LIBNAMES   *;
********************************;
proc sql number;
describe table dictionary.libnames;
select *
	from dictionary.libnames;
quit;


proc sql;
describe table dictionary.libnames;
select *
	from dictionary.libnames
	where libname='SQ';
quit;


proc sql number;
select distinct libname
	from dictionary.libnames;
quit;



/*SAS Equivalent of dictionary.members*/
proc print data=sashelp.vlibnam;
    where Libname = "SQ";
run;



/************			activity DICTIONARY TABLE		****/
PROC SQL;
describe table dictionary.tables;
	SELECT LIBNAME, COUNT(MEMNAME) AS TABLE_COUNT
	FROM DICTIONARY.TABLES
	GROUP BY LIBNAME;
QUIT;
		

PROC SQL;
	SELECT LIBNAME, 
			COUNT(MEMNAME) AS TABLE_COUNT
	FROM DICTIONARY.TABLES
	GROUP BY LIBNAME;
QUIT;

















