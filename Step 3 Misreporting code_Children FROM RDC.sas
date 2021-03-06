*************************************************************************************************************************
*************************************************************************************************************************

										MISREPORTING IN CCHS CHILDREN

*************************************************************************************************************************
*************************************************************************************************************************

STEP 1: REMOVE ALL MISSING MEASURED HEIGHT AND WEIGHT
STEP 2. USE THE VARIABLES FOR BMI AND COMBINE INTO 1
STEP 3. CHANGE CUT POINTS FOR MISREPORTING FOR UNDER 12 AND OVER 12*/
STEP 4. DETERMINE PAL NO USDA (USDA METHOD IS FOR ADULTS) METHOD- CHECK 96 AND 99 WITH HEALTH CANADA AND SET TO SEDINTARY ACCORDING TO DIDIER
STEP 5. EER WILL HAVE DIFFERENT EQUATIONS FOR A)CHILDREN 2 YEARS B)NORMAL WEIGHT C)OVERWEIGHT D) OBESE AND E) 18 YEARS-USING MAHSA'S EQUATIONS ;

*************************************************************************************************************************
*************************************************************************************************************************;

libname cchs '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Data\CCHS Data\CCHS 2015 - Nutrition\datasets\PUMF';run;

libname output '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Analysis\cchsn_output_datasets';run; *to put 'permanent' datasets to work off of in different programs;

*STEP 1;


DATA HS; SET cchs.HS_NCI;
run;



DATA CHILDREN; SET HS;
IF 2=<DHH_AGE<=18;
RUN;

PROC FREQ DATA=CHILDREN; TABLE DHH_AGE;
RUN;


PROC FREQ DATA=CHILDREN; TABLE DHHDDRI; RUN;
*THERE ARE THREE SCENARIOS: 1) MEASURED BMI AVAILABLE, 2) MEASURED UNAVAIL BUT SELF-REPORT AVAIL, 3) NEITHER AVAIL*;
*MHWGBMI= MEASURED BMI HWTDBMI= SELF REPORTED BMI;

PROC FREQ DATA=CHILDREN; TABLE MHWGBMI;
RUN;




DATA CHILDREN; SET CHILDREN;
IF MHWGBMI < 999 THEN BMICORRECTION = 0; 				   *THESE PPL ARE FINE, NO CORRECTION NEEDED*;
IF MHWGBMI > 999 AND HWTGBMI < 999 THEN BMICORRECTION = 1; *THESE PPL NEED CORRECTION*;
IF MHWGBMI > 999 AND HWTGBMI > 999 THEN BMICORRECTION = 2; *THESE PPL MUST BE REMOVED*;
RUN;

PROC FREQ DATA=CHILDREN; TABLE BMICORRECTION; RUN;

*FOR TABLE 3, USE MHWGBMI (MEASURED BMI) FOR TABLE

* BMI CATEGORIES ARE BASED ON 2 NEW VARIABLES IN CCHS 2015 MHWGWHOP (2-5 YEARS) AND MHWGWHOY (5-17 YEARS) ; 

* CODE FOR 2-5 YEARS SOME PEOPLE DID NOT REPORT;
DATA CHILDREN;SET CHILDREN;
IF MHWGWHOP=1 THEN MBMI1=0; *UNDERWEIGHT;
IF MHWGWHOP=2 THEN MBMI1=1; *NORMAL WEIGHT;
IF MHWGWHOP=3 THEN MBMI1=1; *AT RISK FOR OVERWEIGHT BUT NOT, CLASSIFIED AS NORMAL;
IF MHWGWHOP=4 THEN MBMI1=2; *OVERWEIGHT;
IF MHWGWHOP=5 THEN MBMI1=3; *OBESE;
RUN;

DATA CHECK1; SET CHILDREN (KEEP=MBMI1 MHWGWHOP dhh_age DHH_SEX MHWGBMI MHWGBMI MHWGHTM MHWGWTK);
IF DHH_AGE=<5;
RUN;
PROC SORT DATA=CHECK1; BY MBMI1; RUN;
*RESPONDENTS HAVE MISSING HEIGHT AND WEIGHT CHILDREN AGE CANNOT BE CORRECTED FOR BMI;

PROC FREQ DATA=CHECK1; TABLE MBMI1;
RUN;

