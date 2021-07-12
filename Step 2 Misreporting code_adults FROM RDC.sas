**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************

																MISREPOTING FOR ADULTS

**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************
**********************************************************************************************************************************************************************;


* NEED TO SET PHYSICAL ACTIVITY LEVELS- BASED ON DIDIERS CORRECTED EMAIL. 
;
*DIVIDE PHSGAPA BY 7 TO GET A ROUGH AVERAGE PER DAY, AND MULTIPLE BY 60 TO GET AVERAGE IN MINUTES*;
*REMOVE MISSING NOW OR IT'LL MESS UP CALCULATIONS*;

* STEP 1: SET THE DATASET;

libname cchs '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Data\CCHS Data\CCHS 2015 - Nutrition\datasets\PUMF';run;

libname output '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Analysis\cchsn_output_datasets';run; *to put 'permanent' datasets to work off of in different programs;


DATA PAL; SET cchs.Hs_nci;
RUN;


DATA PAL; 
SET PAL; 
IF R24FLOW= 1 THEN DELETE;
RUN;

* SET AN AGE RANGE TO ABOVE 2 YEARS N = 20 111;

DATA PAL;SET PAL;
IF DHH_AGE>= 19; RUN;


* NO VARIABLE TO REMOVE PREGNANT WOMEN;
/*DATA NONPREG; 
SET OVER2; 
IF WHC_03= 1 THEN DELETE; 
RUN;
*/

* REMOVE BREASTFEEDING;
DATA PAL; 
SET PAL; 
IF WHC_05=1 THEN DELETE; 
RUN;


DATA PAL; SET PAL;
IF PHSGAPA>=99 THEN DELETE; RUN;
* OBS REMOVED*;

PROC FREQ DATA=PAL; TABLE PHSGAPA;
RUN;

* NO MISSING, GOOD;

DATA PAL; SET PAL;
PALDAYMIN = (PHSGAPA/7)*60; RUN;

PROC FREQ DATA=PAL; TABLE PHSFPPA;
RUN;

PROC FREQ DATA=PAL; TABLE PALDAYMIN;
RUN;

*PHSFPPA represents moderate to vigorous physical activity;
*ASSIGN EVERYONE A PHYSICAL ACTIVITY LEVEL;

DATA PAL; SET PAL;
IF PHSFPPA = 2 OR PALDAYMIN <30 THEN PAL_1 = 1; *IF NO MODERATE/VIGOROUS EXERCISE OR < 30 MIN/DAY, THEN SEDENTARY*;
IF PHSFPPA = 1 AND 30 <= PALDAYMIN < 60 THEN PAL_1 = 2; *IF MODERATE/VIGOROUS EXERCISE BETWEEN 30-60 MIN/DAY, THEN LOW ACTIVE*;
IF PHSFPPA = 1 AND 60 =< PALDAYMIN < 180 THEN PAL_1 = 3; *IF MODERATE/VIGOROUS EXERCISE IS 60-180 MIN/DAY, THEN ACTIVE*;
IF PHSFPPA = 1 AND PALDAYMIN >=180 THEN PAL_1 = 4; *IF MODERATE/VIGOROUS EXERCISE IS > 180 MIN/DAY THEN VERY ACTIVE*;
RUN;


PROC FREQ DATA=PAL; TABLE PAL_1;
RUN;

** NEED TO CORRECT FOR BMI FIRST;

*MHWGBMI= MEASURED BMI * HWTGBMI= SELF REPORTED BMI;

DATA PAL; SET PAL;
IF MHWGBMI < 999 THEN BMICORRECTION = 0; 				   *THESE PPL ARE FINE, NO CORRECTION NEEDED THEY HAVE MEASURED BMI*;
IF MHWGBMI > 999 AND HWTGBMI < 999 THEN BMICORRECTION = 1; *THESE PPL NEED CORRECTION THEY HAVE NO MEASURED BMI BUT HAVE A SELF REPORTED*;
IF MHWGBMI > 999 AND HWTGBMI > 999 THEN BMICORRECTION = 2; *THESE PPL MUST BE REMOVED, NO MEASURED OR SELF REPORTED BMI*;
RUN;

PROC FREQ DATA=PAL; TABLE BMICORRECTION; RUN;

