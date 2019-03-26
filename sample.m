function varargout = sample(varargin)
% SAMPLE MATLAB code for sample.fig
%      SAMPLE, by itself, creates a new SAMPLE or raises the existing
%      singleton*.
%
%      H = SAMPLE returns the handle to a new SAMPLE or the handle to
%      the existing singleton*.
%
%      SAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE.M with the given input arguments.
%
%      SAMPLE('Property','Value',...) creates a new SAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sample

% 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sample is made visible.
function sample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sample (see VARARGIN)

% Choose default command line output for sample
handles.output = hObject;
warning off
clc
imaqreset
set(handles.cmd_start_cam,'Enable','On');
set(handles.cmd_stop_cam,'Enable','Off');
set(handles.cmd_start,'Enable','Off');
set(handles.cmd_stop,'Enable','Off');
set(handles.cmd_train,'Enable','Off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sample wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sample_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cmd_start.
function cmd_start_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
% ser = handles.ser;
% fopen(ser)
set(handles.cmd_start_cam,'Enable','Off');
set(handles.cmd_stop_cam,'Enable','On');
set(handles.cmd_start,'Enable','Off');
set(handles.cmd_stop,'Enable','On');
set(handles.cmd_train,'Enable','Off');
vidobj = handles.vidobj;
left = handles.left;
right = handles.right;
mouth = handles.mouth;
C_nn1 = 0;
sttr = 'n';
left_corner = 0;
right_corner = 0;
loop = 3;
test_loop = 50;
f_count = 0;
l_band = 300;
r_band = 300;
m_band = 300;
left1 = 0;
right1 = 0;
t_min = 0;
t_max = 20;
while (get(handles.cmd_stop,'UserData')==1)
I = getsnapshot(vidobj);
tic
detector = buildDetector();
[bbox bbimg faces bbfaces] = detectFaceParts(detector,I,1);
BLE = bbox(:, 5: 8);
BRE = bbox(:, 9:12);
BNN = bbox(:,13:16);
if (isempty(bbox) == 0) 
    BLE = BLE(1,:);
    BRE = BRE(1,:);
    BNN = BNN(1,:);

    sle = sum(BLE);
    sre = sum(BRE);
    snn = sum(BNN);
     strr = 'y';
    
if (sle ~=0) && (sre ~=0) && (snn ~=0) 
     strr = 'y';
else
     strr = 'n';
end
else
    strr = 'n';

end

if strr == 'y'
    
axes(handles.axes1)
imshow(I); hold on
rectangle('Position',BLE,'LineWidth',4,'LineStyle','-','EdgeColor','y'); hold on
rectangle('Position',BRE,'LineWidth',4,'LineStyle','-','EdgeColor','y'); hold on
rectangle('Position',BNN,'LineWidth',4,'LineStyle','-','EdgeColor','y'); hold on
toc
I_le = I(BLE(2):BLE(2)+BLE(4),(BLE(1):BLE(1)+BLE(3)),:);
B_le = rgb2gray(I_le);
T_le = roicolor(B_le,t_min,t_max);

C_le = corner(T_le,4);
if isempty(C_le)
    C_le = C_le1;
else
    C_le1 = C_le;
end
% figure;
% imshow(I_le);
% hold on
% plot(C_le(:,1), C_le(:,2), 'r*');

le_c_min = min(C_le(:,1));
le_c_max = max(C_le(:,1));
le_r_min = min(C_le(:,2));
le_r_max = max(C_le(:,2));

le_length = le_c_max - le_c_min;
le_breadth = le_r_max - le_r_min;

le_area = le_length * le_breadth;
% left_corner = left_corner + le_area;

I_re = I(BRE(2):BRE(2)+BRE(4),(BRE(1):BRE(1)+BRE(3)),:);
B_re = rgb2gray(I_re);
T_re = roicolor(B_re,t_min,t_max+10);

C_re = corner(T_re,4);
if isempty(C_re)
    C_re = C_re1;
else
    C_re1 = C_re;
end
% figure;
% imshow(I_re);
% hold on
% plot(C_re(:,1), C_re(:,2), 'r*');

re_c_min = min(C_re(:,1));
re_c_max = max(C_re(:,1));
re_r_min = min(C_re(:,2));
re_r_max = max(C_re(:,2));

re_length = re_c_max - re_c_min;
re_breadth = re_r_max - re_r_min;

re_area = re_length * re_breadth;

I_nn = I(BNN(2):BNN(2)+BNN(4),(BNN(1):BNN(1)+BNN(3)),:);
B_nn = rgb2gray(I_nn);
T_nn = roicolor(B_nn,t_min,t_max);

C_nn = corner(B_nn,4);
if isempty(C_nn)
    C_nn = C_nn1;
else
    C_nn1 = C_nn;
end
% figure;
% imshow(I_nn);
% hold on
% plot(C_nn(:,1), C_nn(:,2), 'r*');

nn_c_min = min(C_nn(:,1));
nn_c_max = max(C_nn(:,1));
nn_r_min = min(C_nn(:,2));
nn_r_max = max(C_nn(:,2));

nn_length = nn_c_max - nn_c_min;
nn_breadth = nn_r_max - nn_r_min;

nn_area = nn_length * nn_breadth;


% right_corner = right_corner + re_area;
t = ['Trained: ' num2str(left) ' : ' num2str(right) ' : ' num2str(mouth)];
r = ['Current: ' num2str(le_area) ' : ' num2str(re_area) ' : ' num2str(nn_area)];

left1 = left - le_area;
right1 = right - re_area;
mouth1 = mouth - nn_area;
v = ['Difference: ' num2str(left1) ' : ' num2str(right1) ' : ' num2str(mouth1)];
disp(t)
disp(r)
disp(v)

%%%% eeg start
load('SVM_Classifier.mat','trainedClassifier','DATASET_NEW','DATASET');
Val = randi(size(DATASET,1),1);
Reading = DATASET(Val,:);

label = trainedClassifier.predictFcn(DATASET_NEW(Val,1:21));
axes(handles.axes3)
plot(Reading)
xlabel('time');
ylabel('Amplitude')
%title('EEG signal')
axis ( [1 178 min(min(DATASET)) max(max(DATASET))] )
grid on
if(label==1)
    eeg = 1;
    %title('The patient can get epeleptic seizures in future')
%     disp('The patient eyes are closed')
%     set(handles.lbl_status1,'string','Drowsiness Detected!!! The patient eyes are closed');
else
    eeg = 0;
    
    %title('The Patient is healthy')
%     disp('The Patient eyes are open')
%     set(handles.lbl_status1,'string','The Patient eyes are open');
end


%%%% eeg stop

if ((le_area < left + l_band) && (le_area > left - l_band)) && ((re_area < right + r_band) && (re_area > right - r_band)) && ((nn_area < mouth + m_band) && (nn_area > mouth - m_band)) && (le_area ~= 0) && (re_area ~= 0) 
    f_count = 0;
    disp('Reset')
    set(handles.lbl_status1,'string','The Patient eyes are open');

   set(handles.lbl_status2,'string','Normal Condition');
else
    f_count = f_count + 1;
    disp('Detected')
    eeg = 1;
    %title('The patient can get epeleptic seizures in future')
%     disp('The patient eyes are closed')
%     set(handles.lbl_status1,'string','Drowsiness Detected!!! The patient eyes are closed');
end

if f_count == 3

   set(handles.lbl_status2,'string','Drowsiness Detected.');
   tts('Drowsiness Detected.') 
   eeg = 1;
    %title('The patient can get epeleptic seizures in future')
%     disp('The patient eyes are closed')
    set(handles.lbl_status1,'string','Drowsiness Detected!!! The patient eyes are closed');
elseif f_count == 4
    eeg = 1;
    %title('The patient can get epeleptic seizures in future')
%     disp('The patient eyes are closed')
    set(handles.lbl_status1,'string','Drowsiness Detected!!! The patient eyes are closed');
elseif f_count > 5

   set(handles.lbl_status2,'string','Drowsiness Detected.');
   tts('Drowsiness Detected.') 
    eeg = 1;
    %title('The patient can get epeleptic seizures in future')
%     disp('The patient eyes are closed')
    set(handles.lbl_status1,'string','Drowsiness Detected!!! The patient eyes are closed');
end
else
    disp('Face not detected.')
end
    
end    


handles.sttr = sttr;
guidata(hObject, handles);

% --- Executes on button press in cmd_stop.
function cmd_stop_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
vidobj = handles.vidobj;
% sttr = 'y';
% disp('Tracking Stop');
set(handles.cmd_start_cam,'Enable','On');
set(handles.cmd_stop_cam,'Enable','Off');
set(handles.cmd_start,'Enable','Off');
set(handles.cmd_stop,'Enable','Off');
set(handles.cmd_stop,'UserData',0);

handles.sttr = sttr;
guidata(hObject, handles);


% --- Executes on button press in cmd_start_cam.
function cmd_start_cam_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_start_cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
axes(handles.axes2)
set(handles.cmd_stop,'UserData',1);
vidobj = videoinput('winvideo',2,'YUY2_320x240');    
set(vidobj,'ReturnedColorSpace','RGB');   % setting the properties of object
set(vidobj,'FramesPerTrigger',1);       
set(vidobj,'TriggerRepeat',inf);        
triggerconfig(vidobj,'manual');  
videoRes = get(vidobj, 'VideoResolution');
numberOfBands = get(vidobj, 'NumberOfBands');
handleToImage = image( zeros([videoRes(2), videoRes(1), numberOfBands], 'uint8') );
start(vidobj);
axes(handles.axes2);
% preview(vidobj)
preview(vidobj,handleToImage)
pause(5);
set(handles.cmd_start_cam,'Enable','Off');
set(handles.cmd_stop_cam,'Enable','On');
set(handles.cmd_start,'Enable','Off');
set(handles.cmd_stop,'Enable','Off');
set(handles.cmd_train,'Enable','On');
handles.vidobj = vidobj;
handles.videoRes = videoRes;
handles.numberOfBands = numberOfBands;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in cmd_stop_cam.
function cmd_stop_cam_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_stop_cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
ser = handles.ser;
% fclose(ser)
vidobj = handles.vidobj;
videoRes = handles.videoRes;
numberOfBands = handles.numberOfBands;
axes(handles.axes2);
blank = image(zeros([videoRes(2), videoRes(1), numberOfBands], 'uint8') );
imshow(blank);
stoppreview(vidobj);
stop(vidobj);
clc
set(handles.cmd_start_cam,'Enable','On');
set(handles.cmd_stop_cam,'Enable','Off');
set(handles.cmd_start,'Enable','Off');
set(handles.cmd_stop,'Enable','Off');
guidata(hObject, handles);

% --- Executes on button press in cmd_train.
function cmd_train_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
vidobj = handles.vidobj;
set(handles.cmd_start_cam,'Enable','Off');
set(handles.cmd_stop_cam,'Enable','On');
set(handles.cmd_start,'Enable','On');
set(handles.cmd_stop,'Enable','Off');
set(handles.cmd_train,'Enable','Off');
left_corner = 0;
right_corner = 0;
mouth_corner = 0;
loop = 3;
test_loop = 50;
f_count = 0;
l_band = 300;
r_band = 300;
left1 = 0;
right1 = 0;
t_min = 0;
t_max = 20;
tts('Training Started.')
for i = 1:loop
I = getsnapshot(vidobj);
% imshow(I)
tic
detector = buildDetector();
[bbox bbimg faces bbfaces] = detectFaceParts(detector,I,1);
BLE = bbox(:, 5: 8);
BRE = bbox(:, 9:12);
BNN = bbox(:,13:16);
if (isempty(bbox) == 0) 
    BLE = BLE(1,:);
    BRE = BRE(1,:);
    BNN = BNN(1,:);

    sle = sum(BLE);
    sre = sum(BRE);
    snn = sum(BNN);
     strr = 'y';
    
if (sle ~=0) && (sre ~=0) && (snn ~=0) 
     strr = 'y';
else
     strr = 'n';
end
else
    strr = 'n';

end
        
figure; imshow(I); hold on
rectangle('Position',BLE,'LineWidth',4,'LineStyle','-','EdgeColor','y'); hold on
rectangle('Position',BRE,'LineWidth',4,'LineStyle','-','EdgeColor','y'); hold on
rectangle('Position',BNN,'LineWidth',4,'LineStyle','-','EdgeColor','y'); hold on
toc

if strr == 'y'    

I_le = I(BLE(2):BLE(2)+BLE(4),(BLE(1):BLE(1)+BLE(3)),:);
B_le = rgb2gray(I_le);
T_le = roicolor(B_le,t_min,t_max);

C_le = corner(T_le,4);
if isempty(C_le)
    C_le = C_le1;
else
    C_le1 = C_le;
end
% figure;
% imshow(I_le);
% hold on
% plot(C_le(:,1), C_le(:,2), 'r*');

le_c_min = min(C_le(:,1));
le_c_max = max(C_le(:,1));
le_r_min = min(C_le(:,2));
le_r_max = max(C_le(:,2));

le_length = le_c_max - le_c_min;
le_breadth = le_r_max - le_r_min;

le_area = le_length * le_breadth;
left_corner = left_corner + le_area;

I_re = I(BRE(2):BRE(2)+BRE(4),(BRE(1):BRE(1)+BRE(3)),:);
B_re = rgb2gray(I_re);
T_re = roicolor(B_re,t_min,t_max+10);

C_re = corner(T_re,4);
if isempty(C_re)
    C_re = C_re1;
else
    C_re1 = C_re;
end
% figure;
% imshow(I_re);
% hold on
% plot(C_re(:,1), C_re(:,2), 'r*');

re_c_min = min(C_re(:,1));
re_c_max = max(C_re(:,1));
re_r_min = min(C_re(:,2));
re_r_max = max(C_re(:,2));

re_length = re_c_max - re_c_min;
re_breadth = re_r_max - re_r_min;

re_area = re_length * re_breadth;
right_corner = right_corner + re_area;

I_nn = I(BNN(2):BNN(2)+BNN(4),(BNN(1):BNN(1)+BNN(3)),:);
B_nn = rgb2gray(I_nn);
T_nn = roicolor(B_nn,t_min,t_max);

C_nn = corner(B_nn,4);
if isempty(C_nn)
    C_nn = C_nn1;
else
    C_nn1 = C_nn;
end
% figure;
% imshow(I_nn);
% hold on
% plot(C_nn(:,1), C_nn(:,2), 'r*');

nn_c_min = min(C_nn(:,1));
nn_c_max = max(C_nn(:,1));
nn_r_min = min(C_nn(:,2));
nn_r_max = max(C_nn(:,2));

nn_length = nn_c_max - nn_c_min;
nn_breadth = nn_r_max - nn_r_min;

nn_area = nn_length * nn_breadth;
mouth_corner = mouth_corner + nn_area;


end
end
left = left_corner/loop
right = right_corner/loop
mouth = mouth_corner/loop
tts('Training Completed.')
handles.left = left;
handles.right = right;
handles.mouth = mouth;


guidata(hObject, handles);


% --- Executes on button press in cmd_browse.
function cmd_browse_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
[cfilename, c_path] = uigetfile({'*.csv'}, 'Select EEG sample');
filen = strcat(c_path,cfilename);
axes(handles.axes3)
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
%     disp('Cz is a delta frequency band')
    cnt1=cnt1+1;
    end
    if(aa2<4)  
%     disp('Fz is a delta frequency band')
    cnt1=cnt1+1;
    end
    if(aa3<4)  
%     disp('P3 is a delta frequency band')
    cnt1=cnt1+1;
    end
    if(aa4<4)  
%     disp('P4 is a delta frequency band')
    cnt1=cnt1+1;
    end
if(aa1>=5 && aa1<=7)
%     disp('Cz is a theta frequency band') 
    cnt2=cnt2+1;
end
if(aa2>=5 && aa2<=7)
%     disp('Fz is a theta frequency band') 
     cnt2=cnt2+1;
end
if(aa3>=5 && aa3<=7)
%     disp('P3 is a theta frequency band') 
     cnt2=cnt2+1;
end
if(aa4>=5 && aa4<=7)
    cnt2=cnt2+1;
%     disp('P4 is a theta frequency band') 
end
if(aa1>=8 && aa1<=13)
     cnt3=cnt3+1;
%     disp('Cz is a alpha frequency band') 
end
if(aa2>=8 && aa2<=13)
    cnt3=cnt3+1;
%     disp('Fz is a alpha frequency band') 
end
if(aa3>=8 && aa3<=13)
    cnt3=cnt3+1;
%     disp('P3 is a alpha frequency band') 
end
if(aa4>=8 && aa4<=13)
    cnt3=cnt3+1;
%     disp('P4 is a alpha frequency band') 
end
if(aa1>=14 && aa1<=30)
    cnt4=cnt4+1;
%     disp('Cz is a Beta frequency band') 
end
if(aa2>=14 && aa2<=30)
       cnt4=cnt4+1;
%     disp('Fz is a Beta frequency band') 
end
if(aa3>=14 && aa3<=30)
       cnt4=cnt4+1;
%     disp('P3 is a Beta frequency band') 
end
if(aa4>=14 && aa4<=30)
       cnt4=cnt4+1;
%     disp('P4 is a Beta frequency band') 
end

if(cnt1>cnt2)&&(cnt1>cnt3)&&(cnt1>cnt4)
    set(handles.lbl_status1,'string','State of mind-deep sleep, when awake pathological');
elseif(cnt2>cnt1)&&(cnt2>cnt3)&&(cnt2>cnt4)
   	set(handles.lbl_status1,'string','State of mind-creativity, falling asleep');
elseif(cnt3>cnt1)&&(cnt3>cnt2)&&(cnt3>cnt4)    
    set(handles.lbl_status1,'string','State of mind-relaxation, closed eyes');
elseif(cnt4>cnt1)&&(cnt4>cnt2)&&(cnt4>cnt3)    
    set(handles.lbl_status1,'string','State of mind-concentration, logical and analytical thinking, fidget') ;
else
    set(handles.lbl_status1,'string','cannot say');
end

guidata(hObject, handles);
