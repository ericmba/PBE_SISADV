function varargout = Class_D_Amplifier_Interface(varargin)
% CLASS_D_AMPLIFIER_INTERFACE MATLAB code for Class_D_Amplifier_Interface.fig
%      CLASS_D_AMPLIFIER_INTERFACE, by itself, creates a new CLASS_D_AMPLIFIER_INTERFACE or raises the existing
%      singleton*.
%
%      H = CLASS_D_AMPLIFIER_INTERFACE returns the handle to a new CLASS_D_AMPLIFIER_INTERFACE or the handle to
%      the existing singleton*.
%
%      CLASS_D_AMPLIFIER_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASS_D_AMPLIFIER_INTERFACE.M with the given input arguments.
%
%      CLASS_D_AMPLIFIER_INTERFACE('Property','Value',...) creates a new CLASS_D_AMPLIFIER_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Class_D_Amplifier_Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Class_D_Amplifier_Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Class_D_Amplifier_Interface

% Last Modified by GUIDE v2.5 31-Oct-2018 23:31:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Class_D_Amplifier_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Class_D_Amplifier_Interface_OutputFcn, ...
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


% --- Executes just before Class_D_Amplifier_Interface is made visible.
function Class_D_Amplifier_Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Class_D_Amplifier_Interface (see VARARGIN)

% Choose default command line output for Class_D_Amplifier_Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Class_D_Amplifier_Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Class_D_Amplifier_Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    % hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fc=str2num(get(handles.edit2,'string'));
ftwave=fc*150;

cycles=15;
N=ceil(50000/fc)*cycles;

Q=200;   %Quality factor(24 is random)
fs=ftwave*Q; 
t=0:1/fs:N*(1/ftwave);

G=str2num(get(handles.edit3,'string'));    %Gain of the Amplifier

A_sin=1;    %Amplitude Audio Signal

R_L = str2num(get(handles.edit4,'string'));               
L = str2num(get(handles.edit5,'string'));      
C = str2num(get(handles.edit6,'string'));  

y=A_sin*sin(2*pi*fc*t);
tri=triangular(2*pi*ftwave*t);

axes(handles.axes1); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(t,tri,t,y);
axis([0 1e-3 -1 1])
title('Etapa comparadora');
xlabel('Time');
ylabel('Triangular wave vs. y');


out=zeros(size(y));

for i=1:length(t)
    if (y(i)>tri(i))
        out(i)=1;
    else
        out(i)=-1;
    end
end

axes(handles.axes2); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(t,out);
xlim([0 1/fc]);
title('Comparator')
xlabel('Time');
ylabel('Comp');

Nfft=2^nextpow2(100000);

Yfft=fft(y,Nfft)/length(y);
TRIfft=fft(tri,Nfft)/length(tri);
OUTfft=fft(out,Nfft)/length(out);

f=fs/2*linspace(0,1,Nfft/2+1);

axes(handles.axes3); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(f,2*abs(Yfft(1:length(f))));
xlim([0 10*fc]);
title('Audio Transform');
xlabel('Frequency');
ylabel('|Yfft|');

axes(handles.axes4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(f,2*abs(TRIfft(1:length(f))));
xlim([0 4*ftwave]);
title('Transformada Triangular');
xlabel('Frequency');
ylabel('|TRIfft|');

axes(handles.axes5); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(f,2*abs(OUTfft(1:length(f))));
xlim([0 2*ftwave]);
title('Transformada Comparador');
xlabel('Frequency');
ylabel('|OUTfft|');

for i = 1:length(out)
    Vout(i)=G*out(i);
end

axes(handles.axes6); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(t,Vout);
xlim([0 1/fc]);
title('Power Amplifier');
xlabel('Time');
ylabel('Vout');

Voutfft=fft(Vout,Nfft)/length(Vout);
axes(handles.axes7); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(f,2*abs(Voutfft(1:length(f))));
xlim([0 2*ftwave]);
title('Power Amplifier Transform');
xlabel('Frequency');
ylabel('|Voutfft|');

w0=1/sqrt(L*C);
Tc=1/fs;
a=w0^2.*[1 2 1];
b=[(4/(Tc^2))+(2/(Tc*R_L*C))+w0^2 2*w0^2-(8/(Tc^2)) (4/(Tc^2))-(2/(Tc*R_L*C))+w0^2];

output=filter(a,b,Vout);

axes(handles.axes8); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(t,output);

title('output final');
xlabel('t');
ylabel('Output');
xlim([0 5/fc]);




    
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function freq_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gain_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function C_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function C_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
