************************************;
* creates regression 2 in Table 3;
* includes Charlies's seasonal adjustment
* and event windows;
************************************;
option ls=120;
Libname Convey 'C:\';
PROC IMPORT OUT= one 
            DATAFILE= "C:\CalomirisPritchett_data.xlsx" 
            DBMS=EXCEL REPLACE;    
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


data two;  set one;


no_sale_date=input(sales_date,mmddyy10.);

if no_sale_date=. then delete;
* dumps missing values for sale date;

if no_sale_date<mdy(10,1,1856) then delete;
if no_sale_date>MDY(8,31,1861) then delete;
* sample period;


Nage_child_1=age_child_1+0;
Nage_child_2=age_child_2+0;
Nage_child_3=age_child_3+0;
Nage_child_4=age_child_4+0;
Nage_child_5=age_child_5+0;
Nage_child_6=age_child_6+0;
Nage_child_7=age_child_7+0;
Nage_child_8=age_child_8+0;

proc sort; by Sellers_Last_Name Sellers_First_Name;

data k1; set two;
if nage_child_1>0;
age=nage_child_1;
slave_name=name_child_1;
sex=sex_child_1;
data k2; set two;
if nage_child_2>0;
age=nage_child_2;
slave_name=name_child_2;
sex=sex_child_2;
data k3; set two;
if nage_child_3>0;
age=nage_child_3;
slave_name=name_child_3;
sex=sex_child_3;
data k4; set two;
if nage_child_4>0;
age=nage_child_4;
slave_name=name_child_4;
sex=sex_child_4;
data k5; set two;
if nage_child_5>0;
age=nage_child_5;
slave_name=name_child_5;
sex=sex_child_5;
data k6; set two;
if nage_child_6>0;
age=nage_child_6;
slave_name=name_child_6;
sex=sex_child_6;
data k7; set two;
if nage_child_7>0;
age=nage_child_7;
slave_name=name_child_7;
sex=sex_child_7;
data k8; set two;
if nage_child_8>0;
age=nage_child_8;
slave_name=name_child_8;
sex=sex_child_8;
data combo; set two k1 k2 k3 k4 k5 k6 k7 k8;


proc freq noprint;
 tables Sellers_Last_Name*Sellers_First_Name / list out=sellers;
  format Sellers_Last_Name $20. Sellers_First_Name $20.;

  run;

data three; merge two sellers; by Sellers_Last_Name Sellers_First_Name;
 


sale_year=year(no_sale_date);
sale_month=month(no_sale_date);
Month_Year=mdy(sale_month,15,sale_year);



barter=0;
if payment_method='Barter' then barter=1;
if payment_method='Barter, Cash' then barter=1;
if payment_method='Barter, Credit' then barter=1;
if payment_method='Donation' then barter=1;
if payment_method='Exchange' then barter=1;
if payment_method='Exchange, Cash' then barter=1;
if payment_method='Exchange, Credit' then barter=1;
* not market prices;



notsale=0;
if reason_for_omission='OMIT: Abrogation of sale' then notsale=1;
if reason_for_omission='OMIT: Group sale, and not even a real sale yet. This is a promise to sell slaves' then notsale=1;
if reason_for_omission='OMIT: Group sale. Abrogation of sale' then notsale=1;
if reason_for_omission='OMIT: Not a transaction' then notsale=1;
if reason_for_omission='OMIT: Not a transaction. Sale is to lease a slave temporarily' then notsale=1;
if reason_for_omission='OMIT: Not a transaction. Transfer between family members' then notsale=1;
if reason_for_omission='OMIT: Old sale' then notsale=1;

if reason_for_omission='OMIT: Not a transaction. Emancipation' then notsale=1;
* slave sold for $1;
*if reason_for_omission='OMIT: Not a market price. Condition of emancipation' then notsale=1;
* self purchase of slave for $500;

missingprice=0;

