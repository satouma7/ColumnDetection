function varargout = eval_columnPCP_GUI(varargin)
% eval_columnPCP_GUI MATLAB code for eval_columnPCP_GUI.fig
%      eval_columnPCP_GUI, by itself, creates a new eval_columnPCP_GUI or raises the existing
%      singleton*.
%
%      H = eval_columnPCP_GUI returns the handle to a new eval_columnPCP_GUI or the handle to
%      the existing singleton*.
%
%      eval_columnPCP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eval_columnPCP_GUI.M with the given input arguments.
%
%      eval_columnPCP_GUI('Property','Value',...) creates a new eval_columnPCP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eval_columnPCP_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eval_columnPCP_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eval_columnPCP_GUI

% Last Modified by GUIDE v2.5 29-May-2020 14:52:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eval_columnPCP_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @eval_columnPCP_GUI_OutputFcn, ...
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


% --- Executes just before eval_columnPCP_GUI is made visible.
function eval_columnPCP_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eval_columnPCP_GUI (see VARARGIN)
global imgori imgcrop
state_switch('free',handles);

filelist = ls(fullfile('nnPCP','*.mat'));
set(handles.cpselect,'String',filelist);

filelist = ls(fullfile('LSMdata_paper','*.lsm'));
%filelist = ls(fullfile('*.lsm'));
set(handles.lsmselect,'String',filelist);

contens = cellstr(get(handles.cpselect,'String'));
cpPath = fullfile('nnPCP',contens{get(handles.cpselect,'Value')});
handles.cppath = cpPath;

contents = cellstr(get(handles.lsmselect,'String'));
imgPath = fullfile('LSMdata_paper',contents{get(handles.lsmselect,'Value')});
handles.imgpath = imgPath;
handles.iminf = lsmread(handles.imgpath,'InfoOnly');

Zmax=handles.iminf.dimZ;Z=round(Zmax/2);
Cmax=handles.iminf.dimC;
set(handles.zslider,'Value',Z);
set(handles.zedit,'String',Z);
set(handles.zslider,'Min',1);
set(handles.zslider,'Max',Zmax);
set(handles.minlabel,'String',1);
set(handles.maxlabel,'String',Zmax);
set(handles.zslider,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.cslider,'Value',1);
set(handles.cslider,'Min',1);
set(handles.cslider,'Max',Cmax);
set(handles.cslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
set(handles.cvalue,'Value',1);
set(handles.cvalue,'String',1);

set(handles.Lslider,'Value',0.5);
set(handles.Lvalue,'String',0.5);
set(handles.Oslider,'Value',0.4);
set(handles.Ovalue,'Value',0.4);
set(handles.Ovalue,'String',0.4);

handles.X1=151;handles.X2=350;handles.Y1=101;handles.Y2=200;
set(handles.Xslider1,'Value',handles.X1);
set(handles.Xslider2,'Value',handles.X2);
set(handles.Yslider1,'Value',handles.Y1);
set(handles.Yslider2,'Value',handles.Y2);
set(handles.X1value,'String',handles.X1);
set(handles.X2value,'String',handles.X2);
set(handles.Y1value,'String',handles.Y1);
set(handles.Y2value,'String',handles.Y2);

handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 1 1 Z Z]));
Bthreshold=get(handles.Bslider,'Value');
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

axes(handles.normal_img1);imshow(imread('image002_10a.tif'));
axes(handles.normal_img2);imshow(imread('image003_10a.tif'));
axes(handles.normal_img3);imshow(imread('image006_10a.tif'));
axes(handles.normal_img4);imshow(imread('image012_10a.tif'));



