
* Data Management Project- Probelm Set 4
*Shibin Yan, Fall 2019
*Revised: spring 2019 Oct.24
*----------------------------

//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------

/*****************/
/* Introduction */
/*****************/

/* Data Description 
Data came from the Chinese Longitudinal Healthy Longevity Survey (CLHLS), released by 
the National Archive of Computerized Data on Aging in 2017. The CLHLS surveys 
include seven waves of data which are released in 1998, 2000, 2002, 2005, 2008, 2010 
and 2014 respectively. The CLHLS provides information on health status and quality of 
life of the elderly aged 65 and older in China,included socioeconomic characteristics, 
family, lifestyle, and demographic profile of this aged population. A national representative 
sample of people aged 65 or older was drawn. The dataset covers 23 out of 31 provinces in China, 
including five minority autonomous regions. These minority autonomous regions that have
 a much higher proportion of minority group concentration are Guangxi, Inner Mongolia,
 Ningxia, Xinjiang, and Tibet. In this study, the data from the 2014 wave of the CLHLS
 surveys will be utilized because it is easy to observe the effect of the health disparity
 on the older population in one dataset. The study sample consists of 7,192 older adults
 aged 65 and over; 7% (n=495) of them are ethnic minorities. In addition, it comprises
 3,212 urban elderly which accounting for 44.6% of the sample and 3,980 rural elderly.
 The response rate was 97.7 percent.   
*/

/* Research Goal
This research is about health disparity for Chinese elderly. This research aims to 
find out how geographic and ethnicity of residents affect collectively on health quality of old 
people in China. In other words, this study will assess the impact of geographic 
and ethnicity disparity on the health outcome of the Chinese elderly.
*/

/* Research Question
1. Does the majority elderly have a better health status than their minority counterpart, as the literature showed? 
2. Does the elderly living in urban area live longer than their counterpart in rural area?
*/

/* Hypothesis 
Hypothesis 1: The Han (majority) elderly living in an urban area have a better health status than those in a rural area. 
Hypothesis 2: The Han (majority) elderly living in an urban area have a better health status than the minorities in an urban area. 
Hypothesis 3: The Han (majority) elderly living in a rural area have a better health status than the minorities in an urban area.
Hypothesis 4: The minorities elderly living in an urban area have a better health status than those in a rural area.
*/

/* Variables 

Independent Variables: age,education, income and employment status. 
Dependent Variables:self-rated health status,functional capacity.
Control Variables:gender, marital status, family size.
*/
//very nice! good job!


/********************/
/* Manipulating data*/
/********************/

//make the data use easier
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
* some variable name get people confused. It would be better to rename these variables.
rename TRUEAGE age14
rename RESIDENC rural14
rename A1 sex14
rename A2 ethnic14
rename B27 happiness14
rename F41 marital14
rename A41 born14
rename B12 health14
rename F35 income14
rename F23 employment14
 
/* the key variables for this study is age, residence location, ethinicty, marital status, 
health status.  */
* recode the rural variable
recode rural14 (3=0) (1 2=1) (-99=.)
la de rurallab 0 "Rural" 1 "Urban"
la val rural14 rurallab
label list rurallab
* recode the ethnicity variable
recode ethnic14  (1=0) (2 3 4 5 6 7 8=1),gen(major14) 
la de ethniclab 0 "majority" 1 "minority"
la val major14 ethniclab
label list ethniclab
recode marital14 (2 3 4 5=0) (1=1), gen(spouse14)
la de maritallab 0 "single" 1 "spouse"  // Problem. Fix it later! 
la val spouse14 maritallab
save eld1.dta, replace
//may want to save this! you do all this work and then it gets lost: when you do graphs and visuzalizations later, 
//its much better to start with clean labelled data than just run everything from scratch again 

* the second data set--the using dataset which are used to merge.
use "https://docs.google.com/uc?id=1_exDjt1Rbc1B18wX0oMgyRZeWpm04uKH&export=download",clear
rename TRUEAGE age12
rename RESIDENC rural12
rename A1 sex12
rename A2 ethnic12
rename B27 happiness12
rename F41 marital12
rename A41 born12
rename F35 income
rename  A53A4_14 education