if reason_for_omission='OMIT: Missing info: price' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price, payment details' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Not a transaction. Emancipation' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Price includes property' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Price includes property and shares of stock' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Retrocession' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Sale between family members' then missingprice=1;
if reason_for_omission='OMIT: No price variation' then missingprice=1;
if reason_for_omission='OMIT: No price variation. Prices = a total divided by the number of slaves being sold.' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Missing info: price' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Missing info: price. Donation' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Missing info: price. Price includes property' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Missing info: price. Price includes property. Retrocession' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Missing info: price. Price includes property. Right of redemption' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Not a market price' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Condition of emancipation' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Emancipation' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Price includes property' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Retrocession' then missingprice=1;
if reason_for_omission='OMIT: Group sale. Price includes property' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price, payment details' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Not a transaction. Emancipation' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Price includes property' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Price includes property and shares of stock' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Retrocession' then missingprice=1;
if reason_for_omission='OMIT: Missing info: price. Sale between family members' then missingprice=1;
if reason_for_omission='OMIT: No price variation' then missingprice=1;
if reason_for_omission='OMIT: No price variation. Prices = a total divided by the number of slaves being sold.' then missingprice=1;
if reason_for_omission='OMIT: No price variation. Sale between family members.' then missingprice=1;
if reason_for_omission='OMIT: Not a market price. Price includes moveable property' then missingprice=1;
if reason_for_omission='OMIT: Not a market price. Price includes property' then missingprice=1;
if reason_for_omission="OMIT: Not a market price. Price includes property. Not an arm's length transaction. Group sale" then missingprice=1;
if reason_for_omission='OMIT: Not a transaction. Emancipation. Missing info: price' then missingprice=1;
if reason_for_omission='OMIT: Price includes property' then missingprice=1;
if reason_for_omission='OMIT: Zero price variance' then missingprice=1;
if reason_for_omission='OMIT: Zero price variance.' then missingprice=1;
if reason_for_omission='OMIT: Zero price variation.' then missingprice=1;
if reason_for_omission='OMIT:Payment info includes property' then missingprice=1;


partial=0;
if reason_for_omission="OMIT: Not a market price. Sale is for 7 parts of slave. It doesn't say out of how many" then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 1/2 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 1/2 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 1/2 interest in slaves. Group sale' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 1/3 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 1/6 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 11/12 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 2/15 interest in slave. Price includes property' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 2/3 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 3/4 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 5/8 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 5/8 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 6/7 interest in slave' then partial=1;
if reason_for_omission='OMIT: Not a market price. Sale is for 6/8 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Sale is for 1/2 interest in slave' then partial=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Sale is for 1/2 interest in slaves. Sale between Family members' then partial=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Sale is for 2/3 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Group sale. Not a market price. Sale is for 3/4 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Group sale. Sale is for 1/2 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Group sale. Sale is for 1/4 interest in slaves' then partial=1;
if reason_for_omission='OMIT: Missing info: price. Sale is for 1/2 interest in slave' then partial=1;

missingcredit=0;
if reason_for_omission='OMIT:  Credit info inconsistent with price' then missingcredit=1;
if reason_for_omission='OMIT:  Credit payments do not sum to prices' then missingcredit=1;
if reason_for_omission='OMIT:  Missing Info:  interest rate and/or months of credit' then missingcredit=1;
if reason_for_omission='OMIT: Cannot determine Discounted Present Value from payment information' then missingcredit=1;
if reason_for_omission='OMIT: Group sale. Missing info: payment details' then missingcredit=1;
if reason_for_omission='OMIT: Group sale. Missing info: payment details. Retrocession' then missingcredit=1;
if reason_for_omission='OMIT: Incorrect info: payment details' then missingcredit=1;
if reason_for_omission='OMIT: Missing info:  length of credit' then missingcredit=1;
if reason_for_omission='OMIT: Missing info:  length of credit and/or interest rate' then missingcredit=1;
if reason_for_omission='OMIT: Missing info:  months of credit and/or interest rate' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details. Payment method includes property' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details. Price includes property' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details. Retrocession' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details. Sale includes property' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details. Sale is for 5/19 interest in slave' then missingcredit=1;
if reason_for_omission='OMIT: Missing info: payment details. Slaves sold with property' then missingcredit=1;
if reason_for_omission='OMIT: Payment information does not match price.' then missingcredit=1;
if reason_for_omission="OMIT: Payment information doesn't match price info" then missingcredit=1;