* CODE FOR BMI (5-17 YEARS);
DATA CHILDREN; SET CHILDREN;
IF MHWGWHOY=1 THEN MBMI2=0; *UNDERWEIGHT;
IF MHWGWHOY=2 THEN MBMI2=1; *NORMAL;
IF MHWGWHOY=3 THEN MBMI2=2; *OVERWEIGHT;
IF MHWGWHOY=4 THEN MBMI2=3; *OBESE;
RUN;

DATA CHECK2; SET CHILDREN (KEEP= MBMI2 MHWGWHOY MHWGWHOP dhh_age DHH_SEX MHWGBMI MHWGBMI MHWGHTM MHWGWTK);
IF 5<=DHH_AGE<=17;
RUN;



PROC SORT DATA=CHECK2; BY MHWGWHOY; RUN;

* YOU WILL HAVE MISSING BECAUSE OF 18 YEAR OLDS, NEED TO CLASSIFY THEM ACCORDING TO OLDER ADULTS;
*COMBINE ALL BMI CATEGORIES TO CREATE ONE COLUMN;
* USE MHWGWHOA FOR 18 YEAR OLDS ONLY;
DATA CHILDREN; SET CHILDREN;
IF MHWGWHOA=01 THEN MBMI3=0; *UNDERWEIGHT;
IF MHWGWHOA=02 THEN MBMI3=1; *NORMAL WEIGHT;
IF MHWGWHOA=03 THEN MBMI3=2; *OVERWEIGHT;
IF MHWGWHOA=04 THEN MBMI3=3; *OBESE;
IF MHWGWHOA=05 THEN MBMI3=3; *OBESE CLASS 2;
IF MHWGWHOA=06 THEN MBMI3=3; *OBESE CLASS 3;
RUN;

DATA CHECK3; SET CHILDREN (KEEP=MBMI1 MBMI2 MBMI3 MHWGWHOY MHWGWHOP MHWGWHOA dhh_age DHH_SEX MHWGBMI MHWGBMI   MHWGHTM MHWGWTK);
IF DHH_AGE=18;                 
RUN;

** EVEN THOUGH SOME PEOPLE HAVE MEASURED HEIGHT AND WEIGHT, MEASURED BMI MAY BE REPORTED AS MISSING BECAUSE THESE PEOPLE REFUSED TO ANSWER SOME QUESTIONS FOR EXAMPLE
WHETHER THEY WERE PREGNANT OR NOT OR REFUSED TO SAY SO THEIR BMI WAS REPORTED AS 999.96 AS SET BY HEALTH CANADA AND THUS WILL HAVE MISSING BMI;

PROC SORT DATA=CHECK3; BY MBMI3; RUN;


DATA CHILDREN;
SET CHILDREN;
IF 0<=MBMI1<=3 THEN MBMI=MBMI1;
IF 0<=MBMI2<=3 THEN MBMI=MBMI2;
IF 0<=MBMI3<=3 THEN MBMI=MBMI3;
RUN;

DATA CHECK5; SET CHILDREN(KEEP=MBMI dhh_age DHH_SEX MHWGBMI MBMI1 MBMI2 MBMI3 MHWGWHOA MHWGWHOY MHWGWHOP MHWGHTM MHWGWTK);
RUN;

PROC SORT DATA=CHECK5; BY MHWGBMI; RUN;

PROC FREQ DATA=CHILDREN; TABLE MBMI; RUN;
*WILL HAVE TO REMOVE UNDWEIGHT;

DATA CHILDREN; SET CHILDREN;
IF MBMI=0 THEN DELETE; RUN;

PROC FREQ DATA=CHILDREN; TABLE MBMI; RUN;

* MEASURED HEIGHT VARIABLE MHWGHTM
* MEASURED WEIGHT VARIABLE ;
*REMOVE MISSING BMI;

PROC SORT DATA=CHILDREN; BY MBMI;
RUN;


DATA CHILDREN; SET CHILDREN;
IF MHWGBMI >=999 THEN DELETE;
RUN;



* STEP 2- CALCULATE PAL;
* PHSGAPA-cant work because this is for over 18 years use CPAGTOT: hours/week, THIS PAPER WILL ONLY LOOK AT PAL LEVELS FOR THOSE 6 YEARS AND OVER ;


PROC FREQ DATA=CHILDREN; TABLE CPAGTOT; RUN;
* RANGES FROM 0-99 HOURS, 96 AND 99 ARE INVALID AND CAN BE SET ACCORDING TO DIDER 2018 THESE ARE 18 Y OLD ;

