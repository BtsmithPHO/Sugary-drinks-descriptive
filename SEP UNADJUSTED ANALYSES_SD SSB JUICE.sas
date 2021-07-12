/* MAY 14 2020
UNADJUSTED REGRESSIONS FOR SUGAR SUGARY DRINKS (SCB)
FOR EACH SEP INDICATOR INCOME, EDUC, FOOD SEC
STRATIFIED BY SEX/AGE
ADJUSTED FOR AGE  WEEKEND/WEEKDAY
*/

libname baseline '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Analysis\cchsn_output_datasets\baseline_analysis';run; *to put 'permanent' datasets to work off of in different programs;

DATA FINAL1; 
	SET baseline.baseline_1day;
	if 2 <= dhh_age <= 18 then AGE_GROUP="KIDS";
	if dhh_age>=19 then AGE_GROUP="ADULTS";
RUN;


/****************
PREVALENCE OF INTAKE 
******************/
ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\unadj-prevalence-consumption-sep-PUMF.rtf'; 

/***************************************************************************************************************************************************************************************************
OUTCOME: SUGARY DRINKS
***************************************************************************************************************************************************************************************************/

/* 1 PREVALENCE */
TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR ';
TITLE2 'OUTCOME 1 - PREVALENCE OF SUGARY DRINK CONSUMPTION';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES EDUGH07  ;
	MODEL SCBYES = EDUGH07 / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES FOODSEC_2LEV  ;
	MODEL SCBYES = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES H_INC  ;
	MODEL SCBYES = H_INC   / solution anova clparm;
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
STRAT BY AGE SEX, UNADJ FOR COVAR ';
TITLE2 'OUTCOME 1 - PREVALENCE OF SUGAR SWEETENED BEVERAGE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES EDUGH07  ;
	MODEL SSBYES = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES FOODSEC_2LEV  ;
	MODEL SSBYES = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES H_INC  ;
	MODEL SSBYES = H_INC   / solution anova clparm;
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
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 1 - PREVALENCE OF 100% JUICE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES EDUGH07  ;
	MODEL JUICEYES = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES FOODSEC_2LEV  ;
	MODEL JUICEYES = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES H_INC  ;
	MODEL JUICEYES = H_INC   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;

/****************
ENERGY AMONG CONSUMERS INTAKE 
******************/
ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\unadj-energy-consumption-sep-PUMF.rtf'; 

/* UNTRANSFORMED ENERGY FROM SCB */

TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED ENERGY FROM SCB AMONG CONSUMERS';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07  ;
	MODEL SCB_sum_energy = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV  ;
	MODEL SCB_sum_energy = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC  ;
	MODEL SCB_sum_energy = H_INC   / solution anova clparm;
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
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED ENERGY FROM SSB AMONG CONSUMERS';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07  ;
	MODEL SSB_sum_energy = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV  ;
	MODEL SSB_sum_energy = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC  ;
	MODEL SSB_sum_energy = H_INC   / solution anova clparm;
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
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED ENERGY FROM JUICE AMONG CONSUMERS';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07  ;
	MODEL FREESUG_SUM_ENERGY = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV  ;
	MODEL FREESUG_SUM_ENERGY = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC  ;
	MODEL FREESUG_SUM_ENERGY = H_INC   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;

/****************
ENERGY AMONG CONSUMERS INTAKE 
******************/
ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\unadj-daily-energy-consumption-sep-PUMF.rtf'; 

/************************
DAILY ENERGY INTAKE AMONG CONSUMERS
******************************/
/* UNTRANSFORMED DAILY ENERGY AMONG CONSUMERS */
TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED DAILY TOTAL ENERGY AMONG SCB CONSUMERS';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07  ;
	MODEL FID_EKC_SUM = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV  ;
	MODEL FID_EKC_SUM = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC  ;
	MODEL FID_EKC_SUM = H_INC   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;



/* UNTRANSFORMED DAILY ENERGY AMONG CONSUMERS */
TITLE1 'OUTCOMES = SUGAR SWEETENEND BEVERAGE CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED DAILY TOTAL ENERGY AMONG SSB CONSUMERS';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07  ;
	MODEL FID_EKC_SUM = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV  ;
	MODEL FID_EKC_SUM = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC  ;
	MODEL FID_EKC_SUM = H_INC   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

/* UNTRANSFORMED DAILY ENERGY AMONG CONSUMERS */
TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 2 - MEAN UNTRANSFORMED DAILY TOTAL ENERGY AMONG SSB CONSUMERS';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS EDUGH07  ;
	MODEL FID_EKC_SUM = EDUGH07   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans EDUGH07 / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS FOODSEC_2LEV  ;
	MODEL FID_EKC_SUM = FOODSEC_2LEV   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans FOODSEC_2LEV / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS H_INC  ;
	MODEL FID_EKC_SUM = H_INC   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans H_INC / means cl diff;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;

/*********************************************
ODDS RATIO OF CONSUMING SD, SSB, JUICE 
**********************************************/

ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\unadj-odds-ratio-consumption-sep.rtf'; 

TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 4 - ODDS OF SUGARY DRINK CONSUMPTION';

TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES EDUGH07 / param=glm ref = last ;  ;
	MODEL SCBYES (desc) = EDUGH07   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES FOODSEC_2LEV / param=glm ref = last ;  ;
	MODEL SCBYES (desc) = FOODSEC_2LEV   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SCBYES H_INC / param=glm ref = last ;  ;
	MODEL SCBYES (desc) = H_INC   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE1 'OUTCOMES = SUGAR SWEETENED BEVERAGE CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 4 - ODDS OF SUGAR SWEETENED BEVERAGE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES EDUGH07 / param=glm ref = last ;  ;
	MODEL SSBYES (desc) = EDUGH07   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES FOODSEC_2LEV / param=glm ref = last ;  ;
	MODEL SSBYES (desc) = FOODSEC_2LEV   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS SSBYES H_INC / param=glm ref = last ;  ;
	MODEL SSBYES (desc) = H_INC   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;



TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION 
STRAT BY AGE SEX, UNADJ FOR COVAR';
TITLE2 'OUTCOME 4 - ODDS OF 100% JUICE CONSUMPTION';


TITLE3 'PREDICTOR: EDUCATION';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES EDUGH07 / param=glm ref = last ;  ;
	MODEL JUICEYES (desc) = EDUGH07   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: FOOD SECURITY';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES FOODSEC_2LEV / param=glm ref = last ;  ;
	MODEL JUICEYES (desc) = FOODSEC_2LEV   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE3 'PREDICTOR: INCOME';
TITLE4 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYLOGISTIC DATA= FINAL1 VARMETHOD=BRR;
	CLASS JUICEYES H_INC / param=glm ref = last ;  ;
	MODEL JUICEYES (desc) = H_INC   / CLODDS clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	weight wts_p;
	repweights bsw1-bsw500;
run;

ods rtf close;