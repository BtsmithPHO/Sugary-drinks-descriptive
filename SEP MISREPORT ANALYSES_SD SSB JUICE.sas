/* FEB 05 2020
ADJUSTED REGRESSIONS FOR SUGAR SUGARY DRINKS (SCB)
FOR EACH SEP INDICATOR INCOME, EDUC, FOOD SEC
STRATIFIED BY SEX/AGE
ADJUSTED FOR MISREPORTERS 
*/

libname baseline '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\cchsn_output_datasets\baseline_analysis';run; *to put 'permanent' datasets to work off of in different programs;

DATA FINAL1; 
	SET baseline.baseline_1day;
	if 2 <= dhh_age <= 18 then AGE_GROUP="KIDS";
	if dhh_age >=19 then AGE_GROUP="ADULTS";
RUN;

/*** 
Test analyses:
1) run odds ratios SD in kids adjust for sex in model for education for all SEP 
- try running LSMEANS sex*education


PROC SURVEYLOGISTIC DATA= FINAL1;
	CLASS SCBYES EDUGH07 MISREPORTERS DHH_SEX/ param=glm ref = last ;  ;
	MODEL SCBYES (desc) = EDUGH07  MISREPORTERS DHH_SEX DHH_SEX*EDUGH07/ CLODDS clparm;
	DOMAIN AGE_GROUP;
	lsmeans DHH_SEX*EDUGH07 / oddsratio cl exp;
	weight wts_p;
	*repweights bsw1-bsw500;
run;

PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES FOODSEC_2LEV MISREPORTERS DHH_SEX/ param=glm ref = last ;  ;
	MODEL SCBYES (desc) = FOODSEC_2LEV  MISREPORTERS DHH_SEX DHH_SEX*FOODSEC_2LEV/ CLODDS clparm;
	DOMAIN AGE_GROUP;
	lsmeans DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;

PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES H_INC MISREPORTERS DHH_SEX/ param=glm ref = last ;  ;
	MODEL SCBYES (desc) = H_INC  MISREPORTERS DHH_SEX DHH_SEX*H_INC/ CLODDS clparm;
	DOMAIN AGE_GROUP;
	lsmeans DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;

/*
proc freq data=final1;
table age_group;
run;

proc means data=final1;
var fid_ekc;
class misreporters;
run;

ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\mean-age-sep-check-mar24.rtf'; 
TITLE1 'Mean age across SEP indicators in overall sample';

proc surveymeans data=final1 VARMETHOD=BRR;
var ;
domain EDUGH07 FOODSEC_2LEV H_INC / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

proc surveymeans data=final1 VARMETHOD=BRR;
var ;
domain EDUGH07*AGE_GROUP*DHH_SEX FOODSEC_2LEV*AGE_GROUP*DHH_SEX H_INC*AGE_GROUP*DHH_SEX / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

TITLE1 'Mean age across SEP indicators among consumers of SD';
proc surveymeans data=final1 VARMETHOD=BRR;
where SCBYES=100;
var ;
domain EDUGH07 FOODSEC_2LEV H_INC / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

proc surveymeans data=final1 VARMETHOD=BRR;
where SCBYES=100;
var ;
domain EDUGH07*AGE_GROUP*DHH_SEX FOODSEC_2LEV*AGE_GROUP*DHH_SEX H_INC*AGE_GROUP*DHH_SEX / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

TITLE1 'Mean age across SEP indicators among consumers of SSB';
proc surveymeans data=final1 VARMETHOD=BRR;
where SSBYES=100;
var ;
domain EDUGH07 FOODSEC_2LEV H_INC / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

proc surveymeans data=final1 VARMETHOD=BRR;
where SSBYES=100;
var ;
domain EDUGH07*AGE_GROUP*DHH_SEX FOODSEC_2LEV*AGE_GROUP*DHH_SEX H_INC*AGE_GROUP*DHH_SEX / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

TITLE1 'Mean age across SEP indicators among consumers of JUICE';
proc surveymeans data=final1 VARMETHOD=BRR; 
where JUICEYES=100;
var ;
domain EDUGH07 FOODSEC_2LEV H_INC / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

proc surveymeans data=final1 VARMETHOD=BRR; 
where JUICEYES=100;
var ;
domain EDUGH07*AGE_GROUP*DHH_SEX FOODSEC_2LEV*AGE_GROUP*DHH_SEX H_INC*AGE_GROUP*DHH_SEX / diffmeans cldiff;
weight wts_p;
repweights bsw1-bsw500;
run;

ods rtf close;

*/

/****************
PREVALENCE OF INTAKE 
******************/
ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\misreport-prevalence-consumption-sep-PUMF.rtf'; 

/***************************************************************************************************************************************************************************************************
OUTCOME: SUGARY DRINKS
***************************************************************************************************************************************************************************************************/

/* 1 PREVALENCE */
TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 1 - PREVALENCE OF SUGARY DRINK CONSUMPTION';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES EDUGH07 MISREPORTERS ;
	MODEL SCBYES = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES FOODSEC_2LEV MISREPORTERS ;
	MODEL SCBYES = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES H_INC MISREPORTERS ;
	MODEL SCBYES = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;



/*******************************************************************************************************************************************************************************************************
OUTCOME: SUGAR SWEETENED BEVERAGES
***********************************************************************************************************************************************************************************************/

/* 1 PREVALENCE */

TITLE1 'OUTCOMES = SUGAR SWEETENED  CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 1 - PREVALENCE OF SUGAR SWEETENED BEVERAGE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES EDUGH07 MISREPORTERS ;
	MODEL SSBYES = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES FOODSEC_2LEV MISREPORTERS ;
	MODEL SSBYES = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES H_INC MISREPORTERS ;
	MODEL SSBYES = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;