notarmslength=0;
if reason_for_omission="OMIT: Group donation. Not an arm's length transaction. Donation among family members including property" then notarmslength=1;
if reason_for_omission='OMIT: Not a transaction. Transfer between family members' then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Buyer has a relationship to representing seller" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Buyer is son of deceased seller. Does not seem like a market price" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Donation between family members" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Exchange between husband and wife" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Sale between a husband and wife" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Sale between family members" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Sale between family members. Not a market price" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Succession involving family members" then notarmslength=1;
if reason_for_omission='OMIT: Sale between husband and wife' then notarmslength=1;
if reason_for_omission="OMIT: Group sale. Not an arm's length transaction. Donation between family members" then notarmslength=1;
if reason_for_omission="OMIT: Group sale. Not an arm's length transaction. Sale between family members" then notarmslength=1;
if reason_for_omission="OMIT: Group sale. Not an arm's length transaction. Sale between family members. Missing payment details" then notarmslength=1;
if reason_for_omission="OMIT: Group sale. Not an arm's length transaction. Sale between family members. Sale includes property" then notarmslength=1;
if reason_for_omission="OMIT: Group sale. Not an arm's length transaction. Sale between family members. Sale is for 1/2 interest in slave" then notarmslength=1;
if reason_for_omission="OMIT: Group sale. Not an arm's length transaction. Sale between family members. price. Sale is for 5/6 interest in slave" then notarmslength=1;
if reason_for_omission='OMIT: Group sale. Potentially a sale between family members' then notarmslength=1;
if reason_for_omission="OMIT: Not a market price. Not an arm's length transaction. Sale between family members. Sale for 1/2 interest in slaves" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Buyer has a relationship to representing seller" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Buyer is son of deceased seller. Does not seem like a market price" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Donation between family members" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Exchange between husband and wife" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Sale between a husband and wife" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Sale between family members" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Sale between family members. Not a market price" then notarmslength=1;
if reason_for_omission="OMIT: Not an arm's length transaction. Succession involving family members" then notarmslength=1;
if reason_for_omission='OMIT: Sale between husband and wife' then notarmslength=1;


missingage=0;
if reason_for_omission='OMIT: Group sale. Missing ages.' then missingage=1;
if reason_for_omission='OMIT: Group sale. Missing info: age' then missingage=1;
if reason_for_omission='OMIT: Group sale. Missing info: age. Not a market price. Sale is for 1/2 interest in slaves' then missingage=1;
if reason_for_omission='OMIT: Group sale. Missing info: age. Price may include property' then missingage=1;
if reason_for_omission='OMIT: Missing info:  age' then missingage=1;
if reason_for_omission='OMIT: Missing info: age' then missingage=1;
if reason_for_omission='OMIT: Missing info: age child' then missingage=1;
if reason_for_omission='OMIT: Missing info: age of child' then missingage=1;
if reason_for_omission='OMIT: Missing info: age, price' then missingage=1;
if reason_for_omission='OMIT: Missing info: age, race' then missingage=1;
if reason_for_omission='OMIT: Missing info: age. Condition of emancipation' then missingage=1;
if reason_for_omission='OMIT: Missing info: age. Group sale' then missingage=1;
if reason_for_omission='OMIT: Missing info: name, gender, age, race' then missingage=1;
if reason_for_omission='OMIT: Missing info: name, gender, age, race child' then missingage=1;
if reason_for_omission='OMIT: Missing info: race mom and name, gender, age, race child' then missingage=1;
if reason_for_omission='OMIT: Not a transaction. Missing info: age, price' then missingage=1;
if age<=0 then missingage=1;
if reason_for_omission='OMIT: Missing info: name, gender, race' then missingage=1;
if Sex='.' then missingage=1;
if Sex='' then missingage=1;

oldchild=0;
if 9.9 < age_child_1 then oldchild=1;
if 9.9 < age_child_2 then oldchild=1;
if 9.9 < age_child_3 then oldchild=1;
if 9.9 < age_child_4 then oldchild=1;
if 9.9 < age_child_5 then oldchild=1;
if 9.9 < age_child_6 then oldchild=1;
if 9.9 < age_child_7 then oldchild=1;
if 9.9 < age_child_8 then oldchild=1;
if reason_for_omission='OMIT: Child is too old' then oldchild=1;
* deletes mothers with older children attached to record;

redemption=0;
if reason_for_omission='OMIT: Group sale.  Right of redemption' then redemption=1; 
if reason_for_omission='OMIT: Right of redemption' then redemption=1;
if reason_for_omission='OMIT: Group sale. Right of redemption' then redemption=1;

retrocession=0;
if reason_for_omission='OMIT: Group sale. Retrocession' then retrocession=1;
if reason_for_omission='OMIT: Retrocession' then retrocession=1;

missingsex=0;
if reason_for_omission='OMIT: Missing info: name, gender, race' then missingsex=1;
if Sex='.' then missingsex=1;
if Sex='' then missingsex=1;

if reason_for_omission='OMIT: Missing info: date' then Dummy_omission=0;
* corrected observation;
if reason_for_omission='OMIT: Missing info: race' then Dummy_omission=0;
* assume missing value for color is black or Negro;

emancipation=0;
if reason_for_omission='OMIT: Condition of emancipation' then emancipation=1;
if reason_for_omission='OMIT: Condition of emancipation. Not a market price' then emancipation=1;
if reason_for_omission='OMIT: Emancipation' then emancipation=1;
if reason_for_omission='OMIT: Not a market price. Condition of emancipation' then emancipation=1;

