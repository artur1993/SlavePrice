************************************************;
* creates output for Figure 3 in Calomiris and Pritchett;
* duration between initial and secondary sale for repeat purchases;
************************************************;
filename graphout 'C:\';
option ls=120;
PROC IMPORT OUT= one 
            DATAFILE= "C:\CalomirisPritchett_data.xlsx" 
            DBMS=EXCEL REPLACE;    
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

proc contents;

data two;  set one;

if reason_for_omission='OMIT: Group sale' then Dummy_omission=1;
if reason_for_omission='OMIT: Retrocession' then Dummy_omission=1;
if reason_for_omission='OMIT: Old sale' then Dummy_omission=1;

if reason_for_omission='OMIT: Condition of emancipation' then Dummy_omission=0;
if reason_for_omission='OMIT: Condition of emancipation. Not a market price' then Dummy_omission=0;
if reason_for_omission='OMIT: Condition of emancipation. Self-purchase' then Dummy_omission=0;
if reason_for_omission='OMIT: Emancipation' then Dummy_omission=0;
if reason_for_omission='OMIT: Not a market price. Condition of emancipation' then Dummy_omission=0;
emancipation=0;
if reason_for_omission='OMIT: Condition of emancipation' then emancipation=1;
if reason_for_omission='OMIT: Condition of emancipation. Not a market price' then emancipation=1;
if reason_for_omission='OMIT: Condition of emancipation. Self-purchase' then emancipation=1;
if reason_for_omission='OMIT: Emancipation' then emancipation=1;
if reason_for_omission='OMIT: Not a market price. Condition of emancipation' then emancipation=1;

if dummy_omission=0;
* dumps weird observations; 

if age>0;
* delete missing values for age;

if payment_method='Barter' then delete;
if payment_method='Barter, Cash' then delete;
if payment_method='Barter, Credit' then delete;
if payment_method='Donation' then delete;
if payment_method='Exchange' then delete;
if payment_method='Exchange, Cash' then delete;
if payment_method='Exchange, Credit' then delete;
* not market prices;


male=0;
if Sex='M' then male=1;
if Sex='.' then delete;
if Sex='' then delete;
* remove missing values for gender;

warranty=1;
if guaranteed='No' then warranty=0;
if guaranteed='Partial' then warranty=0;
* Assume:  no warranty if listed defect;
* otherwise assume full warranty;

GuarM=0; if warranty=1 and sex='M' then guarM=1;
GuarF=0; if warranty=1 and sex='F' then guarF=1;


family=1;
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

no_sale_date=input(sales_date,mmddyy10.);

if no_sale_date=. then delete;
* dumps missing values for sale date;

if no_sale_date<mdy(10,1,1856) then delete;
if no_sale_date>MDY(8,31,1861) then delete;
* last observation on cotton prices;



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

Nage_child_1=age_child_1+0;
Nage_child_2=age_child_2+0;
Nage_child_3=age_child_3+0;
Nage_child_4=age_child_4+0;
Nage_child_5=age_child_5+0;
Nage_child_6=age_child_6+0;
Nage_child_7=age_child_7+0;
Nage_child_8=age_child_8+0;


k12=0;
if 0 le Nage_child_1 < 3.0 then k12=1;
if 0 le Nage_child_2 < 3.0 then k12=k12+1;
if 0 le Nage_child_3 < 3.0 then k12=k12+1;
if 0 le Nage_child_4 < 3.0 then k12=k12+1;
if 0 le Nage_child_5 < 3.0 then k12=k12+1;
if 0 le Nage_child_6 < 3.0 then k12=k12+1;
if 0 le Nage_child_7 < 3.0 then k12=k12+1;
if 0 le Nage_child_8 < 3.0 then k12=k12+1;


