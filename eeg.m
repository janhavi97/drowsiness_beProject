clc
close all
clear all


[a b c]=xlsread('samples11.csv');
%%fft of Cz Channel
[aa1] = daqdocfft(cell2mat(c(3:end,11)),500,255);
%%fft of Fz Channel
[aa2] = daqdocfft(cell2mat(c(3:end,34)),500,255);
%%fft of P3 Channel
[aa3] = daqdocfft(cell2mat(c(3:end,49)),500,255);
%%fft of P4 Channel
[aa4] = daqdocfft(cell2mat(c(3:end,53)),500,255);
cnt1=0;
cnt2=0;
cnt3=0;
cnt4=0;
    if(aa1<4)  
    disp('Cz is a delta frequency band')
    cnt1=cnt1+1;
    end
    if(aa2<4)  
    disp('Fz is a delta frequency band')
    cnt1=cnt1+1;
    end
    if(aa3<4)  
    disp('P3 is a delta frequency band')
    cnt1=cnt1+1;
    end
    if(aa4<4)  
    disp('P4 is a delta frequency band')
    cnt1=cnt1+1;
    end
if(aa1>=5 && aa1<=7)
    disp('Cz is a theta frequency band') 
    cnt2=cnt2+1;
end
if(aa2>=5 && aa2<=7)
    disp('Fz is a theta frequency band') 
     cnt2=cnt2+1;
end
if(aa3>=5 && aa3<=7)
    disp('P3 is a theta frequency band') 
     cnt2=cnt2+1;
end
if(aa4>=5 && aa4<=7)
    cnt2=cnt2+1;
    disp('P4 is a theta frequency band') 
end
if(aa1>=8 && aa1<=13)
     cnt3=cnt3+1;
    disp('Cz is a alpha frequency band') 
end
if(aa2>=8 && aa2<=13)
    cnt3=cnt3+1;
    disp('Fz is a alpha frequency band') 
end
if(aa3>=8 && aa3<=13)
    cnt3=cnt3+1;
    disp('P3 is a alpha frequency band') 
end
if(aa4>=8 && aa4<=13)
    cnt3=cnt3+1;
    disp('P4 is a alpha frequency band') 
end
if(aa1>=14 && aa1<=30)
    cnt4=cnt4+1;
    disp('Cz is a Beta frequency band') 
end
if(aa2>=14 && aa2<=30)
       cnt4=cnt4+1;
    disp('Fz is a Beta frequency band') 
end
if(aa3>=14 && aa3<=30)
       cnt4=cnt4+1;
    disp('P3 is a Beta frequency band') 
end
if(aa4>=14 && aa4<=30)
       cnt4=cnt4+1;
    disp('P4 is a Beta frequency band') 
end

if(cnt1>cnt2)&&(cnt1>cnt3)&&(cnt1>cnt4)
    disp('State of mind-deep sleep, when awake pathological')
elseif(cnt2>cnt1)&&(cnt2>cnt3)&&(cnt2>cnt4)
    disp('State of mind-creativity, falling asleep')
elseif(cnt3>cnt1)&&(cnt3>cnt2)&&(cnt3>cnt4)    
    disp('State of mind-relaxation, closed eyes')
elseif(cnt4>cnt1)&&(cnt4>cnt2)&&(cnt4>cnt3)    
    disp('State of mind-concentration, logical and analytical thinking, fidget') 
else
    disp(('cannot say'))
end