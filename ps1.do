
* Data Management Project
*Shibin Yan, Fall 2019
*Revised: spring 2019 September 15
*----------------------------


//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
use "https://docs.google.com/uc?id=1Sb_fGGdRiVSxFpcfHbp7RaV2QauGxi_q&export=download",clear
/* 
These data are from Chinese Longitudinal Healthy Longevity Survey (CLHLS).It provides information 
on health status and quality of life of the elderly aged 65 and older in 22 provinces of China 
in the period 1998 to 2014. In this study, I just use the 2014 data. Moreover, the study was conducted to shed light 
on the determinants of healthy human longevity and oldest-old mortality. To this end, data were collected on a large percent of
the oldest population, including centenarian and nonagenarian; the CLHLS provides information 
on the health, socioeconomic characteristics, family, lifestyle, and demographic profile of this aged population.  
*/

* some variable name will get people confused. It would be better to rename these variables.
rename TRUEAGE age14
rename RESIDENC rural14
rename A1 sex14
rename A2 ethnic14


sum age14
/*
age is a key variable in this study. For age, there are 7,192 observations in the dataset. The mean of age is 85.32 and
the standard deviation is 10.77. We can know the age variables from these numbers!
*/

hist age14
* use graph to know the key variable--age visually. Age is right skewed.

tab rural14, sum (age14)
/* 
In this table, it is obvious that more elderly people tend to live in rural area and
town area. There are 3980 elderly living in the rural area. 
*/

* find the correlation between ethnicity and age. 
reg age14 ethnic14 sex14
/*
I try to find the correlation among ethnicity, gender and elderly's age, in order to
know how ethnicity and gender impact on elderly's age. On the ethnicity variable, 
the 95% confidence interval is [-0.3217541,0.0638592]. One unite increase in ethnicity level 
leads to a increase of -.013 point in age, controlling for gender of elderly. It is not significant.
Also, one unite increase in the gender of the elderly leads to a increase of 4.50 point in 
age, controlling for the ethnicity of the elderly. It is statistically significant!
*/



