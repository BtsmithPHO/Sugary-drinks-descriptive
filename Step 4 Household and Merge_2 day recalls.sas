/*******************************************************
Nutrition Inequities in CVD Grant
Objective: SSB consumption and excise taxation
Christine Warren
Project: Smith_5913

Step 1 - create SCB Variable code
Step 2 - Household Survey dataclean
Step 3 - Merge FID, bootstrap, and HS file
********************************************************/

libname cchs '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Data\CCHS Data\CCHS 2015 - Nutrition\datasets\PUMF';run;

libname output '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Analysis\cchsn_output_datasets';run; *to put 'permanent' datasets to work off of in different programs;

/*************************************
Step 2 - HOUSEHOLD SURVEY DATA CLEAN
**************************************/

data hs_nci;
	set cchs.hs_nci;
run;

*creating predictor variables (education - 4 levels, income - 5 levels, food security status - 4 levels);

data hs1;
	set hs_nci;

/*Household Income Adequacy Quintiles
	NOTE: PUMF FILES HAVE n=23 NOT STATED SO WILL NEED TO REMOVE
	MASTER/SHARE FILE DOES NOT HAVE ANY MISSING*/
	H_INC=0;
	if INCDRCA in (1,2) then H_INC=1; else
	if INCDRCA in (3,4) then H_INC=2; else
	if INCDRCA in (5,6) then H_INC=3; else
	if INCDRCA in (7,8) then H_INC=4; else
	if INCDRCA in (9,10) then H_INC=5; else
	if INCDRCA = 99 then H_INC=99; 


