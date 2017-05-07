DATA CASE1;
     DO YEAR=73 TO 78;
        DO MONTH=1 TO 12;
           DATE=MDY(MONTH,1,YEAR);
       one=1;
           INPUT LOAN @@;
       Output;
        END;
     END;
KEEP DATE LOAN one; 
FORMAT DATE MONYY5.;
Title 'COMMERCIAL BANK REAL-ESTATE LOANS';
CARDS;
46.5 47 47.5 48.3 49.1 50.1 51.1 52 53.2 53.9 54.5 55.2 55.6 55.7 56.1
56.8 57.5 58.3 58.9 59.4 59.8 60 60 60.3 60.1 59.7 59.5 59.4 59.3 59.2
59.1 59 59.3 59.5 59.5 59.5 59.7 59.7 60.5 60.7 61.3 61.4 61.8
62.4 62.4 62.9 63.2 63.4 63.9 64.5 65 65.4 66.3 67.7 69 70 71.4
72.5 73.4 74.6 75.2 75.9 76.8 77.9 79.2 80.5 82.6 84.4 85.9 87.6
;
PROC PRINT;RUN;


Proc means noprint ;
 var LOAN; 
 output out=AA mean=mean;
data Mean; set AA;
 one=1;keep mean one;

data case;merge case1 mean;by one;
drop one;
proc print;run;
symbol1 color=blue
        interpol=join
        value=dot
        height=1;
symbol2 font=marker value=c
        interpol=box
        color=red
        
        height=0.2;
legend1 label=none
        position=(top center inside)
        mode=share;
proc gplot data=case;
   plot LOAN*date mean*date /
        overlay legend=legend1;                  
run;


PROC ARIMA data=case;
IDENTIFY VAR=LOAN stationarity=(adf);
estimate p=1;
RUN;

PROC ARIMA data=case;
IDENTIFY VAR=LOAN(1) stationarity=(adf);
estimate p=1;
RUN;

PROC ARIMA data=case;
IDENTIFY VAR=LOAN(1,1) stationarity=(adf);
estimate p=1;
RUN;

PROC ARIMA data=case;
IDENTIFY VAR=LOAN(1,1) stationarity=(adf) minic esacf scan;
estimate q=1 noconstant;
forecast lead = 24;
RUN;