selfpurchase=0;
if reason_for_omission='OMIT: Condition of emancipation. Self-purchase' then selfpurchase=1;
if reason_for_omission='OMIT: Self-purchase' then selfpurchase=1;
if reason_for_omission='OMIT: Not a market price. Condition of emancipation' then selfpurchase=1;
* self purchase of slave for $500;

groupsale=0;
if reason_for_omission='OMIT: Group sale' then groupsale=1;
if reason_for_omission='OMIT: Group sale. Condition of emancipation' then groupsale=1;
if reason_for_omission='OMIT: Group sale. Missing info: name, race' then groupsale=1;
if reason_for_omission='OMIT: Group sale. Sale is for an entire family' then groupsale=1;
if reason_for_omission='OMIT: Sale is for an entire family' then groupsale=1;
if price<=0 and groupsale=0 then missingprice=1;



if reason_for_omission='OMIT: Missing info: date' then Dummy_omission=0;
* corrected observation;
if reason_for_omission='OMIT: Missing info: race' then Dummy_omission=0;
* assume missing value for color is black or Negro;

outlier=0;
if ID_number=1447 then outlier=1;
if ID_number=3149 then outlier=1;
if ID_number=3339 then outlier=1;
if ID_number=3711 then outlier=1;
if ID_number=4280 then outlier=1;
if ID_number=4918 then outlier=1;
if ID_number=5403 then outlier=1;
if ID_number=7068 then outlier=1;
if ID_number=9786 then outlier=1;
if ID_number=9943 then outlier=1;
if ID_number=10030 then outlier=1;
if ID_number=10050 then outlier=1;
if ID_number=11115 then outlier=1;
if ID_number=12987 then outlier=1;
if ID_number=13488 then outlier=1;
if ID_number=13724 then outlier=1;

* if barter=0;
* if oldchild=0;
dropped=0;
if notsale=1 then dropped=1;
if missingprice=1 then dropped=1;
if partial=1 then dropped=1;
if missingcredit=1 then dropped=1;
if notarmslength=1 then dropped=1;
if missingage=1 then dropped=1;
* if missingsex=1 then dropped=1;
if redemption=1 then dropped=1;
if retrocession=1 then dropped=1;
if oldchild=1 then dropped=1;
* if selfpurchase=0;
* if emancipation=0;
if groupsale=1 then dropped=1;
if barter=1 then dropped=1;
if outlier=1 then dropped=1;

sale_year=year(no_sale_date);
sale_month=month(no_sale_date);
YearMonth=mdy(sale_month,15,sale_year);

* if dropped=0;
* subset to working sample;


****************************;

data barter; set three;
if barter=0;
if notsale=0;
data price; set barter;
if missingprice=0;
data partial; set price;
if partial=0;
data credit; set partial;
if missingcredit=0;
data arm; set credit;
if notarmslength=0;
data redempt; set arm;
if redemption=0;
if retrocession=0;
data age; set redempt;
if missingage=0;
if missingsex=0;
data oldchild; set age;
if oldchild=0;
data group; set oldchild;
if groupsale=0;
data outlier; set group;
if outlier=0;
*************************;


male=0;
if Sex='M' then male=1;


warranty=1;
if guaranteed='No' then warranty=0;
if guaranteed='Partial' then warranty=0;
* Assume:  no warranty if listed defect;
* otherwise assume full warranty;

GuarM=0; if warranty=1 and sex='M' then guarM=1;
GuarF=0; if warranty=1 and sex='F' then guarF=1;


family=1;
if family_relationship ='' then family=0;
if family_relationship =' ' then family=0;
if family_relationship =' .' then family=0;
if family_relationship ='.' then family=0;
if family_relationship ='Orphans' then family=0;
if family_relationship ='Orphan' then family=0;
if family_relationship ='Pregnant' then family=0;

GroupSize2_5=0;
if 1<Number_of_Total_Slaves<6 then GroupSize2_5=1;
GroupSize6=0;
if 5<Number_of_Total_Slaves then GroupSize6=1;


age2=age**2/100;
age3=age**3/1000;
age4=age**4/10000;
age5=age**5/100000;
age6=age**6/1000000;

Mage=male*age;
Mage2=male*age2;
Mage3=male*age3;
Mage4=male*age4;
Mage5=male*age5;
Mage6=male*age6;



sale_year=year(no_sale_date);
sale_month=month(no_sale_date);
YearMonth=mdy(sale_month,15,sale_year);