DATA PAL; SET PAL;
IF BMICORRECTION = 1 AND DHH_SEX = 1 THEN NEWBMI = -1.08 + (1.08*HWTGBMI);
IF BMICORRECTION = 1 AND DHH_SEX = 2 THEN NEWBMI = -0.12 + (1.05*HWTGBMI);
IF BMICORRECTION = 0 THEN NEWBMI = MHWGBMI;
RUN;

PROC FREQ DATA=PAL; TABLE NEWBMI BMICORRECTION; RUN;

*AND DELETE THOSE IN BMICORRECTION = 2*;
DATA PAL; SET PAL;
IF BMICORRECTION = 2 THEN DELETE; RUN;

PROC FREQ DATA=PAL; TABLE BMICORRECTION; RUN;

**********************************************
*MAKE BMI CATEGORIES, THEN REMOVE UNDERWEIGHT*
**********************************************;

*ROUND NEWBMI TO TWO DECIMAL PLACES*;
DATA PAL; SET PAL;
NEWBMI1 = ROUND(NEWBMI,0.01); RUN;

DATA PAL; SET PAL;
IF NEWBMI1 < 18.5 THEN BMICATEGORY = 0; *UNDERWEIGHT*;
IF 18.5 =< NEWBMI1 =< 24.99 THEN BMICATEGORY = 1; *NORMAL WEIGHT*;
IF 25 =< NEWBMI1 =< 29.99 THEN BMICATEGORY = 2;  *OVERWEIGHT*;
IF 30 =< NEWBMI1 =< 34.99 THEN BMICATEGORY = 3; *OBESE CLASS I*;
IF 35 =< NEWBMI1 =< 39.99 THEN BMICATEGORY = 4; *OBESE CLASS II*;
IF NEWBMI1 >= 40 THEN BMICATEGORY = 5; *OBESE CLASS III*;
RUN;

*3-CATEGORY OBESITY*;
DATA PAL; SET PAL;
IF NEWBMI1 < 18.5 THEN MBMI = 0; *UNDERWEIGHT*;
IF 18.5 =< NEWBMI1 =< 24.99 THEN MBMI = 1; *NORMAL WEIGHT*;
IF 25 =< NEWBMI1 =< 29.99 THEN MBMI = 2;  *OVERWEIGHT*;
IF 30 =< NEWBMI1 =< 34.99 THEN MBMI = 3; *OBESE CLASS I*;
IF 35 =< NEWBMI1 =< 39.99 THEN MBMI = 3; *OBESE CLASS II*;
IF NEWBMI1 >= 40 THEN MBMI = 3; *OBESE CLASS III*;
RUN;

*CHECK;
/*DATA UNDERWEIGHT; SET PAL;
IF MBMI = 0 THEN DELETE; RUN;
** ABOVE WE JUST CORRECTED THE BMI, WE DIDNT GIVE PEOPLE WHO DIDNT HAVE BMI A NEW BMI MEASURE;*/

*MEASURED WEIGHT AND MEASURED HEIGHT;

DATA EER; SET PAL; 
IF MHWGWTK < 999 AND MHWGHTM < 9.9; RUN;

PROC FREQ DATA=EER; TABLE MHWGWTK MHWGHTM MBMI; RUN;
*THERE ARE MISSING FOR MHWGWTK MHWGHTM -- MAKE A DATASET WITH NO MISSING, CALCULATE EER USING IOM FOR THOSE FIRST*;
* SAME NUMBER OF MISSING WEIGHT AND HEIGHT;

** IOM EQUATION FOR THOSE WITH MEASURED;


/* DONT NEED TO USE THE CCHS CLASSIFICATION HERE ONLY FOR 18 YEARS IN CHILDREN USE THIS METHOD
DATA EER; SET EER;
IF MHWGWHOA=01 THEN MBMI=0; *UNDERWEIGHT;
IF MHWGWHOA=02 THEN MBMI=1; *NORMAL WEIGHT;
IF MHWGWHOA=03 THEN MBMI=2; *OVERWEIGHT;
IF MHWGWHOA=04 THEN MBMI=3; *OBESE;
IF MHWGWHOA=05 THEN MBMI=3; *OBESE CLASS 2;
IF MHWGWHOA=06 THEN MBMI=3; *OBESE CLASS 3;
RUN;*/

** REMOVE UNDERWEIGHT;
DATA EER; SET EER;
IF MBMI >= 1;
RUN;
*#### PEOPLE REMOVED;

PROC FREQ DATA=EER; TABLE MBMI;
RUN;



*/NOW OVER 19*;
*BOYS NORMAL WEIGHT*;
*pal=1*;

DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=1 AND DHH_AGE>=19 
THEN EER= 661.8- (9.53 * DHH_AGE)+ ((15.91* MHWGWTK)+ (539.6* MHWGHTM));
RUN;

PROC FREQ DATA=EER; TABLE EER; RUN;

*EER=2*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=2 AND DHH_AGE>=19 
THEN EER= 661.8- (9.53 * DHH_AGE)+ (1.11*(15.91* MHWGWTK)+ (539.6* MHWGHTM));
RUN;

*EER=3*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=3 AND DHH_AGE>=19 
THEN EER= 661.8- (9.53 * DHH_AGE)+ (1.25*(15.91* MHWGWTK)+ (539.6* MHWGHTM));
RUN;

*EER=4*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1>=4 AND DHH_AGE>=19 
THEN EER= 661.8- (9.53 * DHH_AGE)+ (1.48*(15.91* MHWGWTK)+ (539.6* MHWGHTM));
RUN;
**



*NOW GIRLS OVER 19*;
*pal=1*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=1 AND DHH_AGE>=19 
THEN EER= 354.1- (6.91 * DHH_AGE)+ (((9.36* MHWGWTK)+ (726* MHWGHTM)));
RUN;

*pal=2*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=2 AND DHH_AGE>=19 
THEN EER= 354.1- (6.91 * DHH_AGE)+ (1.12*((9.36* MHWGWTK)+ (726* MHWGHTM)));
RUN;

*EER=3*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=3 AND DHH_AGE>=19 
THEN EER= 354.1- (6.91 * DHH_AGE)+ (1.27*((9.36* MHWGWTK)+ (726* MHWGHTM)));
RUN;

*EER=4*;
DATA EER; SET EER;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1>=4 AND DHH_AGE>=19 
THEN EER= 354.1- (6.91 * DHH_AGE)+ (1.45*((9.36* MHWGWTK)+ (726* MHWGHTM)));
RUN;



*NOW OVERWEIGHT ADULTS;

*BOYS OVER WEIGHT*;
*pal=1*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=1 AND PAL_1=1 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=1 AND PAL_1=1 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;