k345=0;
if 2.9 < Nage_child_1 < 6.0 then k345=1;
if 2.9 < Nage_child_2 < 6.0 then k345=k345+1;
if 2.9 < Nage_child_3 < 6.0 then k345=k345+1;
if 2.9 < Nage_child_4 < 6.0 then k345=k345+1;
if 2.9 < Nage_child_5 < 6.0 then k345=k345+1;
if 2.9 < Nage_child_6 < 6.0 then k345=k345+1;
if 2.9 < Nage_child_7 < 6.0 then k345=k345+1;
if 2.9 < Nage_child_8 < 6.0 then k345=k345+1;

k6789=0;
if 5.9 < Nage_child_1 < 10.0 then k6789=1;
if 5.9 < Nage_child_2 < 10.0 then k6789=k6789+1;
if 5.9 < Nage_child_3 < 10.0 then k6789=k6789+1;
if 5.9 < Nage_child_4 < 10.0 then k6789=K6789+1;
if 5.9 < Nage_child_5 < 10.0 then k6789=k6789+1;
if 5.9 < Nage_child_6 < 10.0 then k6789=k6789+1;
if 5.9 < Nage_child_7 < 10.0 then k6789=k6789+1;
if 5.9 < Nage_child_8 < 10.0 then k6789=k6789+1;

if 9.9 < Nage_child_1 then delete;
if 9.9 < Nage_child_2 then delete;
if 9.9 < Nage_child_3 then delete;
if 9.9 < Nage_child_4 then delete;
if 9.9 < Nage_child_5 then delete;
if 9.9 < Nage_child_6 then delete;
if 9.9 < Nage_child_7 then delete;
if 9.9 < Nage_child_8 then delete;
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



if 0<day(no_sale_date)<16 then bimonth=mdy(sale_month,10,sale_year);
if 15<day(no_sale_date) then bimonth=mdy(sale_month,20,sale_year);

if mthcred le 0 then MthCred=0;
if Interest_Rate>0 then MthCred=0;
* Kotlikoff's credit variable;
* assumes that credit price equals cash price if interest rate specified;


Credit=0;
if Dummy_Credit=1 then Credit=1;
* indicates a credit sale;

if Dummy_Credit=1 then price=PresentValue;
* assigning Present Value of credit payment, assuming 8% interest;

if price > 0;
* only positive prices;

lnprice=log(price);

YearMonth=MDY(sale_month,1,sale_year);


if YearMonth<MDY(10,1,1856) then delete;
* beginning of sample period;
if YearMonth>MDY(8,1,1861) then delete;
* last observation on cotton prices;

proc surveyreg;
cluster YearMonth; 
   model lnprice=male lightfemale lightmale GuarM GuarF
   age age2-age6
   K12 K345 K6789
   skilled hwm hwf unskilled 
   Credit
   groupsize2_5 groupsize6
   family localbuyer estate_sale emancipation 
   Nov1856 Dec1856
   Jan1857 Feb1857 Mar1857 Apr1857 May1857 Jun1857
   Jul1857 Aug1857 Sep1857 Oct1857 Nov1857 Dec1857
   Jan1858 Feb1858 Mar1858 Apr1858 May1858 Jun1858 
   Jul1858 Aug1858 Sep1858 Oct1858 Nov1858 Dec1858
   Jan1859 Feb1859 Mar1859 Apr1859 May1859 Jun1859 
   Jul1859 Aug1859 Sep1859 Oct1859 Nov1859 Dec1859
   Jan1860 Feb1860 Mar1860 Apr1860 May1860 Jun1860 
   Jul1860 Aug1860 Sep1860 Oct1860 Nov1860 Dec1860
   Jan1861 Feb1861 Mar1861 Apr1861 May1861 Jun1861 
   Jul1861 Aug1861;   
   output out=extremes r=extremes;
run;


data trimmed; set extremes;
kara=0;
if extremes<-2 then kara=1;
if 2<extremes then kara=1;
if kara=1 then delete;
* deletes outliers;



data A; set trimmed;


Ano_sale_date=no_sale_date;
ASellers_First_Name=Sellers_First_Name;
ASellers_Last_Name=Sellers_Last_Name; 
Amale=male;
Alnprice=lnprice;
Awarranty=warranty;
ASlave_Name=Slave_Name;
ABuyers_First_Name=Buyers_First_Name;
ABuyers_Last_Name=Buyers_Last_Name;
Alight=light;
AID_number=ID_number;
Aage=age;