data TEST; set CHILDREN (keep=dhh_age CPAGTOT);
run;
proc sort data=test; by CPAGTOT; run;
* MAXIMUM AMOUNT OF HOURS OF PHYSICAL ACTIVITY IS 35 HOURS- ALSO THIS IS ONLY INFORMATION FOR 6-17 YEARS;


proc sort data=CHILDREN; by CPAGTOT; run;
* CANT REMOVE THOSE BETWEEN 2-6 BECAUSE WE STILL NEED THERE DATA, WE WILL HAVE TO SET 96 AND 99 FOR THEM TO ".";
*** HERE, NEED TO START DEAL WITH MISSING ADD PAL LEVEL FOR 18 YEARS;

DATA PAL; SET CHILDREN;
PALDAYMINCHILD = ((CPAGTOT)*60)/7; RUN;

PROC FREQ DATA=PAL; TABLE PALDAYMINCHILD; RUN;
* GIVES YOU MINUTES/DAY 96 AND 99 AS USERGUIDE S:\CCHS 2015 Nutrition\documentation\english\codebooks\CCHS_2015_F1_T15.4_v1; 

*DIVIDE PHSGAPA BY 7 TO GET A ROUGH AVERAGE PER DAY, AND MULTIPLE BY 60 TO GET AVERAGE IN MINUTES*;
DATA PAL; SET PAL;
PALDAYMIN18 = (PHSGAPA/7)*60; RUN;

PROC FREQ DATA=PAL; TABLE PALDAYMIN18; RUN;

data CHECK6; set PAL (keep=dhh_age CPAGTOT PHSGAPA PALDAYMINCHILD PALDAYMIN18 ); run;
PROC SORT DATA=CHECK6; BY DHH_AGE;
RUN;


PROC FREQ DATA=PAL; TABLE CPAGTOT; RUN;

PROC FREQ DATA=PAL; TABLE PHSGAPA; RUN;

PROC FREQ DATA=PAL; TABLE PALDAYMINCHILD; RUN;

PROC FREQ DATA=PAL; TABLE PALDAYMIN18; RUN;

DATA PAL; SET PAL;
IF PALDAYMINCHILD <30 THEN PAL_3 = 1; *IF NO MODERATE/VIGOROUS EXERCISE OR < 30 MIN/DAY, THEN SEDENTARY*;
IF 30 <= PALDAYMINCHILD < 60 THEN PAL_3 = 2; *IF MODERATE/VIGOROUS EXERCISE BETWEEN 30-60 MIN/DAY, THEN LOW ACTIVE*;
IF 60 =< PALDAYMINCHILD < 180 THEN PAL_3 = 3; *IF MODERATE/VIGOROUS EXERCISE IS 60-180 MIN/DAY, THEN ACTIVE*;
IF PALDAYMINCHILD >=180 THEN PAL_3 = 4; *IF MODERATE/VIGOROUS EXERCISE IS > 180 MIN/DAY THEN VERY ACTIVE*;
RUN;

DATA PAL; SET PAL;
IF PALDAYMIN18 <30 THEN PAL_2 = 1; *IF NO MODERATE/VIGOROUS EXERCISE OR < 30 MIN/DAY, THEN SEDENTARY*;
IF 30 <= PALDAYMIN18 < 60 THEN PAL_2 = 2;*IF MODERATE/VIGOROUS EXERCISE BETWEEN 30-60 MIN/DAY, THEN LOW ACTIVE*;
IF 60 =< PALDAYMIN18 < 180 THEN PAL_2 = 3; *IF MODERATE/VIGOROUS EXERCISE IS 60-180 MIN/DAY, THEN ACTIVE*;
IF PALDAYMIN18 >=180 THEN PAL_2 = 4; *IF MODERATE/VIGOROUS EXERCISE IS > 180 MIN/DAY THEN VERY ACTIVE*;
RUN;

DATA PAL;
SET PAL;
IF CPAGTOT >= 96 THEN PAL_3=.;
IF PHSGAPA > 99 THEN PAL_2 = .;
RUN;


data CHECK8; set PAL (keep=dhh_age PAL_3 PAL_2 CPAGTOT PHSGAPA PALDAYMINCHILD PALDAYMIN18 ); run;

proc sort data=CHECK8; by dhh_age ; run;
* GOOD;
* MAKE ONE PHYSICAL ACTIVITY VARIABLE;