jan=0;
feb=0;
mar=0;
apr=0;
may=0;
jun=0;
jul=0;
aug=0;
sep=0;
oct=0;
nov=0;
dec=0;
if sale_month=1 then jan=1;
if sale_month=2 then feb=1;
if sale_month=3 then mar=1;
if sale_month=4 then apr=1;
if sale_month=5 then may=1;
if sale_month=6 then jun=1;
if sale_month=7 then jul=1;
if sale_month=8 then aug=1;
if sale_month=9 then sep=1;
if sale_month=10 then oct=1;
if sale_month=11 then nov=1;
if sale_month=12 then dec=1;


summer=0;
fall=0;
winter=0;
spring=0;

if jun=1 then summer=1;
if jul=1 then summer=1;
if aug=1 then summer=1;
if sep=1 then fall=1;
if oct=1 then fall=1;
if nov=1 then fall=1;
if dec=1 then winter=1;
if jan=1 then winter=1;
if feb=1 then winter=1;
if mar=1 then spring=1;
if apr=1 then spring=1;
if may=1 then spring=1;


Kfall=0;
kwinter=0;
if jan=1 then kwinter=1;
if feb=1 then kwinter=1;
if mar=1 then kwinter=1;
if apr=1 then kwinter=1;
if oct=1 then kfall=1;
if nov=1 then kfall=1;
if dec=1 then kfall=1;
* Kotlikoff seasonal definitions;

light=0;

if color='Bright Mulatto' then light=1;
if color='Copper' then light=1;
if color='Creole Mulatto' then light=1;
if color='Griff' then light=1;
if color='Light' then light=1;
if color='Light Griff' then light=1;
if color='Mulatto' then light=1;
if color='Mulatto, Griff' then light=1;
if color='Quarteroon' then light=1;
if color='Yellow' then light=1;
if color='Albino, Negro' then light=1;
if color='Bright Color' then light=1;
if color='Griff Creole' then light=1;
if color='Light Brown' then light=1;
if color='Light Mulatto' then light=1;
if color='Chestnut' then light=1;
if color='Colored' then light=1;
* if color='Creole' then light=1;
* if color='Creole Negro' then light=1;
if color='Fair Mulatto' then light=1;
if color='Light Black' then light=1;
if color='Light Negro' then light=1;
if color='Yellow, Griff' then light=1;
* assumes that missing values for color are dark skinned;

dark=0;
if color='Dark Copper' then dark=1;
if color='Dark Griff' then dark=1;
if color='Dark Mulatto' then dark=1;
if color='Dark Orange, Griffe' then dark=1;
if color='Black' then dark=1;
if color='Black Negro' then dark=1;
if color='Brown' then dark=1;
if color='Dark' then dark=1;
if color='Dark Negro' then dark=1;
if color='Negro' then dark=1;

lightfemale=0;
if Sex='F' and light=1 then lightfemale=1;
lightmale=0;
if Sex='M' and light=1 then lightmale=1;

skilled=0;
if occupation="Blacksmith" then skilled=1;
if occupation="Bricklayer" then skilled=1;
if occupation="Carpenter" then skilled=1;
if occupation="Carpenter, Cooper" then skilled=1;
if occupation="Cooper" then skilled=1;
if occupation="Engineer, Blacksmith" then skilled=1;
if occupation="Field Hand, Blacksmith" then skilled=1;
if occupation="Plasterer" then skilled=1;
if occupation="Rough Carpenter" then skilled=1;
if occupation="Slater" then skilled=1;
if occupation="Pilot" then skilled=1;
if occupation="Cotton Weigher and Sampler" then skilled=1;


unskilled=0;
if occupation="Field Hand" then unskilled=1;
if occupation="Field Hand, Teamster" then unskilled=1;

domestic=0;
if occupation="Cook" then domestic=1; 
if occupation="Cook, Washer, Ironer" then domestic=1;
if occupation="Cook, Washer, Ironer, seamstress" then domestic=1;
if occupation="Cook, Washer, Seamstess" then domestic=1;
if occupation="Washer, Ironer, Tutor and Domestic" then domestic=1;
if occupation="Domestic" then domestic=1;
if occupation="House Servant" then domestic=1;
if occupation="Nanny" then domestic=1;

NoOccupation=0;
if unskilled=0 and domestic=0 and skilled=0 then NoOccupation=1;

hwm=0; if domestic=1 and sex='M' then hwm=1;
hwf=0; if domestic=1 and sex='F' then hwf=1;