keep Ano_sale_date Asellers_first_name Asellers_last_name AID_number 
Amale Alnprice Awarranty Aslave_name Abuyers_first_name Abuyers_last_name
alight Aage;


data B; set trimmed;



Bno_sale_date=no_sale_date;
BSellers_First_Name=Sellers_First_Name;
BSellers_Last_Name=Sellers_Last_Name; 
Bmale=male;
Blnprice=lnprice;
Bwarranty=warranty;
BSlave_Name=Slave_Name;
BBuyers_First_Name=Buyers_First_Name;
BBuyers_Last_Name=Buyers_Last_Name;
Blight=light;
BID_number=ID_number;
Bage=age;

keep Bno_sale_date Bsellers_first_name Bsellers_last_name BID_number 
Bmale Blnprice Bwarranty Bslave_name Bbuyers_first_name Bbuyers_last_name
Blight Bage;



Proc sql;
       create table temp1 as

       select *
         from A, B 
         where Ano_sale_date>Bno_sale_date 
            and ASellers_First_Name=*BBuyers_First_Name
            and ASellers_Last_name=*BBuyers_last_Name 
            and ASlave_name=*BSlave_name
            and Amale=Bmale
            and ASellers_Last_name ne ''
            and ASellers_First_name ne ''
            and AID_number ne BID_number
            and (Bage-1 <= (Aage - INT((Ano_sale_date-bno_sale_date)/365))<=Bage +1);
           

quit;

proc means;
proc contents;
run;


Proc sql;
  create table temp2 as
  select *, count(*) as Count2
  from temp1
  group by AID_number
  having count(*)=1;
* avoids multiple matches;
quit;

proc sql;
  create table intersect as
  select *, count(*) as Count3
  from temp2
  group by BID_number
  having count(*)=1;
* avoids multiple matches;
quit;



data unique; set intersect;

buyback=0;
if soundex(Bsellers_last_name) = soundex(Abuyers_last_name) and 
soundex(Bsellers_first_name) = soundex(Abuyers_first_name)
   then buyback=1;

***************************;
if buyback=0;
* delete buybacks from calculation;
***************************;


saleduration=ano_sale_date - bno_sale_date;
asale_year=year(ano_sale_date);
asale_month=month(ano_sale_date);
bsale_year=year(bno_sale_date);
bsale_month=month(bno_sale_date);

********************************;
if saleduration < 32 then delete;
* dump short term sales;
********************************;