*pal=2*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=1 AND PAL_1=2 AND DHH_AGE>=19
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (1.12*((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=1 AND PAL_1=2 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (1.12*((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;

*pal=3*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=1 AND PAL_1=3 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (1.29*((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=1 AND PAL_1=3 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (1.29*((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;

*pal=4*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=1 AND PAL_1>=4 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (1.59*((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=1 AND PAL_1>=4 AND DHH_AGE>=19 
THEN EER= 1085.6- (10.08 * DHH_AGE)+ (1.59*((13.7* MHWGWTK)+ (416* MHWGHTM)));
RUN;



*NOW GIRLS OVER 19*;
*pal=1*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=2 AND PAL_1=1 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ ((11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=2 AND PAL_1=1 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ ((11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;

*pal=2*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=2 AND PAL_1=2 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ (1.16*(11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=2 AND PAL_1=2 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ (1.16*(11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;

*pal=3*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=2 AND PAL_1=3 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ (1.27*(11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=2 AND PAL_1=3 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ (1.27*(11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;

*pal=4*;
DATA EER; SET EER;
IF MBMI=2 AND DHH_SEX=2 AND PAL_1>=4 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ (1.44*(11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;
DATA EER; SET EER;
IF MBMI=3 AND DHH_SEX=2 AND PAL_1>=4 AND DHH_AGE>=19 
THEN EER= 447.6- (7.95 * DHH_AGE)+ (1.44*(11.4* MHWGWTK)+ (619* MHWGHTM));
RUN;

PROC FREQ DATA=EER; TABLE EER; RUN;

*NOW CALCULATE EER ON A DATASET OF WEIGHT/HEIGHT MISSING, USING USDA SPECIFICATION*;
PROC FREQ DATA=PAL; TABLE MHWGHTM;
RUN;
PROC FREQ DATA=PAL; TABLE MHWGWTK;
RUN;

DATA EER1; SET PAL; 
IF MHWGWTK >= 999 AND MHWGHTM >= 9.9; RUN;

PROC FREQ DATA=EER1; TABLE MHWGWTK MHWGHTM; RUN;


PROC FREQ DATA=EER1; TABLE PAL_1; RUN;


PROC FREQ DATA=EER1; TABLE PAL_1; RUN;

*MAKE A VARIABLE FOR USDA PHYSICAL ACTIVITY*;

PROC FREQ DATA=EER1; TABLE PHSGAPA;
RUN;


DATA EER1; SET EER1;
PALDAYMIN = (PHSGAPA/7)*60; RUN;

PROC FREQ DATA=EER1; TABLE PHSFPPA;
RUN;

PROC FREQ DATA=EER1; TABLE PALDAYMIN;
RUN;

DATA EER1; SET EER1;
IF PHSFPPA = 2 OR PALDAYMIN <30 THEN PAL_1 = 1; *IF NO MODERATE/VIGOROUS EXERCISE OR < 30 MIN/DAY, THEN SEDENTARY*;
IF PHSFPPA = 1 AND 30 <= PALDAYMIN < 60 THEN PAL_1 = 2; *IF MODERATE/VIGOROUS EXERCISE BETWEEN 30-60 MIN/DAY, THEN LOW ACTIVE*;
IF PHSFPPA = 1 AND 60 =< PALDAYMIN < 180 THEN PAL_1 = 3; *IF MODERATE/VIGOROUS EXERCISE IS 60-180 MIN/DAY, THEN ACTIVE*;
IF PHSFPPA = 1 AND PALDAYMIN >=180 THEN PAL_1 = 4; *IF MODERATE/VIGOROUS EXERCISE IS > 180 MIN/DAY THEN VERY ACTIVE*;
RUN;


DATA EER1; SET EER1;
IF PAL_1=1 THEN USDAPA = 1; *USDA SEDENTARY*;
IF PAL_1=2 THEN USDAPA = 2; *USDA MODERATELY ACTIVE*;
IF PAL_1 >=3 THEN USDAPA = 3; *USDA ACTIVE*;
RUN;

PROC FREQ DATA=EER1; TABLE USDAPA PAL_1; RUN;

*UDSA EQUATIONS;

*19-20*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 19<=DHH_AGE<=20 THEN EER1 = 2600; 
IF DHH_SEX=1 AND USDAPA=2 AND 19<=DHH_AGE<=20 THEN EER1 = 2800; 
IF DHH_SEX=1 AND USDAPA=3 AND 19<=DHH_AGE<=20 THEN EER1 = 3000; 

IF DHH_SEX=2 AND USDAPA=1 AND 19<=DHH_AGE<=20 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=2 AND 19<=DHH_AGE<=20 THEN EER1 = 2200; 
IF DHH_SEX=2 AND USDAPA=3 AND 19<=DHH_AGE<=20 THEN EER1 = 2400; RUN;

*21-25*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 21<=DHH_AGE<=25 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=2 AND 21<=DHH_AGE<=25 THEN EER1 = 2800; 
IF DHH_SEX=1 AND USDAPA=3 AND 21<=DHH_AGE<=25 THEN EER1 = 3000; 

IF DHH_SEX=2 AND USDAPA=1 AND 21<=DHH_AGE<=25 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=2 AND 21<=DHH_AGE<=25 THEN EER1 = 2200; 
IF DHH_SEX=2 AND USDAPA=3 AND 21<=DHH_AGE<=25 THEN EER1 = 2400; RUN;

*26-30*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 26<=DHH_AGE<=30 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=2 AND 26<=DHH_AGE<=30 THEN EER1 = 2600; 
IF DHH_SEX=1 AND USDAPA=3 AND 26<=DHH_AGE<=30 THEN EER1 = 3000; 

IF DHH_SEX=2 AND USDAPA=1 AND 26<=DHH_AGE<=30 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=2 AND 26<=DHH_AGE<=30 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=3 AND 26<=DHH_AGE<=30 THEN EER1 = 2400; RUN;

*31-35*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 31<=DHH_AGE<=35 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=2 AND 31<=DHH_AGE<=35 THEN EER1 = 2600; 
IF DHH_SEX=1 AND USDAPA=3 AND 31<=DHH_AGE<=35 THEN EER1 = 3000; 

IF DHH_SEX=2 AND USDAPA=1 AND 31<=DHH_AGE<=35 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=2 AND 31<=DHH_AGE<=35 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=3 AND 31<=DHH_AGE<=35 THEN EER1 = 2200; RUN;

*36-40*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 36<=DHH_AGE<=40 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=2 AND 36<=DHH_AGE<=40 THEN EER1 = 2600; 
IF DHH_SEX=1 AND USDAPA=3 AND 36<=DHH_AGE<=40 THEN EER1 = 2800; 

IF DHH_SEX=2 AND USDAPA=1 AND 36<=DHH_AGE<=40 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=2 AND 36<=DHH_AGE<=40 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=3 AND 36<=DHH_AGE<=40 THEN EER1 = 2200; RUN;

*41-45*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 41<=DHH_AGE<=45 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=2 AND 41<=DHH_AGE<=45 THEN EER1 = 2600; 
IF DHH_SEX=1 AND USDAPA=3 AND 41<=DHH_AGE<=45 THEN EER1 = 2800; 

IF DHH_SEX=2 AND USDAPA=1 AND 41<=DHH_AGE<=45 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=2 AND 41<=DHH_AGE<=45 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=3 AND 41<=DHH_AGE<=45 THEN EER1 = 2200; RUN;

*46-50*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 46<=DHH_AGE<=50 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=2 AND 46<=DHH_AGE<=50 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=3 AND 46<=DHH_AGE<=50 THEN EER1 = 2800; 

IF DHH_SEX=2 AND USDAPA=1 AND 46<=DHH_AGE<=50 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=2 AND 46<=DHH_AGE<=50 THEN EER1 = 2000; 
IF DHH_SEX=2 AND USDAPA=3 AND 46<=DHH_AGE<=50 THEN EER1 = 2200; RUN;

*51-55*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 51<=DHH_AGE<=55 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=2 AND 51<=DHH_AGE<=55 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=3 AND 51<=DHH_AGE<=55 THEN EER1 = 2800; 

IF DHH_SEX=2 AND USDAPA=1 AND 51<=DHH_AGE<=55 THEN EER1 = 1600; 
IF DHH_SEX=2 AND USDAPA=2 AND 51<=DHH_AGE<=55 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=3 AND 51<=DHH_AGE<=55 THEN EER1 = 2200; RUN;

*56-60*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 56<=DHH_AGE<=60 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=2 AND 56<=DHH_AGE<=60 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=3 AND 56<=DHH_AGE<=60 THEN EER1 = 2600; 

IF DHH_SEX=2 AND USDAPA=1 AND 56<=DHH_AGE<=60 THEN EER1 = 1600; 
IF DHH_SEX=2 AND USDAPA=2 AND 56<=DHH_AGE<=60 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=3 AND 56<=DHH_AGE<=60 THEN EER1 = 2200; RUN;

*61-65*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 61<=DHH_AGE<=65 THEN EER1 = 2000; 
IF DHH_SEX=1 AND USDAPA=2 AND 61<=DHH_AGE<=65 THEN EER1 = 2400; 
IF DHH_SEX=1 AND USDAPA=3 AND 61<=DHH_AGE<=65 THEN EER1 = 2600; 

IF DHH_SEX=2 AND USDAPA=1 AND 61<=DHH_AGE<=65 THEN EER1 = 1600; 
IF DHH_SEX=2 AND USDAPA=2 AND 61<=DHH_AGE<=65 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=3 AND 61<=DHH_AGE<=65 THEN EER1 = 2000; RUN;

*66-70*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 66<=DHH_AGE<=70 THEN EER1 = 2000; 
IF DHH_SEX=1 AND USDAPA=2 AND 66<=DHH_AGE<=70 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=3 AND 66<=DHH_AGE<=70 THEN EER1 = 2600; 

IF DHH_SEX=2 AND USDAPA=1 AND 66<=DHH_AGE<=70 THEN EER1 = 1600; 
IF DHH_SEX=2 AND USDAPA=2 AND 66<=DHH_AGE<=70 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=3 AND 66<=DHH_AGE<=70 THEN EER1 = 2000; RUN;

*71-75*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND 71<=DHH_AGE<=75 THEN EER1 = 2000; 
IF DHH_SEX=1 AND USDAPA=2 AND 71<=DHH_AGE<=75 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=3 AND 71<=DHH_AGE<=75 THEN EER1 = 2600; 

IF DHH_SEX=2 AND USDAPA=1 AND 71<=DHH_AGE<=75 THEN EER1 = 1600; 
IF DHH_SEX=2 AND USDAPA=2 AND 71<=DHH_AGE<=75 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=3 AND 71<=DHH_AGE<=75 THEN EER1 = 2000; RUN;

*76+*;
DATA EER1; SET EER1;
IF DHH_SEX=1 AND USDAPA=1 AND DHH_AGE>75 THEN EER1 = 2000; 
IF DHH_SEX=1 AND USDAPA=2 AND DHH_AGE>75 THEN EER1 = 2200; 
IF DHH_SEX=1 AND USDAPA=3 AND DHH_AGE>75 THEN EER1 = 2400; 

IF DHH_SEX=2 AND USDAPA=1 AND DHH_AGE>75 THEN EER1 = 1600; 
IF DHH_SEX=2 AND USDAPA=2 AND DHH_AGE>75 THEN EER1 = 1800; 
IF DHH_SEX=2 AND USDAPA=3 AND DHH_AGE>75 THEN EER1 = 2000; RUN;
*COMPARE*;
PROC MEANS DATA=EER1;
VAR EER1; RUN;
*LOWER MEAN THAN THE OTHER DATASET*;

PROC MEANS DATA=EER;
VAR EER; RUN;


*COMBINE TWO DATASETS*;

DATA EER; SET EER;
EERIOM =EER; RUN;

DATA EER; SET EER;
RENAME EER = EERFINAL; RUN;


DATA EER1; SET EER1;
EERUSDA =EER1; RUN;

DATA EER1; SET EER1;
RENAME EER1 = EERFINAL; RUN;

PROC SORT DATA=EER1; BY ADM_RNO SUPPID; RUN;
PROC SORT DATA=EER; BY ADM_RNO SUPPID; RUN;

DATA EERFINAL; MERGE EER1 EER; BY ADM_RNO SUPPID; RUN;

PROC FREQ DATA=EERFINAL; TABLE EERFINAL USDAPA; RUN;


*REMOVE UNDERWEIGHT;
DATA EERFINAL; SET EERFINAL;
IF MBMI=0 THEN DELETE; RUN;


PROC FREQ DATA=EERFINAL; TABLE MBMI;
RUN;

*CHECK THE DATASET; 

DATA CHECK; SET EERFINAL(KEEP= MHWGWTK MHWGHTM EERIOM EERUSDA);
RUN;

PROC SORT DATA=CHECK; BY MHWGWTK MHWGHTM; RUN;

PROC FREQ DATA=EERFINAL; TABLE FSDDEKC;
RUN;


*NOW LET'S DO REPORTERS FOR >19Y*;
DATA Eerfinal; SET Eerfinal;
ERATIO=FSDDEKC /EERFINAL;
RUN;

* EVERYTHING LOOKS GOOD;
*NOW LET'S DO REPORTERS FOR >19Y*;
DATA Eerfinal; SET Eerfinal;
IF ERATIO < 0.7 AND DHH_AGE=> 12 THEN REPORTERS=1;
IF ERATIO > 1.42 AND DHH_AGE=> 12  THEN REPORTERS=3;
IF 0.7=<ERATIO=<1.42 AND DHH_AGE=> 12 THEN REPORTERS=2;
RUN;

PROC SORT DATA=Eerfinal; BY REPORTERS; RUN;
PROC FREQ DATA=Eerfinal; TABLE REPORTERS; RUN;
*LOOKS GOOD*;

* set permanent dataset;

DATA OUTPUT.STEP2_MISREPORTADULTS_NCI;
set EERFINAL; 
keep adm_rno suppid reporters; run;




/** COMPARE TO DIDER PAPER;
DATA PALCHECK; SET EER;
IF EERIOM>0; RUN;

PROC FREQ DATA=EER; TABLE EERIOM; RUN;

*NOW LET'S DO REPORTERS FOR >19Y*;
DATA PALCHECK; SET PALCHECK;
ERATIO=FSDDEKC /EERIOM;
RUN;

DATA PALCHECK; SET PALCHECK;
IF ERATIO < #### AND DHH_AGE=> 12 THEN REPORTERS=1;
IF ERATIO > #### AND DHH_AGE=> 12  THEN REPORTERS=3;
IF ####=<ERATIO=<#### AND DHH_AGE=> 12 THEN REPORTERS=2;
RUN;

PROC SORT DATA=PALCHECK; BY DHHDDRI; RUN;
PROC SURVEYFREQ DATA=PALCHECK; TABLE REPORTERS; BY DHHDDRI; WEIGHT WTS_SHW; RUN;

*CHECK WITH THE WHOLE DATASET, PAL1*;
PROC SORT DATA=PALCHECK; BY DHHDDRI; RUN;
PROC SURVEYFREQ DATA=PALCHECK; TABLE REPORTERS; BY DHHDDRI; WEIGHT WTS_S; RUN;*/