% Choose default command line output for eval_columnPCP_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eval_columnPCP_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eval_columnPCP_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lsmselect.
function lsmselect_Callback(hObject, eventdata, handles)
% hObject    handle to lsmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori
contents = cellstr(get(hObject,'String'));
imgPath = fullfile('LSMdata_paper',contents{get(hObject,'Value')});
handles.imgpath = imgPath;
handles.iminf = lsmread(handles.imgpath,'InfoOnly');
Zmax=handles.iminf.dimZ;Z=round(Zmax/2);
Cmax=handles.iminf.dimC;C=1;
set(handles.zslider,'Value',Z);
set(handles.zedit,'String',Z);
set(handles.zslider,'Min',1);
set(handles.zslider,'Max',Zmax)
set(handles.minlabel,'String',1);
set(handles.maxlabel,'String',Zmax);
set(handles.zslider,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.cslider,'Value',1);
set(handles.cslider,'Min',1);
set(handles.cslider,'Max',Cmax);
if Cmax~=1
    set(handles.cslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
end
set(handles.cvalue,'Value',1);
set(handles.cvalue,'String',1);

Bthreshold=get(handles.Bslider,'Value');
handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

guidata(hObject,handles);


% Hints: contents = cellstr(get(hObject,'String')) returns lsmselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lsmselect


% --- Executes during object creation, after setting all properties.
function lsmselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function zslider_Callback(hObject, eventdata, handles)
% hObject    handle to zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori

Z = round(get(hObject,'Value'));
set(handles.zslider,'Value',Z);
set(handles.zedit,'String',num2str(Z));
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));
%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
guidata(hObject,handles);

axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function zslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function zedit_Callback(hObject, eventdata, handles)
% hObject    handle to zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori

val = str2double(get(hObject,'String'));
if (val<1) || (get(handles.zslider,'Max')<val)
     val = 1;
     set(handles.zedit,'String','1');
end
set(handles.zslider,'Value',val);
handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 1 1 val val]));
Bthreshold=get(handles.Bslider,'Value');
%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
guidata(hObject,handles);

axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);


% Hints: get(hObject,'String') returns contents of zedit as text
%        str2double(get(hObject,'String')) returns contents of zedit as a double


% --- Executes during object creation, after setting all properties.
function zedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cpselect.
function cpselect_Callback(hObject, eventdata, handles)
% hObject    handle to cpselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contens = cellstr(get(hObject,'String'));
cpPath = fullfile('nnPCP',contens{get(hObject,'Value')});
handles.cppath = cpPath;

guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns cpselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpselect


% --- Executes during object creation, after setting all properties.
function cpselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net imgs imgori imgcrop list Flist L total
state_switch('busy',handles);
 
load(handles.cppath);
Z=get(handles.zslider,'Value');
C=round(get(handles.cslider,'Value'));
imgori=squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));

Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);%
imgcropA=imgcrop;
imgcropA=imadjust(imgcropA,stretchlim(imgcropA,[Bthreshold/200 1-Bthreshold/200]));%

[height,width] = size(imgcrop);
ws = 32;
area = ws * ws;
cor = round(ws/2);
stride = 3;
detectionthreshold=get(handles.Dslider,'Value');
overlapthreshold=get(handles.Oslider,'Value');

wn = floor((width-ws)/stride+1);%161
hn = floor((height-ws)/stride+1);%161

imgs = uint8(zeros(32,32,1,wn*hn));imgsA = uint8(zeros(32,32,1,wn*hn));
list = zeros(wn*hn,8);%25921

for m=1:hn%161
    j=(m-1)*stride+1;%Y
    for n=1:wn%161
       i=(n-1)*stride+1;%X
        imgsA(:,:,1,(m-1)*wn+n) = imgcropA(j:j+ws-1,i:i+ws-1);%
        imgs(:,:,1,(m-1)*wn+n) = imgcrop(j:j+ws-1,i:i+ws-1);%
        imgs(:,:,1,(m-1)*wn+n) = imadjust(imgs(:,:,1,(m-1)*wn+n),stretchlim(imgs(:,:,1,(m-1)*wn+n),[Bthreshold/200 1-Bthreshold/200]));%
        list((m-1)*wn+n,1) = i+cor-1;%X axis
        list((m-1)*wn+n,2) = j+cor-1;%Y axis
        list((m-1)*wn+n,3) = (m-1)*wn+n;%ID
    end