/* education variable change from 7 to 4 levels*/
/*
	if EDUDH07 = 1 then EDUGH07 =1; else
	if EDUDH07 = 2 then EDUGH07 = 2; else 
	if EDUDH07 in (3 4 5) then EDUGH07 =3; else 
	if EDUDH07 in (6 7) then EDUGH07 =4; else
	if EDUDH07 = 99 then EDUGH07 = 99;
*/
	if EDUGH07 = 9 then EDUGH07 =99;
	/* food security status - creating 4 category var with secure, marginal, moderate, and severe
	follwing documentation on derived variables from CCHS PUMF 2015
	
	if DHHDYKD = 0 and DHHDOKD = 0 then DHHTDKS=0; *without children <18;
	if DHHDYKD ne 0 or DHHDOKD ne 0 then DHHTDKS=1; *with children < 18;
	
	if (FSC_020 = 3) then FSCT020=0;
	else if (FSC_020 in (1,2)) then FSCT020=1;

	if (FSC_030 = 3) then FSCT030=0;
	else if (FSC_030 in (1,2)) then FSCT030=1;

	if (FSC_040 = 3) then FSCT040=0;
	else if (FSC_040 in (1,2)) then FSCT040=1;

	if (FSC_050 in (3,6))  then FSCT050=0;
	else if (FSC_050 in (1,2)) then FSCT050=1;

	if (FSC_060 in (3,6)) then FSCT060=0;
	else if (FSC_060 in (1,2)) then FSCT060=1;

	if (FSC_070 in (3,6)) then FSCT070=0;
	else if (FSC_070 in (1,2)) then FSCT070=1;

	if (FSC_080 in (2,6)) then FSCT080=0;
	else if (FSC_080 = 1) then FSCT080=1;

	if (FSC_081 in (3,6)) then FSCT081=0;
	else if (FSC_081 in (1,2)) then FSCT081=1;

	if (FSC_090 in (2,6)) then FSCT090=0;
	else if (FSC_090 = 1) then FSCT090=1;

	if (FSC_100 in (2,6)) then FSCT100=0;
	else if (FSC_100 = 1) then FSCT100=1;

	if (FSC_110 in (2,6)) then FSCT110=0;
	else if (FSC_110 = 1) then FSCT110=1;

	if (FSC_120 in (2,6)) then FSCT120=0;
	else if (FSC_120 = 1) then FSCT120=1;

	if (FSC_121 in (3,6)) then FSCT121=0;
	else if (FSC_121 in (1,2)) then FSCT121=1;

	if (FSC_130 in (2,6)) then FSCT130=0;
	else if (FSC_130 = 1) then FSCT130=1;

	if (FSC_140 in (2,6)) then FSCT140=0;
	else if (FSC_140 = 1) then FSCT140=1;

	if (FSC_141 in (3,6)) then FSCT141=0;
	else if (FSC_141 in (1,2)) then FSCT141=1;

	if (FSC_150 in (2,6)) then FSCT150=0;
	else if (FSC_150 = 1) then FSCT150=1;

	if (FSC_160 in (2,6)) then FSCT160=0;
	else if (FSC_160 = 1) then FSCT160=1;

	FSCASUM = FSCT020 + FSCT030 + FSCT040 + FSCT080 + FSCT081 + FSCT090 + FSCT100 + FSCT110 + FSCT120 + FSCT121;

	FSCCSUM = FSCT050 + FSCT060 + FSCT070 + FSCT130 + FSCT140 + FSCT141 + FSCT150 + FSCT160;

	*FOODSEC_4LEV;
	*if (DVPMKPRX = 2) or;
		if (FSC_020 in (7,8,9)) or
		(FSC_030 in (7,8,9)) or
		(FSC_040 in (7,8,9)) or
		(FSC_050 in (7,8,9)) or
		(FSC_060 in (7,8,9)) or
		(FSC_070 in (7,8,9)) or
		(FSC_080 in (7,8,9)) or
		(FSC_081 in (7,8,9)) or
		(FSC_090 in (7,8,9)) or
		(FSC_100 in (7,8,9)) or
		(FSC_110 in (7,8,9)) or
		(FSC_120 in (7,8,9)) or
		(FSC_121 in (7,8,9)) or
		(FSC_130 in (7,8,9)) or
		(FSC_140 in (7,8,9)) or
		(FSC_141 in (7,8,9)) or
		(FSC_150 in (7,8,9)) or
		(FSC_160 in (7,8,9)) 
		then FOODSEC_4LEV=99; 

	*if DOFSC = 2 then FOODSEC_4LEV=99;

	else if (FSCASUM=0) and (FSCCSUM=0)
		then FOODSEC_4LEV=4; *food secure; else

	if  (FSCASUM= 1 and FSCCSUM=0) or
		(FSCASUM= 0 and FSCCSUM=1) or 
		(FSCASUM= 1 and FSCCSUM=1)

		then FOODSEC_4LEV=3; *marginally food insecure; else

	if ((2 <= FSCASUM <= 5) and (2 <= FSCCSUM <= 4)) or
		 (FSCASUM <= 5 and (2 <= FSCCSUM <= 4)) or
		 ((2 <= FSCASUM <= 5) and FSCCSUM <=4) 
		then FOODSEC_4LEV=2; *moderately food insecure; else

	if (FSCASUM >= 6 and FSCASUM <= 10) or
		(FSCCSUM >=5 and FSCCSUM <=8)
		then FOODSEC_4LEV=1; *severely food insecure;

		else FOODSEC_4LEV=99;
run;
*/

	if FSCDHFS2 =0 THEN FOODSEC_2LEV=2;
	IF FSCDHFS2 IN (1,2) THEN FOODSEC_2LEV=1;
	IF FSCDHFS2= 9 THEN FOODSEC_2LEV=99;
RUN;

proc freq data= hs1;
	table FOODSEC_2LEV H_INC EDUGH07;
run;



/* recoding N's for exclusion criteria to arrive at final sample - OVERALL POPULATION */


data hs1_remove;
	set hs1;
	if dhh_age < 2 then delete; 
run;
/* N after remove =  */

data hs1_remove;
	set hs1_remove;
	if R24FLOW=1 then delete; 
run;
/* N after remove =  */

data hs1_remove;
	set hs1_remove;
	if FSDDEKC=0 then delete; 
run;
/* N after remove =  */
/*
data healthsurvey_remove;
	set healthsurvey_remove;
	if WHC_03=1 then delete;
run;
*/
data hs1_remove;
	set hs1_remove;
	if WHC_05=1 then delete;
run;

/* N after remove =  */
DATA hs1_remove;
	SET hs1_remove;
	IF H_INC=99 THEN DELETE;
RUN;
DATA hs1_remove;
	SET hs1_remove;
	IF EDUGH07=99 THEN DELETE;
RUN;

DATA hs1_remove;
	SET hs1_remove;
	IF FOODSEC_2LEV=99 THEN DELETE;
RUN;


PROC FREQ DATA=hs1_remove;
	TABLE EDUGH07 FOODSEC_2LEV H_INC;