/********************************************************************************************************************************************************************************************************
OUTCOME: 100% JUICE
*********************************************************************************************************************************************************************************************************/

/* 1 PREVALENCE */

TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 1 - PREVALENCE OF 100% JUICE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES EDUGH07 MISREPORTERS ;
	MODEL JUICEYES = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES FOODSEC_2LEV MISREPORTERS ;
	MODEL JUICEYES = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES H_INC MISREPORTERS ;
	MODEL JUICEYES = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;

/****************
ENERGY AMONG CONSUMERS INTAKE 
******************/
ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\misreport-energy-consumption-sep-PUMF-mar25.rtf'; 

/* UNTRANSFORMED ENERGY FROM SCB */

TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED ENERGY FROM SCB AMONG CONSUMERS';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07 MISREPORTERS ;
	MODEL SCB_sum_energy = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV MISREPORTERS ;
	MODEL SCB_sum_energy = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC MISREPORTERS ;
	MODEL SCB_sum_energy = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

/*******************************************************************************************************************************************************************************************************
OUTCOME: SUGAR SWEETENED BEVERAGES
***********************************************************************************************************************************************************************************************/

/* UNTRANSFORMED ENERGY FROM SSB */

TITLE1 'OUTCOMES = SUGAR SWEETENEND BEVERAGE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED ENERGY FROM SSB AMONG CONSUMERS';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07 MISREPORTERS ;
	MODEL SSB_sum_energy = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV MISREPORTERS ;
	MODEL SSB_sum_energy = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC MISREPORTERS ;
	MODEL SSB_sum_energy = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


/********************************************************************************************************************************************************************************************************
OUTCOME: 100% JUICE
*********************************************************************************************************************************************************************************************************/

/* UNTRANSFORMED ENERGY FROM JUICE */

TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED ENERGY FROM JUICE AMONG CONSUMERS';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07 MISREPORTERS ;
	MODEL FREESUG_SUM_ENERGY = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV MISREPORTERS ;
	MODEL FREESUG_SUM_ENERGY = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC MISREPORTERS ;
	MODEL FREESUG_SUM_ENERGY = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;

/****************
ENERGY AMONG CONSUMERS INTAKE 
******************/
ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\misreport-daily-energy-consumption-sep-PUMF.rtf'; 

/************************
DAILY ENERGY INTAKE AMONG CONSUMERS
******************************/
/* UNTRANSFORMED DAILY ENERGY AMONG CONSUMERS */
TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED DAILY TOTAL ENERGY AMONG SCB CONSUMERS';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07 MISREPORTERS ;
	MODEL FID_EKC_SUM = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV MISREPORTERS ;
	MODEL FID_EKC_SUM = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC MISREPORTERS ;
	MODEL FID_EKC_SUM = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;



/* UNTRANSFORMED DAILY ENERGY AMONG CONSUMERS */
TITLE1 'OUTCOMES = SUGAR SWEETENEND BEVERAGE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED DAILY TOTAL ENERGY AMONG SSB CONSUMERS';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07 MISREPORTERS ;
	MODEL FID_EKC_SUM = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV MISREPORTERS ;
	MODEL FID_EKC_SUM = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC MISREPORTERS ;
	MODEL FID_EKC_SUM = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

/* UNTRANSFORMED DAILY ENERGY AMONG CONSUMERS */
TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT ';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED DAILY TOTAL ENERGY AMONG SSB CONSUMERS';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07 MISREPORTERS ;
	MODEL FID_EKC_SUM = EDUGH07  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV MISREPORTERS ;
	MODEL FID_EKC_SUM = FOODSEC_2LEV  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC MISREPORTERS ;
	MODEL FID_EKC_SUM = H_INC  MISREPORTERS / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;

/*********************************************
ODDS RATIO OF CONSUMING SD, SSB, JUICE 
**********************************************/

ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\misreport-odds-ratio-consumption-sep.rtf'; 

TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT';
TITLE2 'OUTCOME 4 - ODDS OF SUGARY DRINK CONSUMPTION';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES EDUGH07 MISREPORTERS/ param=glm ref = last ;  ;
	MODEL SCBYES (desc) = EDUGH07  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES FOODSEC_2LEV MISREPORTERS/ param=glm ref = last ;  ;
	MODEL SCBYES (desc) = FOODSEC_2LEV  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES H_INC MISREPORTERS/ param=glm ref = last ;  ;
	MODEL SCBYES (desc) = H_INC  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE1 'OUTCOMES = SUGAR SWEETENED BEVERAGE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT';
TITLE2 'OUTCOME 4 - ODDS OF SUGAR SWEETENED BEVERAGE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES EDUGH07 MISREPORTERS/ param=glm ref = last ;  ;
	MODEL SSBYES (desc) = EDUGH07  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES FOODSEC_2LEV MISREPORTERS/ param=glm ref = last ;  ;
	MODEL SSBYES (desc) = FOODSEC_2LEV  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES H_INC MISREPORTERS/ param=glm ref = last ;  ;
	MODEL SSBYES (desc) = H_INC  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;



TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION 
STRAT BY AGE SEX, COVAR MISREPORT';
TITLE2 'OUTCOME 4 - ODDS OF 100% JUICE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES EDUGH07 MISREPORTERS/ param=glm ref = last ;  ;
	MODEL JUICEYES (desc) = EDUGH07  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES FOODSEC_2LEV MISREPORTERS/ param=glm ref = last ;  ;
	MODEL JUICEYES (desc) = FOODSEC_2LEV  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES H_INC MISREPORTERS/ param=glm ref = last ;  ;
	MODEL JUICEYES (desc) = H_INC  MISREPORTERS / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;