end

[~,score] = classify(net,imgs);%
[~,scoreA] = classify(net,imgsA);%
list(:,4) = 1-scoreA(:,1);%back
list(:,5) = score(:,2);%norm
list(:,6) = score(:,3);%gap
list(:,7) = score(:,4);%nohole
%list(:,8) = score(:,5);%out of focus
list((list(:,4)<detectionthreshold),:) = []; 
list = sortrows(list,4,'descend');

figure('Position',[0 900 2550 400]);
[a name1 c]=fileparts(handles.imgpath);
[a name2 c]=fileparts(handles.cppath);

%imgcrop=imadjust(imgcrop,stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]));%
subplot(1,3,1);imshow(imgcropA);title(strcat(name1,' :',name2),'Interpreter','none');
subplot(1,3,2);imshow(imgcropA);title(strcat('width=',num2str(width),' :height=',num2str(height),' :z=',num2str(Z),' :Mag=',num2str(Mag)),'Interpreter','none');

count = 1;%count: 
while(count<size(list,1))
    x = list(count,1);%
    y = list(count,2);%
    n = count+1;%n:
    while(n<=size(list,1))
        nx = list(n,1);%
        ny = list(n,2);%
        x1 = max([x nx])-ws/2;%
        y1 = max([y ny])-ws/2;%
        x2 = min([x nx])+ws/2;%
        y2 = min([y ny])+ws/2;%
        w = x2-x1+1;%
        h = y2-y1+1;%
        if (w>0) && (h>0)
            overlap = w*h / area;%
            if overlap > overlapthreshold
               list(n,:) = [];%
                n = n-1;
            end
        end
        n = n+1;
    end
    count = count+1;
end

list = sortrows(list,1,'ascend');
list = sortrows(list,2,'ascend');
total=size(list,1);

hold on;
plot(list(:,1),list(:,2),'or');
plabels=1:total;plabels=plabels';%
text(list(:,1),list(:,2),num2str(plabels),'Color','b','FontWeight','bold','FontSize',10);%
hold off;

subplot(1,3,3);imshow(imgcropA);title(strcat('n=',num2str(total),' :Detection=',num2str(detectionthreshold),' :Overlap=',num2str(overlapthreshold),' :Brightness=',num2str(Bthreshold) ));

hold on;
L=get(handles.Lslider,'Value');%1/2;
R=30;Rx=R/2*sqrt(2);
Flist=zeros(total,4);
for i=1:total
    F=activations(net,imgs(:,:,1,list(i,3)),13);
    E1=exp(L*F(1));E2=exp(L*F(2));E3=exp(L*F(3));E4=exp(L*F(4));bunbo=E1+E2+E3+E4;
    X0=E1/bunbo;X1=E2/bunbo;X2=E3/bunbo;X3=E4/bunbo;%X1 normal:X2 gap:X3 nohole
    Flist(i,1)=X1;Flist(i,2)=X2;Flist(i,3)=X3;
    x=list(i,1);y=list(i,2);
    patch([x-12 x-6 x-6 x-12],[y+12 y+12 y+12-round(X1*30) y+12-round(X1*30)],'w');
    patch([x-6 x x x-6],[y+12 y+12 y+12-round(X2*30) y+12-round(X2*30)],'r');
    patch([x x+6 x+6 x],[y+12 y+12 y+12-round(X3*30) y+12-round(X3*30)],'b');
    %patch([x+6 x+12 x+12 x+6],[y+12 y+12 y+12-round(X4*30) y+12-round(X4*30)],'g');
end
hold off;