RUN;


*CREATE SUBGROUP (AGE/SEX), EXPOSURE LEVELS (FOOD SECURE 2 LEVELS NOW) AND TRANSFORMED OUTCOMES FOR REGRESSIONS;

data hs_final;
	set hs1_remove;

	IF 2 LE DHH_AGE  LE 18 THEN DO; KIDS=1; sex_age="kids"; END; 
	IF 19 LE DHH_AGE THEN DO; ADULTS=1; SEX_AGE="ADULTS"; END; 

	IF DHH_SEX=1 AND KIDS=1 THEN AGESEX="MALE, 2-18";
	IF DHH_SEX=2 AND KIDS=1 THEN AGESEX="FEMALE, 2-18";
	IF DHH_SEX=1 AND ADULTS=1 THEN AGESEX="MALE, 19+";
	IF DHH_SEX=2 AND ADULTS=1 THEN AGESEX="FEMALE, 19+";
	
run;

/****************************************************
Step 3 - merge HS, FID, and Bootstrap files together 
*****************************************************/

/*****************************************
MERGE WITH MISREPORT FILE
******************************************/

DATA CHILDREN;
	SET OUTPUT.STEP3_MISREPORTCHILDREN_NCI;
RUN;

DATA ADULTS;
	SET OUTPUT.STEP2_MISREPORTADULTS_NCI;
RUN;

PROC DATASETS;
	APPEND BASE=ADULTS
	DATA=CHILDREN;
RUN;

DATA MISREPORTALL_NCI;
	SET ADULTS;
RUN;


PROC SORT DATA=MISREPORTALL_NCI; BY ADM_RNO SUPPID ; RUN;

DATA HS_MISREPORT;
	MERGE  hs_final (IN=A) MISREPORTALL_NCI (IN=B);
	BY ADM_RNO SUPPID;
	IF A;

RUN;



DATA HS_MISREPORT;
	SET HS_MISREPORT;
	IF REPORTERS=. THEN MISREPORTERS=0.99; *MISSING STILL COUNTED;

	IF REPORTERS=1 THEN MISREPORTERS=1;*UNDEREPORT;

	IF REPORTERS=2 THEN MISREPORTERS=3;*PLAUSIBLE - SO IT IS REFERENCE;

	IF REPORTERS=3 THEN MISREPORTERS=2; *OVERREPORT;
	
RUN;

/*
PROC FREQ DATA=HS_MISREPORT;
	TABLE MISREPORTERS;where suppid=1;
RUN;
*/
/*
DATA HS_MISREPORT; SET HS_MISREPORT;
DROP REPORTERS;
RUN;


DATA HS_MISREPORT_1day;
set HS_MISREPORT;
where suppid=1;
run;

PROC FREQ DATA=HS_MISREPORT_1day;
	TABLE MISREPORTERS;
RUN;
*/

/****************************************************
merge HS file with 24H recall file
*****************************************************/
data SCB_FID_FRL_sum_2day;
set output.step1_sugary_derivation_nci_sum;
run;

proc sort data=SCB_FID_FRL_sum_2day; by adm_rno suppid; run;
proc sort data=HS_MISREPORT; by adm_rno suppid; run;

data HS_MISREPORT_FID_FRL;
	merge HS_MISREPORT (in=a) SCB_FID_FRL_sum_2day (in=b);
	by adm_rno suppid;
	if a and b;
run;




/*****************************************
Merge boostrap file with finallall1
******************************************/
data b5;
	set cchs.b5;
run;

proc sort data=b5; by adm_rno; run;

proc sort data=HS_MISREPORT_FID_FRL; by adm_rno; run;

data HS_MISREPORT_FID_FRL_BOOT;
	merge HS_MISREPORT_FID_FRL (in=a) b5 (in=b);
	by adm_rno;
	if a;
run;

/**** CREATE PERMANENT DATASETS ******/
libname baseline '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\cchsn_output_datasets\baseline_analysis';run; *to put 'permanent' datasets to work off of in different programs;
DATA baseline.BASELINE_2day; *these are baseline measures;
	SET HS_MISREPORT_FID_FRL_BOOT;
RUN;


DATA baseline.BASELINE_1day; *this is for baseline paper;
set HS_MISREPORT_FID_FRL_BOOT;
where suppid=1;
run;