Oct1856=0; if aSale_Year=1856 and aSale_Month=10 then Oct1856=1;
Nov1856=0; if aSale_Year=1856 and aSale_Month=11 then Nov1856=1;
Dec1856=0; if aSale_Year=1856 and aSale_Month=12 then Dec1856=1;
Jan1857=0; if aSale_Year=1857 and aSale_Month=1 then Jan1857=1;
Feb1857=0; if aSale_Year=1857 and aSale_Month=2 then Feb1857=1;
Mar1857=0; if aSale_Year=1857 and aSale_Month=3 then Mar1857=1;
Apr1857=0; if aSale_Year=1857 and aSale_Month=4 then Apr1857=1;
May1857=0; if aSale_Year=1857 and aSale_Month=5 then May1857=1;
Jun1857=0; if aSale_Year=1857 and aSale_Month=6 then Jun1857=1;
Jul1857=0; if aSale_Year=1857 and aSale_Month=7 then Jul1857=1;
Aug1857=0; if aSale_Year=1857 and aSale_Month=8 then Aug1857=1;
Sep1857=0; if aSale_Year=1857 and aSale_Month=9 then Sep1857=1;
Oct1857=0; if aSale_Year=1857 and aSale_Month=10 then Oct1857=1;
Nov1857=0; if aSale_Year=1857 and aSale_Month=11 then Nov1857=1;
Dec1857=0; if aSale_Year=1857 and aSale_Month=12 then Dec1857=1;
Jan1858=0; if aSale_Year=1858 and aSale_Month=1 then Jan1858=1;
Feb1858=0; if aSale_Year=1858 and aSale_Month=2 then Feb1858=1;
Mar1858=0; if aSale_Year=1858 and aSale_Month=3 then Mar1858=1;
Apr1858=0; if aSale_Year=1858 and aSale_Month=4 then Apr1858=1;
May1858=0; if aSale_Year=1858 and aSale_Month=5 then May1858=1;
Jun1858=0; if aSale_Year=1858 and aSale_Month=6 then Jun1858=1;
Jul1858=0; if aSale_Year=1858 and aSale_Month=7 then Jul1858=1;
Aug1858=0; if aSale_Year=1858 and aSale_Month=8 then Aug1858=1;
Sep1858=0; if aSale_Year=1858 and aSale_Month=9 then Sep1858=1;
Oct1858=0; if aSale_Year=1858 and aSale_Month=10 then Oct1858=1;
Nov1858=0; if aSale_Year=1858 and aSale_Month=11 then Nov1858=1;
Dec1858=0; if aSale_Year=1858 and aSale_Month=12 then Dec1858=1;
Jan1859=0; if aSale_Year=1859 and aSale_Month=1 then Jan1859=1;
Feb1859=0; if aSale_Year=1859 and aSale_Month=2 then Feb1859=1;
Mar1859=0; if aSale_Year=1859 and aSale_Month=3 then Mar1859=1;
Apr1859=0; if aSale_Year=1859 and aSale_Month=4 then Apr1859=1;
May1859=0; if aSale_Year=1859 and aSale_Month=5 then May1859=1;
Jun1859=0; if aSale_Year=1859 and aSale_Month=6 then Jun1859=1;
Jul1859=0; if aSale_Year=1859 and aSale_Month=7 then Jul1859=1;
Aug1859=0; if aSale_Year=1859 and aSale_Month=8 then Aug1859=1;
Sep1859=0; if aSale_Year=1859 and aSale_Month=9 then Sep1859=1;
Oct1859=0; if aSale_Year=1859 and aSale_Month=10 then Oct1859=1;
Nov1859=0; if aSale_Year=1859 and aSale_Month=11 then Nov1859=1;
Dec1859=0; if aSale_Year=1859 and aSale_Month=12 then Dec1859=1;
Jan1860=0; if aSale_Year=1860 and aSale_Month=1 then Jan1860=1;
Feb1860=0; if aSale_Year=1860 and aSale_Month=2 then Feb1860=1;
Mar1860=0; if aSale_Year=1860 and aSale_Month=3 then Mar1860=1;
Apr1860=0; if aSale_Year=1860 and aSale_Month=4 then Apr1860=1;
May1860=0; if aSale_Year=1860 and aSale_Month=5 then May1860=1;
Jun1860=0; if aSale_Year=1860 and aSale_Month=6 then Jun1860=1;
Jul1860=0; if aSale_Year=1860 and aSale_Month=7 then Jul1860=1;
Aug1860=0; if aSale_Year=1860 and aSale_Month=8 then Aug1860=1;
Sep1860=0; if aSale_Year=1860 and aSale_Month=9 then Sep1860=1;
Oct1860=0; if aSale_Year=1860 and aSale_Month=10 then Oct1860=1;
Nov1860=0; if aSale_Year=1860 and aSale_Month=11 then Nov1860=1;
Dec1860=0; if aSale_Year=1860 and aSale_Month=12 then Dec1860=1;
Jan1861=0; if aSale_Year=1861 and aSale_Month=1 then Jan1861=1;
Feb1861=0; if aSale_Year=1861 and aSale_Month=2 then Feb1861=1;
Mar1861=0; if aSale_Year=1861 and aSale_Month=3 then Mar1861=1;
Apr1861=0; if aSale_Year=1861 and aSale_Month=4 then Apr1861=1;
May1861=0; if aSale_Year=1861 and aSale_Month=5 then May1861=1;
Jun1861=0; if aSale_Year=1861 and aSale_Month=6 then Jun1861=1;
Jul1861=0; if aSale_Year=1861 and aSale_Month=7 then Jul1861=1;
Aug1861=0; if aSale_Year=1861 and aSale_Month=8 then Aug1861=1;