localbuyer=0;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Algiers' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Algiers Parish' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Algiers, Orleans Parish' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Jefferson' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Jefferson Parish' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='New Orleans' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Orleans' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Orleans Parish' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='New Orleans, St. Mary, St. Mary' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Algiers ' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Jefferson' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='New Orleans' then localbuyer=1;
if buyers_state_of_origin='LA' and Buyers_County_of_Origin='Orleans ' then localbuyer=1;
if Buyers_County_of_Origin='New Orleans' then localbuyer=1;

age_child_1=age_child_1+0;
age_child_2=age_child_2+0;
age_child_3=age_child_3+0;
age_child_4=age_child_4+0;
age_child_5=age_child_5+0;
age_child_6=age_child_6+0;
age_child_7=age_child_7+0;
age_child_8=age_child_8+0;


k12=0;
if 0 le age_child_1 < 3.0 then k12=1;
if 0 le age_child_2 < 3.0 then k12=k12+1;
if 0 le age_child_3 < 3.0 then k12=k12+1;
if 0 le age_child_4 < 3.0 then k12=k12+1;
if 0 le age_child_5 < 3.0 then k12=k12+1;
if 0 le age_child_6 < 3.0 then k12=k12+1;
if 0 le age_child_7 < 3.0 then k12=k12+1;
if 0 le age_child_8 < 3.0 then k12=k12+1;


k345=0;
if 2.9 < age_child_1 < 6.0 then k345=1;
if 2.9 < age_child_2 < 6.0 then k345=k345+1;
if 2.9 < age_child_3 < 6.0 then k345=k345+1;
if 2.9 < age_child_4 < 6.0 then k345=k345+1;
if 2.9 < age_child_5 < 6.0 then k345=k345+1;
if 2.9 < age_child_6 < 6.0 then k345=k345+1;
if 2.9 < age_child_7 < 6.0 then k345=k345+1;
if 2.9 < age_child_8 < 6.0 then k345=k345+1;

k6789=0;
if 5.9 < age_child_1 < 10.0 then k6789=1;
if 5.9 < age_child_2 < 10.0 then k6789=k6789+1;
if 5.9 < age_child_3 < 10.0 then k6789=k6789+1;
if 5.9 < age_child_4 < 10.0 then k6789=K6789+1;
if 5.9 < age_child_5 < 10.0 then k6789=k6789+1;
if 5.9 < age_child_6 < 10.0 then k6789=k6789+1;
if 5.9 < age_child_7 < 10.0 then k6789=k6789+1;
if 5.9 < age_child_8 < 10.0 then k6789=k6789+1;

if 9.9 < age_child_1 then delete;
if 9.9 < age_child_2 then delete;
if 9.9 < age_child_3 then delete;
if 9.9 < age_child_4 then delete;
if 9.9 < age_child_5 then delete;
if 9.9 < age_child_6 then delete;
if 9.9 < age_child_7 then delete;
if 9.9 < age_child_8 then delete;
* deletes mothers with older children attached to record;
* creates kid variables;

estate_sale=0;
if Dummy_Estate_Sale=1 then estate_sale=1;


