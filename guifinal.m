function varargout = guifinal(varargin)
% GUIFINAL MATLAB code for guifinal.fig
%      GUIFINAL, by itself, creates a new GUIFINAL or raises the existing
%      singleton*.
%
%      H = GUIFINAL returns the handle to a new GUIFINAL or the handle to
%      the existing singleton*.
%
%      GUIFINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFINAL.M with the given input arguments.
%
%      GUIFINAL('Property','Value',...) creates a new GUIFINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guifinal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guifinal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guifinal

% Last Modified by GUIDE v2.5 03-Jul-2021 12:51:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guifinal_OpeningFcn, ...
                   'gui_OutputFcn',  @guifinal_OutputFcn, ...
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


% --- Executes just before guifinal is made visible.
function guifinal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guifinal (see VARARGIN)

% Choose default command line output for guifinal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guifinal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guifinal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [nama_file,nama_path] = uigetfile({'*.jpg';'*.jpeg';'*.png';});
% if ~isequal(nama_file,0)
%     handles.data1 = imread(fullfile(nama_path,nama_file));
%     guidata(hObject,handles);
%     axes(handles.axes1);
%     imshow(handles.data1);
% else
%     return
% end
[filename,pathname] = uigetfile('*.*');
 
if ~isequal(filename,0)
 
    Img = imread(fullfile(pathname,filename));
    [~,~,m] = size(Img);
    if m == 3
        axes(handles.axes3)
        imshow(Img)
        handles.Img = Img;
        guidata(hObject, handles)
    else
        msgbox('Please insert RGB Image')
    end
else
    return
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
cform = makecform('srgb2lab');
lab = applycform(Img,cform);
handles.lab = lab;
guidata(hObject, handles)
axes(handles.axes1)
imshow(lab)
% disp(lab(1,:,:))

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% index = randperm(num, clusters);
lab = handles.lab;
axes(handles.axes1)
ab = double(lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
% imshow(ab)

jumlah_pixel = nrows * ncols
handles.jumlah_pixel = jumlah_pixel
guidata(hObject, handles)

data_size = size(ab);
% disp (data_size)
num = data_size(1);
nColors = 2;
[cluster_label, step] = k_means_manual(ab,nColors,num);

pixel_labels = reshape(cluster_label,nrows,ncols,[]);
RGB = label2rgb(pixel_labels);
handles.RGB = RGB;
guidata(hObject, handles)
axes(handles.axes1)
imshow(RGB)

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

Img = handles.Img;
% for k = 1:nColors
for k = 1
    color = Img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
%     figure,imshow(segmented_images{k}), title(strcat(['objects in cluster ',num2str(k)]));
end
sgt_img = segmented_images{k==1}
handles.sgt_img = sgt_img
guidata(hObject, handles)
axes(handles.axes1)
% tmpil iterasi
% disp(step)

imshow(segmented_images{k==1});


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.*');
 
if ~isequal(filename,0)
 
    gt = imread(fullfile(pathname,filename));
    [~,~,m] = size(gt);
    if m == 3
        axes(handles.axes2)
        imshow(gt)
        handles.gt = gt;
        guidata(hObject, handles)
    else
        msgbox('Please insert RGB Image')
    end
else
    return
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % imshow(segmented_images{k==1})

sgt_img = handles.sgt_img
axes(handles.axes1)
gray = rgb2gray(sgt_img)
biner = im2bw(gray)
gt = handles.gt
graygt = rgb2gray(gt)
bin = im2bw(graygt)
X = biner;
Y = bin;
% % menampilkan nilai piksel rgb
% disp('====================== k-means ===========================')
% disp(sgt_img)
% disp('====================== ground truth ===========================')
% disp(gt)

% menampilkan gambar biner
% handles.biner = biner;
% axes(handles.axes1)
% imshow(biner)
% % 
% handles.bin = bin;
% axes(handles.axes2)
% imshow(bin)


sumindex = X + Y;
TP = length(find(sumindex == 2));
TN = length(find(sumindex == 0));
substractindex = X - Y;
FN = length(find(substractindex == -1));
FP = length(find(substractindex == 1));
Accuracy = ((TP+TN)/(FN+FP+TP+TN))*100;

% menampilkan baris pada sgt image 
% disp('========== pixel rgb ===========')
% disp(sgt_img(1,:,:))
% fprintf('Akurasi Segmentasi : %f.\n', Accuracy);
set(handles.text2,'String',Accuracy)
