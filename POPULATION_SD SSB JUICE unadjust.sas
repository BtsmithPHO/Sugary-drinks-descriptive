/* unajusted population analysis for sd descriptive - May 2021 */


libname baseline '\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Analysis\cchsn_output_datasets\baseline_analysis';run; *to put 'permanent' datasets to work off of in different programs;

DATA FINAL1; 
	SET baseline.baseline_1day;
	if 2 <= dhh_age <= 18 then AGE_GROUP="KIDS";
	if dhh_age>=19 then AGE_GROUP="ADULTS";
RUN;


ods rtf file='\\OTO101PFILE01V.oahpp.ca\Christine.Warren$\Research Projects\Nutrition_CVD_SugaryDrinks\Descriptive Paper_1\Results\unadj-outcomes-population-PUMF.rtf'; 

TITLE1 'OUTCOMES = SUGARY DRINK CONSUMPTION
PREDICTOR = SUBGROUPS (M/F 2-18 19+ YEARS)';

TITLE2 'OUTCOME - PREVALENCE OF SCB INTAKE';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL SCBYES = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE1 'OUTCOMES = SUGAR SWEETENED BEVERAGE CONSUMPTION
PREDICTOR = SUBGROUPS (M/F 2-18 19+ YEARS)';

TITLE2 'OUTCOME - PREVALENCE OF SSB INTAKE';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL SSBYES = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE1 'OUTCOMES = 100% JUICE CONSUMPTION
PREDICTOR = SUBGROUPS (M/F 2-18 19+ YEARS)';

TITLE2 'OUTCOME - PREVALENCE OF JUICE INTAKE';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL JUICEYES = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;




TITLE2 'OUTCOME - UNTRANSFORMED ENERGY INTAKE FROM SCB AMONG CONSUMERS';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL SCB_SUM_ENERGY = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE2 'OUTCOME - UNTRANSFORMED ENERGY INTAKE FROM SSB AMONG CONSUMERS';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL SSB_SUM_ENERGY = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE2 'OUTCOME - UNTRANSFORMED ENERGY INTAKE FROM JUICE AMONG CONSUMERS';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL FREESUG_SUM_ENERGY = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;


TITLE2 'OUTCOME - UNTRANSFORMED DAILY ENERGY INTAKE AMONG SCB CONSUMERS';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL FID_EKC_SUM = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SCBYES;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE2 'OUTCOME - UNTRANSFORMED DAILY ENERGY INTAKE AMONG SSB CONSUMERS';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL FID_EKC_SUM = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*SSBYES;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;

TITLE2 'OUTCOME - UNTRANSFORMED DAILY ENERGY INTAKE AMONG JUICE CONSUMERS';
TITLE3 'DOMAIN = AGE_GROUP*DHH_SEX';
PROC SURVEYREG DATA=FINAL1 VARMETHOD=BRR;
	CLASS AGE_GROUP   ;
	MODEL FID_EKC_SUM = AGE_GROUP   / solution anova clparm;
	DOMAIN AGE_GROUP*DHH_SEX*JUICEYES;
	lsmeans AGE_GROUP / means cl;
	weight wts_p;
	repweights bsw1-bsw500;
run;