DATA PAL;
SET PAL;
IF 1<=PAL_3<=4 THEN PAL_1=PAL_3;
IF 1<=PAL_2<=4 THEN PAL_1=PAL_2;
RUN;
*GOOD!!;
data CHECK9; set PAL (keep=dhh_age PAL_3 PAL_2 PAL_1 CPAGTOT PHSGAPA PALDAYMINCHILD PALDAYMIN18 ); run;

proc sort data=CHECK9; by dhh_age ; run;


* ACCORDING TO DIDER 2018 MISREPORTING PAPER, CHILDREN 14 YEARS AND YOUNGER WITH MISSING PAL LEVELS CAN BE ASSUMED TO BE LOW ACTIVE, SET PAL=0 FOR THOSE MISSING BETWEEN THE AGE OF 2-5Y AND 
FOR RESPONDANTS OVER 14 THEY ARE ASSUMED TO BE SEDINTARY THESE ARE CONSISTANT WITH CHMS.;


PROC FREQ DATA=PAL; TABLE PAL_1;
RUN;


DATA PAL;
SET PAL;
IF 2<=DHH_AGE<=18 AND PAL_1="." THEN PAL_1=0;
RUN;


* EVERYONE WITH A MISSING WILL HAVE A PAL=0; 

PROC FREQ DATA=PAL; TABLE DHH_AGE;
RUN;

DATA PAL;SET PAL;
IF DHH_AGE <3 THEN DELETE;
RUN;
*/
*********************************************************************
						IOM EER EQUATIONS NOW
*********************************************************************;



PROC FREQ DATA=PAL; TABLE DHH_AGE; RUN;
* AGE IS FROM 2 YEARS TO 18 YEARS ....NOW CALCULATE EER USING IOM FOR THOSE FIRST*;
* NEED TO REMOVE MISSING WEIGHT AND HEIGHT BEFORE EER EQUATIONS;

PROC FREQ DATA=PAL; TABLE MHWGWTK; RUN;
PROC FREQ DATA=PAL; TABLE MHWGHTM; RUN;


DATA PAL; SET PAL;
IF MHWGWTK >= 999 THEN DELETE; RUN;


DATA PAL; SET PAL;
IF MHWGHTM >= 9.99 THEN DELETE; RUN;