local c age12 rural12 sex12 ethnic12 happiness12 marital12 born12 PROV income education
display "`c'"
keep ID 'c'

save eld2.dta, replace


/*by: egen*/
use eld1.dta, clear
bys rural14: egen medage=median(age14)
* creat the median age variable, so we can know the median age in different areas.
la var medage "median elderly age"
ta medage rural14

bys marital14: egen maxage14=max (age14)
la var maxage "maximums marital elderly age"
/* creat the maximum marital elderly age. By doing this, we can know the largest age of
elder people in different marital status groups. The result shows that 62 widowed elderly's
age is 108, which count as the maximum age in their group. */
ta maxage14 marital14

bys ethnic14: egen meanage14=mean(age14)
/* we would liek to know the mean of elderly age from different ethnicity groups. So we creat
the meanage14 variable. The result shows that 97 Han majority people live as long as 89 years.
 */
la var meanage "mean elderly age"
tab meanage14 ethnic14

/*****************/
/* Merging data*/
/*****************/

/*merge1*/ 
sort ID
merge 1:1 ID using eld2.dta
* the result shows that 53 data are successful merged.
save merge1.dta,replace
/*reshpe1*/
reshape long rural age, i(ID) j(year)
/* by reshaping the rural variable, we can see the change on the place of the elderly. It is
significant to observe the change of living places of the elderly. We would like to test the hypothesis
that elderly living in the city area will have a better life expectancy or health resources than their
counterpart in the rural area. These are several observations of data we found can support the hypothesis. The reshape
can help us easier to compare the data, especially a large dataset. */


/*merge2*/
use eld2.dta,clear
drop  age12 rural12 sex12 ethnic12 happiness12 marital12 born12 
merge 1:1 ID using eld1.dta, nogen
save merge2.dta,replace

/*merge3*/
use "https://docs.google.com/uc?id=1r0brtgXRy0r39L6p1TOUimh8ULZGJIb2&export=download",clear
recode PBIRTH (5=0) (1 2 3 4=1) (-99=.)
label define rural 0 Urban 1 Rural
label list rural
merge 1:1 ID using merge2.dta, nogen
save merge3.dta,replace


/*merge4*/
use "https://docs.google.com/uc?id=1T87WO8AvWbsfkekR3H0NIeQRhmzHN3aG&export=download",clear
rename S104 marital
save data1,replace
use merge1.dta, clear
*reshape long marital, i(ID) j(year)
merge 1:1 ID using merge1.dta, nogen
save merge4.dta,replace

/*merge5*/
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
decode PROV, gen(PROV1)
replace PROV1 = proper(PROV1)
save merge5,replace
import excel "https://docs.google.com/uc?id=1X9vOTsmzC43fwj-IoRzHVFy6FWkKx-WA&export=download", sheet("Sheet1") firstrow clear
keep in 1/31
save prov1,replace
use merge5
merge m:1 PROV1 using prov1, nogen 
* Data from China Census 2010.

*----------------------------PS3 Redo
/*merge6*/
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
decode PROV, g(PROV1)
replace PROV1 = proper(PROV1)
drop PROV
ren PROV1 PROV
save merge6, replace
import excel "https://docs.google.com/uc?id=14owWYRQ4O8GYwoN8VWVsyUyY1ke9KlwF&export=download", sheet("Sheet1") firstrow clear
keep in 1/31
save prov10,replace
merge 1:m PROV using merge6 //, nogen 
sort _merge
list PROV if _merge==1
list PROV if _merge==2
list PROV RESIDENC V_BTHMON if _merge==1 | _merge==2
/*
the reason for the non-merge is because there is different way to spell the name of
 province name between the master dataset and using dataset, such as Shannxi and 
 Shaanxi.
 
 yes! but its easy to fix, just replace it with what it is in the other dataset before merging!
and there seems to be one more H something; and better to tab than list:
. ta PROV if _merge==1

          PROV |      Freq.     Percent        Cum.
---------------+-----------------------------------
         Gansu |          1       10.00       10.00
       Guizhou |          1       10.00       20.00
  Heilongjiang |          1       10.00       30.00
Inner Mongolia |          1       10.00       40.00
       Ningxia |          1       10.00       50.00
       Qinghai |          1       10.00       60.00
       Shannxi |          1       10.00       70.00
         Tibet |          1       10.00       80.00
      Xinjiang |          1       10.00       90.00
        Yunnan |          1       10.00      100.00
---------------+-----------------------------------
         Total |         10      100.00

. ta PROV if _merge==2

          PROV |      Freq.     Percent        Cum.
---------------+-----------------------------------
   Helongjiang |         79       50.32       50.32
       Shaanxi |         78       49.68      100.00
---------------+-----------------------------------
         Total |        157      100.00


 
*/
* Data from China Statistical Yearbook 2018 http://www.stats.gov.cn/tjsj/ndsj/2018/indexeh.htm.