if bSale_Year=1856 and bSale_Month=10 then Oct1856=-1;
if bSale_Year=1856 and bSale_Month=11 then Nov1856=-1;
if bSale_Year=1856 and bSale_Month=12 then Dec1856=-1;
if bSale_Year=1857 and bSale_Month=1 then Jan1857=-1;
if bSale_Year=1857 and bSale_Month=2 then Feb1857=-1;
if bSale_Year=1857 and bSale_Month=3 then Mar1857=-1;
if bSale_Year=1857 and bSale_Month=4 then Apr1857=-1;
if bSale_Year=1857 and bSale_Month=5 then May1857=-1;
if bSale_Year=1857 and bSale_Month=6 then Jun1857=-1;
if bSale_Year=1857 and bSale_Month=7 then Jul1857=-1;
if bSale_Year=1857 and bSale_Month=8 then Aug1857=-1;
if bSale_Year=1857 and bSale_Month=9 then Sep1857=-1;
if bSale_Year=1857 and bSale_Month=10 then Oct1857=-1;
if bSale_Year=1857 and bSale_Month=11 then Nov1857=-1;
if bSale_Year=1857 and bSale_Month=12 then Dec1857=-1;
if bSale_Year=1858 and bSale_Month=1 then Jan1858=-1;
if bSale_Year=1858 and bSale_Month=2 then Feb1858=-1;
if bSale_Year=1858 and bSale_Month=3 then Mar1858=-1;
if bSale_Year=1858 and bSale_Month=4 then Apr1858=-1;
if bSale_Year=1858 and bSale_Month=5 then May1858=-1;
if bSale_Year=1858 and bSale_Month=6 then Jun1858=-1;
if bSale_Year=1858 and bSale_Month=7 then Jul1858=-1;
if bSale_Year=1858 and bSale_Month=8 then Aug1858=-1;
if bSale_Year=1858 and bSale_Month=9 then Sep1858=-1;
if bSale_Year=1858 and bSale_Month=10 then Oct1858=-1;
if bSale_Year=1858 and bSale_Month=11 then Nov1858=-1;
if bSale_Year=1858 and bSale_Month=12 then Dec1858=-1;
if bSale_Year=1859 and bSale_Month=1 then Jan1859=-1;
if bSale_Year=1859 and bSale_Month=2 then Feb1859=-1;
if bSale_Year=1859 and bSale_Month=3 then Mar1859=-1;
if bSale_Year=1859 and bSale_Month=4 then Apr1859=-1;
if bSale_Year=1859 and bSale_Month=5 then May1859=-1;
if bSale_Year=1859 and bSale_Month=6 then Jun1859=-1;
if bSale_Year=1859 and bSale_Month=7 then Jul1859=-1;
if bSale_Year=1859 and bSale_Month=8 then Aug1859=-1;
if bSale_Year=1859 and bSale_Month=9 then Sep1859=-1;
if bSale_Year=1859 and bSale_Month=10 then Oct1859=-1;
if bSale_Year=1859 and bSale_Month=11 then Nov1859=-1;
if bSale_Year=1859 and bSale_Month=12 then Dec1859=-1;
if bSale_Year=1860 and bSale_Month=1 then Jan1860=-1;
if bSale_Year=1860 and bSale_Month=2 then Feb1860=-1;
if bSale_Year=1860 and bSale_Month=3 then Mar1860=-1;
if bSale_Year=1860 and bSale_Month=4 then Apr1860=-1;
if bSale_Year=1860 and bSale_Month=5 then May1860=-1;
if bSale_Year=1860 and bSale_Month=6 then Jun1860=-1;
if bSale_Year=1860 and bSale_Month=7 then Jul1860=-1;
if bSale_Year=1860 and bSale_Month=8 then Aug1860=-1;
if bSale_Year=1860 and bSale_Month=9 then Sep1860=-1;
if bSale_Year=1860 and bSale_Month=10 then Oct1860=-1;
if bSale_Year=1860 and bSale_Month=11 then Nov1860=-1;
if bSale_Year=1860 and bSale_Month=12 then Dec1860=-1;
if bSale_Year=1861 and bSale_Month=1 then Jan1861=-1;
if bSale_Year=1861 and bSale_Month=2 then Feb1861=-1;
if bSale_Year=1861 and bSale_Month=3 then Mar1861=-1;
if bSale_Year=1861 and bSale_Month=4 then Apr1861=-1;
if bSale_Year=1861 and bSale_Month=5 then May1861=-1;
if bSale_Year=1861 and bSale_Month=6 then Jun1861=-1;
if bSale_Year=1861 and bSale_Month=7 then Jul1861=-1;
if bSale_Year=1861 and bSale_Month=8 then Aug1861=-1;