Oct1856=0; if Sale_Year=1856 and Sale_Month=10 then Oct1856=1;
Nov1856=0; if Sale_Year=1856 and Sale_Month=11 then Nov1856=1;
Dec1856=0; if Sale_Year=1856 and Sale_Month=12 then Dec1856=1;
Jan1857=0; if Sale_Year=1857 and Sale_Month=1 then Jan1857=1;
Feb1857=0; if Sale_Year=1857 and Sale_Month=2 then Feb1857=1;
Mar1857=0; if Sale_Year=1857 and Sale_Month=3 then Mar1857=1;
Apr1857=0; if Sale_Year=1857 and Sale_Month=4 then Apr1857=1;
May1857=0; if Sale_Year=1857 and Sale_Month=5 then May1857=1;
Jun1857=0; if Sale_Year=1857 and Sale_Month=6 then Jun1857=1;
Jul1857=0; if Sale_Year=1857 and Sale_Month=7 then Jul1857=1;
Aug1857=0; if Sale_Year=1857 and Sale_Month=8 then Aug1857=1;
Sep1857=0; if Sale_Year=1857 and Sale_Month=9 then Sep1857=1;
Oct1857=0; if Sale_Year=1857 and Sale_Month=10 then Oct1857=1;
Nov1857=0; if Sale_Year=1857 and Sale_Month=11 then Nov1857=1;
Dec1857=0; if Sale_Year=1857 and Sale_Month=12 then Dec1857=1;
Jan1858=0; if Sale_Year=1858 and Sale_Month=1 then Jan1858=1;
Feb1858=0; if Sale_Year=1858 and Sale_Month=2 then Feb1858=1;
Mar1858=0; if Sale_Year=1858 and Sale_Month=3 then Mar1858=1;
Apr1858=0; if Sale_Year=1858 and Sale_Month=4 then Apr1858=1;
May1858=0; if Sale_Year=1858 and Sale_Month=5 then May1858=1;
Jun1858=0; if Sale_Year=1858 and Sale_Month=6 then Jun1858=1;
Jul1858=0; if Sale_Year=1858 and Sale_Month=7 then Jul1858=1;
Aug1858=0; if Sale_Year=1858 and Sale_Month=8 then Aug1858=1;
Sep1858=0; if Sale_Year=1858 and Sale_Month=9 then Sep1858=1;
Oct1858=0; if Sale_Year=1858 and Sale_Month=10 then Oct1858=1;
Nov1858=0; if Sale_Year=1858 and Sale_Month=11 then Nov1858=1;
Dec1858=0; if Sale_Year=1858 and Sale_Month=12 then Dec1858=1;
Jan1859=0; if Sale_Year=1859 and Sale_Month=1 then Jan1859=1;
Feb1859=0; if Sale_Year=1859 and Sale_Month=2 then Feb1859=1;
Mar1859=0; if Sale_Year=1859 and Sale_Month=3 then Mar1859=1;
Apr1859=0; if Sale_Year=1859 and Sale_Month=4 then Apr1859=1;
May1859=0; if Sale_Year=1859 and Sale_Month=5 then May1859=1;
Jun1859=0; if Sale_Year=1859 and Sale_Month=6 then Jun1859=1;
Jul1859=0; if Sale_Year=1859 and Sale_Month=7 then Jul1859=1;
Aug1859=0; if Sale_Year=1859 and Sale_Month=8 then Aug1859=1;
Sep1859=0; if Sale_Year=1859 and Sale_Month=9 then Sep1859=1;
Oct1859=0; if Sale_Year=1859 and Sale_Month=10 then Oct1859=1;
Nov1859=0; if Sale_Year=1859 and Sale_Month=11 then Nov1859=1;
Dec1859=0; if Sale_Year=1859 and Sale_Month=12 then Dec1859=1;
Jan1860=0; if Sale_Year=1860 and Sale_Month=1 then Jan1860=1;
Feb1860=0; if Sale_Year=1860 and Sale_Month=2 then Feb1860=1;
Mar1860=0; if Sale_Year=1860 and Sale_Month=3 then Mar1860=1;
Apr1860=0; if Sale_Year=1860 and Sale_Month=4 then Apr1860=1;
May1860=0; if Sale_Year=1860 and Sale_Month=5 then May1860=1;
Jun1860=0; if Sale_Year=1860 and Sale_Month=6 then Jun1860=1;
Jul1860=0; if Sale_Year=1860 and Sale_Month=7 then Jul1860=1;
Aug1860=0; if Sale_Year=1860 and Sale_Month=8 then Aug1860=1;
Sep1860=0; if Sale_Year=1860 and Sale_Month=9 then Sep1860=1;
Oct1860=0; if Sale_Year=1860 and Sale_Month=10 then Oct1860=1;
Nov1860=0; if Sale_Year=1860 and Sale_Month=11 then Nov1860=1;
Dec1860=0; if Sale_Year=1860 and Sale_Month=12 then Dec1860=1;
Jan1861=0; if Sale_Year=1861 and Sale_Month=1 then Jan1861=1;
Feb1861=0; if Sale_Year=1861 and Sale_Month=2 then Feb1861=1;
Mar1861=0; if Sale_Year=1861 and Sale_Month=3 then Mar1861=1;
Apr1861=0; if Sale_Year=1861 and Sale_Month=4 then Apr1861=1;
May1861=0; if Sale_Year=1861 and Sale_Month=5 then May1861=1;
Jun1861=0; if Sale_Year=1861 and Sale_Month=6 then Jun1861=1;
Jul1861=0; if Sale_Year=1861 and Sale_Month=7 then Jul1861=1;
Aug1861=0; if Sale_Year=1861 and Sale_Month=8 then Aug1861=1;

if MthCred=. then MthCred=0;
if Dummy_credit=0 then MthCred=0;
if Interest_Rate>0 then MthCred=0;
* Kotlikoff's credit variable;
* assumes that credit price equals cash price if interest rate specified;

if interest_rate=. then interest_rate=0;

if interest_rate>0 then I_mthcred=mthcred; else I_mthcred=0;
if interest_rate=0.08 then rateceiling=1; else rateceiling=0;
if 0<interest_rate<0.08 then notbindingceiling=1; else notbindingceiling=0;