//and then need to save AND merge with everything else! that's the goal of all of this--not just to merge for the sake of exercise
//but to merge so that we build a new big dataset that has everything in it!

/*merge7*/
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
rename RESIDENC rural
rename A43 Rural
recode rural (3=0) (1 2=1) (-99=.)
la de rurallab 0 "Rural" 1 "Urban"
la val rural rurallab
label list rurallab
save merge10,replace
use "https://docs.google.com/uc?id=1jrGlyM9tmOy9OtILTxuLnJhJuqgPdTvC&export=download",clear
rename Q0104 rural
rename Q0811 educ
recode educ (-8=.)
egen averural=mean(educ), by(rural)
collapse educ, by(rural)
save rural1,replace
use merge10
merge m:1 rural using rural1, nogen 
* Data from WHO Study on Global AGEing and Adult Health 2007-2010 https://www.who.int/healthinfo/sage/en/.


 /*merge8*/
use "https://docs.google.com/uc?id=1WMOXBRM8910rlTr3VV3uFCXPtuT5LRmC&export=download",clear
keep if COUNTRY==1 | COUNTRY==10 | COUNTRY==22
keep COUNTRY RESIDENCE PROVINCE_CHNS AGE INCOME PPP GOODHEALTH BMI
ren PROVINCE_CHNS PROV
decode PROV, gen(PROV1)
replace PROV1 = proper(PROV1)
save merge11,replace
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
collapse (mean) TRUEAGE , by(PROV)
decode PROV, gen(PROV1)
replace PROV1 = proper(PROV1)
merge 1:m PROV1 using merge11 
/* A lot of non-merge happen in the using dataset because there are a lot of missing value of PROV1 variable in 
the using dataset. Data from Research on Early Life and Aging Trends and Effects: A Cross-National Study 1996-2008 
https://www.icpsr.umich.edu/icpsrweb/DSDR/studies/34241.*/


/*****************/
/* Visualizing data*/
/*****************/

tab ethnic14
* Start to visualize the data 
*Basic descriptive statistic 
sum age14
hist age14, frequency normal
histogram health14, discrete freq addlabels xlabel(0 1(1)9,valuelabel)
histogram ethnic14, discrete freq addlabels xlabel(0 1,valuelabel)
histogram rural14, discrete freq addlabels xlabel(0 1, valuelabel)

*Group Statistic 
tab rural14, sum (age14)
histogram age14, frequency by(rural14)
hist health14, frequency by(rural14)
tab rural14, sum (health14)
tab health14, sum (rural14)
histogram health14 , normal
hist age14,normal
twoway histogram health14 , discrete freq by(rural14)
twoway histogram age14 , discrete freq by(rural14)
twoway histogram age14 , discrete freq by(ethnic14)
histogram age14, discrete freq by( ethnic14 , total)

reg age14 ethnic14 rural14
scatter age14 ethnic14 || lfit age14 ethnic14


tabstat health14 , by( ethnic14 ) stat(mean sd min max) nototal long format
tabstat age14 , by( rural14 ) stat(mean sd min max) nototal long format
graph bar health14, over(PROV) bargap(50)

symplot age14
graph matrix health14 age14, by(ethnic14, total)

qnorm age14, grid

tab A2 , sum ( TRUEAGE )