% figure('Position',[900 200 1000 300]);
% subplot(1,3,1);h1=histogram(Flist(:,1));h1.BinLimits=[0 1];h1.NumBins=20;h1.FaceColor='w';title(strcat('Lamda=',num2str(L),' :normal'));
% subplot(1,3,2);h2=histogram(Flist(:,2));h2.BinLimits=[0 1];h2.NumBins=20;h2.FaceColor='r';title('gap');
% subplot(1,3,3);h3=histogram(Flist(:,3));h3.BinLimits=[0 1];h3.NumBins=20;h3.FaceColor='b';title('nohole');
% Nmax=max([max(h1.Values) max(h2.Values) max(h3.Values)]);
% subplot(1,3,1);ylim([0 Nmax]);
% subplot(1,3,2);ylim([0 Nmax]);
% subplot(1,3,3);ylim([0 Nmax]);

% h1=histogram(Flist(:,1));h1.BinLimits=[0 1];h1.NumBins=20;h1.FaceColor='y';title('normal');
% hold on;
% h2=histogram(Flist(:,2));h2.BinLimits=[0 1];h2.NumBins=20;h2.FaceColor='r';title('gap');
% h3=histogram(Flist(:,3));h3.BinLimits=[0 1];h3.NumBins=20;h3.FaceColor='b';title('nohole');
% Nmax=max([max(h1.Values) max(h2.Values) max(h3.Values)]);
% ylim([0 Nmax]);
% hold off;

state_switch('free',handles);
guidata(hObject,handles);

function state_switch(state,handles)

switch(state)
    case 'busy'
        set(handles.cpselect,'Enable','off');
        set(handles.lsmselect,'Enable','off');
        set(handles.zedit,'Enable','off');
        set(handles.zslider,'Enable','off');
        set(handles.startbutton,'Enable','off');
        set(handles.rotbutton,'Enable','off');
    case 'free'
        set(handles.cpselect,'Enable','on');
        set(handles.lsmselect,'Enable','on');
        set(handles.zedit,'Enable','on');
        set(handles.zslider,'Enable','on');
        set(handles.startbutton,'Enable','on');
        set(handles.rotbutton,'Enable','on');
end


% --- Executes on slider movement.
function Xslider1_Callback(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.X1=round(get(hObject,'Value'));
if handles.X1>=handles.X2
    handles.X1=handles.X2-1;
end
set(handles.Xslider1,'Value',handles.X1);
set(handles.X1value,'String',handles.X1);

guidata(hObject,handles);

Bthreshold=get(handles.Bslider,'Value');
%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);

hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Xslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Xslider2_Callback(hObject, eventdata, handles)
% hObject    handle to Xslider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.X2=round(get(hObject,'Value'));
if handles.X2<=handles.X1
    handles.X2=handles.X1+1;
end
set(handles.Xslider2,'Value',handles.X2);
set(handles.X2value,'String',handles.X2);
guidata(hObject,handles);

Bthreshold=get(handles.Bslider,'Value');
%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));

axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Xslider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xslider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Yslider1_Callback(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Y1=round(get(hObject,'Value'));
if handles.Y1>=handles.Y2
    handles.Y1=handles.Y2-1;
end
set(handles.Yslider1,'Value',handles.Y1);
set(handles.Y1value,'String',handles.Y1);
guidata(hObject,handles);

Bthreshold=get(handles.Bslider,'Value');
%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Yslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Yslider2_Callback(hObject, eventdata, handles)
% hObject    handle to Yslider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Y2=round(get(hObject,'Value'));
if handles.Y2<=handles.Y1
    handles.Y2=handles.Y1+1;
end
set(handles.Yslider2,'Value',handles.Y2);
set(handles.Y2value,'String',handles.Y2);
guidata(hObject,handles);

Bthreshold=get(handles.Bslider,'Value');
%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Yslider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yslider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in rotbutton.
function rotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to rotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.img = rot90(handles.img);

X1=handles.X1;X2=handles.X2;Y1=handles.Y1;Y2=handles.Y2;
handles.X1=512-Y2;handles.X2=512-Y1;handles.Y1=X1;handles.Y2=X2;
set(handles.Xslider1,'Value',handles.X1);
set(handles.Xslider2,'Value',handles.X2);
set(handles.Yslider1,'Value',handles.Y1);
set(handles.Yslider2,'Value',handles.Y2);
set(handles.X1value,'String',handles.X1);
set(handles.X2value,'String',handles.X2);
set(handles.Y1value,'String',handles.Y1);
set(handles.Y2value,'String',handles.Y2);

Bthreshold=get(handles.Bslider,'Value');
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

guidata(hObject,handles);


% --- Executes on slider movement.
function Dslider_Callback(hObject, eventdata, handles)
% hObject    handle to Dslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Dthreshold=round(get(hObject,'Value'),2);
set(handles.Dslider,'Value',Dthreshold);
set(handles.Dvalue,'String',Dthreshold);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Dslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Oslider_Callback(hObject, eventdata, handles)
% hObject    handle to Oslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Othreshold=round(get(hObject,'Value'),2);
set(handles.Oslider,'Value',Othreshold);
set(handles.Ovalue,'String',Othreshold);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Oslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Bslider_Callback(hObject, eventdata, handles)
% hObject    handle to Bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Bthreshold=round(get(hObject,'Value'),2);
set(handles.Bslider,'Value',Bthreshold);
set(handles.Bvalue,'String',Bthreshold);

%imgori=imadjust(handles.img,[0 Bthreshold]);
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Bslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Mslider_Callback(hObject, eventdata, handles)
% hObject    handle to Mslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Mag=round(get(hObject,'Value'),2);
set(handles.Mslider,'Value',Mag);
set(handles.Mvalue,'String',Mag);

Bthreshold=get(handles.Bslider,'Value');
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Mslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global list Flist Elist filename total

%total=size(list,1);
Elist=zeros(total,7);
Elist(:,1)=1:total;%ID
Elist(:,2)=list(:,1);%X
Elist(:,3)=list(:,2);%Y
Elist(:,4:7)=Flist(:,1:4);%evaluation

[filepath,filename,ext]=fileparts(handles.imgpath);
filename=strcat(filename,'_', datestr(now, 'mmdd_HHMM'), '.xls');%
filename=fullfile(filepath,filename);%
xlswrite(filename, Elist);%


% --- Executes on slider movement.
function Lslider_Callback(hObject, eventdata, handles)
% hObject    handle to Lslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
L=round(get(hObject,'Value'),2);
set(handles.Lslider,'Value',L);
set(handles.Lvalue,'String',L);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Lslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgs total list

for I=1:total
    filename=strcat('detected_CNN\Column_Image_',num2str(I),'.tif');%
    imwrite(imgs(:,:,1,list(I,3)),filename);
end

% --- Executes on slider movement.
function cslider_Callback(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
C=round(get(hObject,'Value'));
set(handles.cslider,'Value',C);
set(handles.cvalue,'String',C);
set(handles.cvalue,'String',C);
Z = round(get(handles.zslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
handles.img = squeeze(lsmread(handles.imgpath,'Range',[1 1 C C Z Z]));
imgori=imadjust(handles.img,stretchlim(handles.img,[Bthreshold/200 1-Bthreshold/200]));
guidata(hObject,handles);

axes(handles.main_img);imshow(imgori);
hold on;
patch([handles.X1 handles.X2 handles.X2 handles.X1],[512-handles.Y1 512-handles.Y1 512-handles.Y2 512-handles.Y2],'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(513-handles.Y2:513-handles.Y1,handles.X1:handles.X2),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>370
    X1=fix((Xcrop-370)/2)+1;
    imgcrop=imgcrop(:,X1:X1+369);
end
if Ycrop>220
    Y1=fix((Ycrop-220)/2)+1;
    imgcrop=imgcrop(Y1:Y1+219,:);
end
if Xcrop<370
    imgcrop(:,Xcrop+1:370)=0;
end
if Ycrop<220
    imgcrop(Ycrop+1:220,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function cslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
