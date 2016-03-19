function varargout = GUI_face_detection(varargin)
% GUI_FACE_DETECTION M-file for GUI_face_detection.fig
%      GUI_FACE_DETECTION, by itself, creates a new GUI_FACE_DETECTION or raises the existing
%      singleton*.
%
%      H = GUI_FACE_DETECTION returns the handle to a new GUI_FACE_DETECTION or the handle to
%      the existing singleton*.
%
%      GUI_FACE_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FACE_DETECTION.M with the given input arguments.
%
%      GUI_FACE_DETECTION('Property','Value',...) creates a new GUI_FACE_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_face_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_face_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_face_detection

% Last Modified by GUIDE v2.5 21-Dec-2012 13:47:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_face_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_face_detection_OutputFcn, ...
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


% --- Executes just before GUI_face_detection is made visible.
function GUI_face_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_face_detection (see VARARGIN)

% Choose default command line output for GUI_face_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_face_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_face_detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
vid=videoinput('winvideo',1,'RGB24_640x480');
% preview(vid)
src=getselectedsource(vid);
src.FrameRate='10';
triggerconfig(vid, 'Manual');
set(vid,'TriggerRepeat',Inf);
set(vid,'FramesPerTrigger',1);
start(vid);
trigger(vid);
prevframe=getdata(vid,1);
axes(handles.axes1)
imshow(prevframe);

for k=1:500
    trigger(vid);
    frame=getdata(vid,1);
    axes(handles.axes1)
    imshow(frame)
end
stop(vid)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
close(gcf)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
[file path]=uigetfile('309824_2082325974362_1131474595_1734772_936472629_n.jpg','Pilih Gambar');
gbr=imread([path file]);
axes(handles.axes1)
imshow(gbr)
save citrainput.mat gbr


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
load citrainput.mat
gbrycbcr=rgb2ycbcr(gbr); %step 1
cr=gbrycbcr(:,:,3); %step 2
axes(handles.axes1)
imshow(cr)
pause(1)
mask=zeros(size(cr));
axes(handles.axes1)
imshow(mask)
pause(1)
ix=cr > 140 & cr < 150;
mask(ix)=1;
axes(handles.axes1)
imshow(mask)
pause(1)
mask2=bwareaopen(mask,15000);
axes(handles.axes1)
imshow(mask2)
pause(1)
s=regionprops(mask2,'BoundingBox');
bbox=round(cat(1,s.BoundingBox));
box=[];
for k=1:size(bbox,1)
    h=bbox(k,4);
    w=bbox(k,3);
    r=h/w;
    if r>1 && r<2
       box=[box;bbox(k,:)];
    end
end
box(:,4)=0.9*box(:,4);
axes(handles.axes1)
imshow(gbr)
for b=1:size(box,1);
    rectangle('Position',box(b,:),'edgecolor','r')
end