Credit=0;
if Dummy_Credit=1 then Credit=1;
if Dummy_Credit=1 then price=PresentValue;
* assigning Present Value of credit payment, assuming 8% interest;





if price > 0;
* only positive prices;

lnprice=log(price);


if winter=1 then lnprice=lnprice-0.07027;
if spring=1 then lnprice=lnprice-0.04070;
if fall=1 then lnprice=lnprice-0.01870;
* blunt force adjustment for seasonality;
* uses estimates from F and E 1840 to 1861;


if mdy(1,1,1857)<= no_sale_date<mdy(3,1,1857) then JanFeb57=1; else JanFeb57=0;
if mdy(3,8,1857)<= no_sale_date<mdy(5,8,1857) then MarMay57=1; else MarMay57=0;
if mdy(10,1,1857)<= no_sale_date<mdy(12,1,1857) then OctNov57=1; else OctNov57=0;
if mdy(8,17,1859)<= no_sale_date<mdy(10,17,1859) then AugOct59=1; else AugOct59=0;
if mdy(10,17,1859)<= no_sale_date<mdy(12,17,1859) then OctDec59=1; else OctDec59=0;
if mdy(2,23,1860)<= no_sale_date<mdy(4,23,1860) then FebApr60=1; else FebApr60=0;
if mdy(6,25,1860)<= no_sale_date<mdy(8,25,1860) then JunAug60=1; else JunAug60=0;
if mdy(11,7,1860)<= no_sale_date<mdy(1,7,1861) then NovJan61=1; else NovJan61=0;
if mdy(4,12,1861)<= no_sale_date<mdy(6,12,1861) then AprJun61=1; else AprJun61=0;
if mdy(7,21,1861)<= no_sale_date<mdy(9,1,1861) then JulAug61=1; else JulAug61=0;

YearMonth=MDY(sale_month,1,sale_year);


if YearMonth<MDY(10,1,1856) then delete;
* beginning of sample period;
if YearMonth>MDY(8,1,1861) then delete;
* last observation on cotton prices;

proc sort; by sale_year sale_month;

data three; set convey.time;
  proc sort; by sale_year sale_month;

data four; merge outlier three; by sale_year sale_month;

YearMonth=MDY(sale_month,1,sale_year); 

sum58=0; if sale_year=1858 and summer=1 then sum58=1;
fall58=0; if sale_year=1858 and fall=1 then fall58=1;

if YearMonth<MDY(10,1,1856) then delete;
* beginning of sample period;
if YearMonth>MDY(8,1,1861) then delete;
* last observation on cotton prices;

  logcotton=log(cotton);
  logconsol=log(consol);


trader10_49=0;  if 9<count<50 then trader10_49=1;
trader50=0; if count>50 then trader50=1;

if estate_sale=1 then trader10_49=0;
if estate_sale=1 then trader50=0;

* traders not sellers at estate sales;

ods csv file='C:\table_3_reg2.csv';

proc surveyreg;
  cluster yearmonth;
   model lnprice=
   logconsol
   JanFeb57 MarMay57 OctNov57 FebApr60
   JunAug60 NovJan61 AprJun61 JulAug61
   sum58 fall58
   male lightfemale lightmale GuarM GuarF
   K12 K345 K6789
   credit rateceiling  
   skilled hwf hwm NoOccupation 
   trader10_49 trader50
   family localbuyer estate_sale emancipation selfpurchase
   groupsize2_5 groupsize6
   age age2-age6 
   mage mage2-mage6  / covb; 
   

   run;


proc reg s;
   model lnprice=
   logconsol
   JanFeb57 MarMay57 OctNov57 FebApr60
   JunAug60 NovJan61 AprJun61 JulAug61
   sum58 fall58
   male lightfemale lightmale GuarM GuarF
   K12 K345 K6789
   credit rateceiling  
   skilled hwf hwm noOccupation
   trader10_49 trader50 
   family localbuyer estate_sale emancipation selfpurchase
   groupsize2_5 groupsize6
   age age2-age6 
   mage mage2-mage6 / acov; 
   
DredScott: test JanFeb57=MarMay57;
Panic57: test MarMay57=OctNov57;
Nominate: test FebApr60=JunAug60;
Elect: test JunAug60=NovJan61;
Sumter: test NovJan61=AprJun61;
BullRun: test AprJun61=JulAug61;
ERA1: test NovJan61=JulAug61;
ERA2: test JunAug60=JulAug61;
ERA3: test FebApr60=JulAug61;
   run;
   
ods csv close;