*/* BOYS NORMAL WEIGHT 3-8 YEARS;



*PAL=0 ACCORDING DIDER LOW ACTIVE;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=0 AND 3<=DHH_AGE<=8 
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.13*(26.7* MHWGWTK)+(903* MHWGHTM))+20;
RUN;


** EER AGE CUT OFF NOW;
*PAL=1;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=1 AND 3<=DHH_AGE<=8 
THEN EER= 88.5- (61.9 * DHH_AGE)+ ((26.7* MHWGWTK)+(903* MHWGHTM))+20;
RUN;

* PAL=2;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=2 AND 3<=DHH_AGE<=8 
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.13*(26.7* MHWGWTK)+(903* MHWGHTM))+20;
RUN;

* PAL=3;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=3 AND 3<=DHH_AGE<=8 
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.26*(26.7* MHWGWTK)+(903* MHWGHTM))+20;
RUN;
* PAL=4;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=4 AND 3<=DHH_AGE<=8 
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.42*(26.7* MHWGWTK)+(903* MHWGHTM))+20;
RUN;

* BOYS NORMAL WEIGHT 9-18 YEARS;

*PAL=0 ACCORDING DIDER LOW ACTIVE, NEED TO SPLIT UP THE AGE GROUPS BECAUSE DIFFERENT PA LEVELS SAME EQUATION;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=0 AND 9<=DHH_AGE<=13  
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.13*(26.7* MHWGWTK)+(903* MHWGHTM))+25;
RUN;
* CONSIDERED LOW ACTIVE;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=0 AND 14<=DHH_AGE<=18  
THEN EER= 88.5- (61.9 * DHH_AGE)+ ((26.7* MHWGWTK)+(903* MHWGHTM))+25;
RUN;
*CONSDIERED SEDENTARY;

*PAL=1;
DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=1 AND 9<=DHH_AGE<=18  
THEN EER= 88.5- (61.9 * DHH_AGE)+ ((26.7* MHWGWTK)+(903* MHWGHTM))+25;
RUN;

*PAL=2;
DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=2 AND 9<=DHH_AGE<=18  
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.13*(26.7* MHWGWTK)+(903* MHWGHTM))+25;
RUN;


*PAL=3;
DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=3 AND 9<=DHH_AGE<=18  
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.26*(26.7* MHWGWTK)+(903* MHWGHTM))+25;
RUN;


*PAL=4;
DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=1 AND PAL_1=4 AND 9<=DHH_AGE<=18  
THEN EER= 88.5- (61.9 * DHH_AGE)+ (1.42*(26.7* MHWGWTK)+(903* MHWGHTM))+25;
RUN;




**** GIRLS 3-8 YEARS;


DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=0 AND 3<=DHH_AGE<=8  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.16*(10.0* MHWGWTK)+(934* MHWGHTM))+20;
RUN;
*LOW ACTIVE;


*PAL=1 EER;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=1 AND 3<=DHH_AGE<=8  
THEN EER= 135.3- (30.8 * DHH_AGE)+ ((10.0* MHWGWTK)+(934* MHWGHTM))+20;
RUN;
*PAL=2;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=2 AND 3<=DHH_AGE<=8  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.16*(10.0* MHWGWTK)+(934* MHWGHTM))+20;
RUN;

*PAL=3;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=3 AND 3<=DHH_AGE<=8  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.31*(10.0* MHWGWTK)+(934* MHWGHTM))+20;
RUN;

*PAL=4;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=4 AND 3<=DHH_AGE<=8  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.56*(10.0* MHWGWTK)+(934* MHWGHTM))+20;
RUN;

**** GIRLS 9-18 YEARS;
* PAL=0 WILL NEED SAME EQUATION BUT DIFFERENT PA LEVELS FOR DIFFERENT AGES;


DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=0 AND 9<=DHH_AGE<=13  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.16*(10.0* MHWGWTK)+(934* MHWGHTM))+25;
RUN;
*LOW ACTIVE;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=0 AND 14<=DHH_AGE<=18  
THEN EER= 135.3- (30.8 * DHH_AGE)+ ((10.0* MHWGWTK)+(934* MHWGHTM))+25;
RUN;
*SEDENTARY;


* PAL=1;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=1 AND 9<=DHH_AGE<=18  
THEN EER= 135.3- (30.8 * DHH_AGE)+ ((10.0* MHWGWTK)+(934* MHWGHTM))+25;
RUN;

* PAL=2;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=2 AND 9<=DHH_AGE<=18  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.16*(10.0* MHWGWTK)+(934* MHWGHTM))+25;
RUN;
* PAL=3;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=3 AND 9<=DHH_AGE<=18  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.31*(10.0* MHWGWTK)+(934* MHWGHTM))+25;
RUN;

* PAL=4;

DATA PAL; SET PAL;
IF MBMI=1 AND DHH_SEX=2 AND PAL_1=4 AND 9<=DHH_AGE<=18  
THEN EER= 135.3- (30.8 * DHH_AGE)+ (1.56*(10.0* MHWGWTK)+(934* MHWGHTM))+25;
RUN;


* UP TO HERE COMPLETED NORMAL MBMI=1, FOR BOYS AND GIRLS 3-18 Y;

*HERE USE PAL DATASET;

**************************************************************************************************
						IOM EER EQUATIONS OVERWEIGHT AND OBESE BMI, MBMI=2,3
*************************************************************************************************;



*OVERWEIGHT AND OBESE CATEGORY CALCULATIONS*;

***MALES***;

***START WITH THOSE 3-11 YEARS AT RISK FOR OVERWEIGHT BMI OVER 85TH PERCENTILE-COLE 2 AND 3 WITH PAL=0 KE MALE HAMEYE KASAYNI KE UNDER 12 HASTAN PAL=0 AND IF AGED 3-8*;
*THOSE OVER 12 HAVE DIF PALS SO ONLY UNDER 12 CAN BE TAKEN TOGETHER. FORMULA FOR 3-18 YEARS IS THE SAME*;




**************************************************************************************************************************************************************************************;
*MALES
* 3-13 Y;


DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=1 AND PAL_1=0 AND 3<=DHH_AGE<= 13
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.12*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=1 AND PAL_1=0 AND 3<=DHH_AGE<= 13
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.12*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;
* LOW ACTIVE;
****
*14-18 YEARS;
DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=1 AND PAL_1=0 AND 14<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ ((19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=1 AND PAL_1=0 AND 14<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ ((19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;
* OVER 14 CONSIDERED SEDENTARY;

***

*PAL=1-4 NO CHANGE IN EER EQUATION FOR OVERWEIGHT AND OBESE BETWEEN AGES 3-18Y, BUT PA CHANGES;
* 3-18 Y;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=1 AND PAL_1=1 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ ((19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=1 AND PAL_1=1 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ ((19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;


*PAL=2;


DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=1 AND PAL_1=2 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.12*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=1 AND PAL_1=2 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.12*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

* PAL=3;


DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=1 AND PAL_1=3 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.24*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=1 AND PAL_1=3 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.24*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

* PAL=4;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=1 AND PAL_1=4 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.45*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=1 AND PAL_1=4 AND 3<=DHH_AGE<= 18
THEN EER= 114.1- (50.9 * DHH_AGE)+ (1.45*(19.5* MHWGWTK)+ (1161.4* MHWGHTM));
RUN;


**************************************************************************************************************************************************************************
GIRLS 3-13 Y AND 14 AND OVER ARE DIFFERENT PA VALUES BUT SAME EQUAION!!;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=2 AND PAL_1=0 AND 3<=DHH_AGE<= 13
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.18*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=2 AND PAL_1=0 AND 3<=DHH_AGE<= 13
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.18*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;
*LOW ACTIVE;

* 14 AND OVER;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=2 AND PAL_1=0 AND 14<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ ((15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=2 AND PAL_1=0 AND 14<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ ((15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;
*SEDENTARY;


*3-18 YEARS, SAME EQUATION FOR ALL AGES NOW DIFFERENT ENERGY Values for PAL 1-4;

*PAL=1;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=2 AND PAL_1=1 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ ((15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=2 AND PAL_1=1 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ ((15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

*PAL=2;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=2 AND PAL_1=2 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.18*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=2 AND PAL_1=2 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.18*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

*PAL=3;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=2 AND PAL_1=3 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.35*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=2 AND PAL_1=3 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.35*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;


*PAL=4;

DATA PAL; SET PAL;
IF MBMI= 2 AND DHH_SEX=2 AND PAL_1=4 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.60*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;

DATA PAL; SET PAL;
IF MBMI= 3 AND DHH_SEX=2 AND PAL_1=4 AND 3<=DHH_AGE<= 18
THEN EER= 389.2- (41.2 * DHH_AGE)+ (1.60*(15* MHWGWTK)+ (701.6* MHWGHTM));
RUN;




PROC FREQ DATA= PAL; TABLE EER;
RUN;
PROC FREQ DATA= PAL; TABLE mbmi;
RUN;



DATA PAL; SET PAL;
IF MHWGBMI >= 999 THEN DELETE; RUN;




** REMEMBER NO SMOKING FOR THIS GROUP;


*NEED TO SPLIT IT INTO THE QUARTILES BASED ON THE CORRECTED DATASET TO DO TABLE 3 AND 4 ADJUSTED AFTER IDENTIFICATION OF MISREPORTING;


*MISREPORTING;


***IDENTIFYING OVER AND UNDERREPORTERS METHODS 1: RATIO OF ENERY REQUIREMENT TO ENERGY INTAKES***;

*check missing of all continuous variables*;

PROC FREQ DATA=PAL;
TABLE FSDDEKC;
RUN;


DATA PAL; SET PAL;
ERATIO=FSDDEKC/EER;
RUN;

PROC SORT DATA=PAL; BY ERATIO; RUN;
PROC FREQ DATA=PAL; TABLE ERATIO; RUN;



DATA PAL; SET PAL;
IF ERATIO < 0.7 AND DHH_AGE=> 12 THEN REPORTERS=1;
IF ERATIO > 1.42 AND DHH_AGE=> 12  THEN REPORTERS=3;
IF 0.7=<ERATIO=<1.42 AND DHH_AGE=> 12 THEN REPORTERS=2;
IF ERATIO < 0.74 AND DHH_AGE <12 THEN REPORTERS=1;
IF ERATIO > 1.35 AND DHH_AGE <12 THEN REPORTERS=3;
IF 0.74=<ERATIO=<1.35 AND DHH_AGE <12 THEN REPORTERS=2;
RUN;

PROC FREQ DATA=PAL; TABLE REPORTERS; RUN;




*CREATE PERMANENT;


DATA OUTPUT.STEP3_MISREPORTCHILDREN_NCI;
	SET PAL;
	keep adm_rno suppid reporters;
RUN;