Apredprice=3.96745 + 0.3547 + (0.38841*Aage)+(-2.39257*Aage**2/100)+(0.80246*Aage**3/1000)+
           (-0.16041*Aage**4/10000)+(0.01704*Aage**5/100000)+(-0.00072765*Aage**6/1000000);
* predicted price of female slave w/ guarantee;

Bpredprice=3.96745 + 0.3547 + (0.38841*Bage)+(-2.39257*Bage**2/100)+(0.80246*Bage**3/1000)+
           (-0.16041*Bage**4/10000)+(0.01704*Bage**5/100000)+(-0.00072765*Bage**6/1000000);

* predicted price from regression 1, hedonic regression;

Agepricechange=Apredprice-Bpredprice;
* predicted price change due to increased age of slave;


pcpricechange=alnprice-blnprice;

Adpricechange=pcpricechange-agepricechange;
* price change not due to ageing of slave;


proc format;
  value dur 0-30='less than 1 month'
           31-60='1-2 months'
           61-90='2-3 months'
           91-150='3-5 months'
          151-240='5-8 months'
          241-365='8-12 months'
          366-730='1-2 years'
          731-1095='2-3 years'
          1096-high='more than 3 years';




ods csv file='C:\output.csv';

proc freq;
  tables ano_sale_date;
  format ano_sale_date monyy7.;

proc format;
  value change low-0='decrease'
                    0='no change'
		0-high='increase';

proc freq;
  tables adpricechange;
  format adpricechange change.;
  run;

proc means n median mean std stderr t probt;
  var adpricechange;


proc freq;
  tables ano_sale_date bno_sale_date;
   format ano_sale_date monyy7. bno_sale_date monyy7.;

proc freq;
   tables saleduration;
    format saleduration dur.;

proc means;
  var saleduration;


proc sort; by asale_year;
proc means; by asale_year;
var Dage;

run;

proc univariate;
  var saleduration adpricechange;

proc reg;
  model adpricechange= Nov1856 Dec1856
   Jan1857 Feb1857 Mar1857 Apr1857 May1857 Jun1857
   Jul1857 Aug1857 Sep1857 Oct1857 Nov1857 Dec1857
   Jan1858 Feb1858 Mar1858 Apr1858 May1858 Jun1858 
   Jul1858 Aug1858 Sep1858 Oct1858 Nov1858 Dec1858
   Jan1859 Feb1859 Mar1859 Apr1859 May1859 Jun1859 
   Jul1859 Aug1859 Sep1859 Oct1859 Nov1859 Dec1859
   Jan1860 Feb1860 Mar1860 Apr1860 May1860 Jun1860 
   Jul1860 Aug1860 Sep1860 Oct1860 Nov1860 Dec1860
   Jan1861 Feb1861 Mar1861 Apr1861 May1861 Jun1861 
   Jul1861 Aug1861 ; 
run;

ods csv close;

