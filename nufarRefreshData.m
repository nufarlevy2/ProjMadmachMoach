function varargout = nufarRefreshData(varargin)
% NUFARREFRESHDATA MATLAB code for nufarRefreshData.fig
%      NUFARREFRESHDATA, by itself, creates a new NUFARREFRESHDATA or raises the existing
%      singleton*.
%
%      H = NUFARREFRESHDATA returns the handle to a new NUFARREFRESHDATA or the handle to
%      the existing singleton*.
%
%      NUFARREFRESHDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NUFARREFRESHDATA.M with the given input arguments.
%
%      NUFARREFRESHDATA('Property','Value',...) creates a new NUFARREFRESHDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nufarRefreshData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nufarRefreshData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nufarRefreshData

% Last Modified by GUIDE v2.5 06-Mar-2018 08:34:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nufarRefreshData_OpeningFcn, ...
                   'gui_OutputFcn',  @nufarRefreshData_OutputFcn, ...
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


% --- Executes just before nufarRefreshData is made visible.
function nufarRefreshData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nufarRefreshData (see VARARGIN)

% Choose default command line output for nufarRefreshData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%%
%initialize system

%inputSystem = 1; 
Electrodes.numOfBins = 10;
Electrodes.numOfElec = 1; 
Electrodes.updateTime = 5;
Electrodes.elecArray = cell(Electrodes.numOfElec, 1);
Electrodes.n = cell(Electrodes.numOfElec,1); %creates a cell array of the n parameter for each electrodes
Electrodes.xout = cell(Electrodes.numOfElec,1); %creates a cell array of the xout parameter for each electrodes

%init cell array to read data in from buffer -> input for histograms
numOfStamps = 10; %number of time stamps to save from electrodes 
spikesTimeStamps = cell(Electrodes.numOfElec, numOfStamps);

%create cyclic time stemps vectors for each electrode
index = ones(Electrodes.numOfElec, 1);

%create array of histograms - one for each active electrod.
% for ii = 1:Electrodes.numOfElec
%    
%     Electrodes.elecArray{ii, 1} = figure;
%     histogram(spikesTimeStamps{ii, 1}, Electrodes.numOfBins);
%     xlabel('Time', 'FontSize', 12);
%     ylabel('number of spikes', 'FontSize', 12);
%     title('spikes per 100 ms', 'FontSize', 18);
% end

%%
% set up data
setappdata(handles.Random,'Electrodes',Electrodes);
setappdata(handles.Random,'index',index);
setappdata(handles.Random,'spikesTimeStamps',spikesTimeStamps);
% UIWAIT makes GUIgood wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% UIWAIT makes nufarRefreshData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nufarRefreshData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Random.
function Random_Callback(hObject, eventdata, handles)
% hObject    handle to Random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Electrodes = getappdata(handles.Random,'Electrodes');
    index = getappdata(handles.Random,'index');
    spikesTimeStamps = getappdata(handles.Random,'spikesTimeStamps');
    %getting the random input
    flagFirst = true;
    while true
        pause(Electrodes.updateTime);%TODO: change to other thread?
        for jj = 1:Electrodes.numOfElec
            tempVectorFromElectrode = rand(10,1)*1000;
            for indexFromTempVector = 1:length(tempVectorFromElectrode)
                spikesTimeStamps{jj,index(jj)} = tempVectorFromElectrode(indexFromTempVector);
                if index(jj) == size(spikesTimeStamps,2)
                    index(jj) = 1;
                else
                    index(jj) = index(jj)+1;
                end
            end
        end
        
        %creating cell from struct
        cellOfStruct = struct2cell(Electrodes);
        handlesCell = struct2cell(handles);
        cellOfStructNOB = cellOfStruct{1};
        cellOfStructNOE = cellOfStruct{2};
        cellOfStructUT = cellOfStruct{3};
        cellOfStructEA = cellOfStruct{4};
        cellOfStructN = cellOfStruct{5};
        cellOfStructX = cellOfStruct{6};

        %multi threads to the hist section
        for indexForHist = 1:cellOfStructNOE
            if flagFirst
                myIndex = strcmp(fieldnames(handles), ['axes',num2str(indexForHist)]);
                axes(handlesCell{myIndex});
                myData = cell2mat(spikesTimeStamps(indexForHist, :));
%                 hist(myData, cellOfStructNOB); %takes n and xout parameters for each electrode
                [cellOfStructN{indexForHist},cellOfStructX{indexForHist}] = hist(myData, cellOfStructNOB); %takes n and xout parameters for each electrode
                MyXsource = cellOfStructX{indexForHist};
                MyYsource = cellOfStructN{indexForHist};
<<<<<<< HEAD
                cla;
                drawnow;
                bar(MyXsource,MyYsource, 'YDataSource','myData');
=======
                bar(MyXsource,MyYsource, 'YDataSource','myData');

                % 
>>>>>>> a7568c3daa2d76f3d4764f66130b7d5e650c8258
%                 
%                 set(myBar,'XDataSource', 'MyXsource');
%                 set(myBar,'YDataSource', 'MyYsource');
%                 linkdata(handleTemp);
<<<<<<< HEAD
%                 linkdata on;
=======
                linkdata on;
>>>>>>> a7568c3daa2d76f3d4764f66130b7d5e650c8258
                flagFirst = false;
            else
                myIndex = strcmp(fieldnames(handles), ['axes',num2str(indexForHist)]);
                axes(handlesCell{myIndex});
                myData = cell2mat(spikesTimeStamps(indexForHist, :));
<<<<<<< HEAD
%                 set(myBar,'YDataSource','myData');
                [cellOfStructN{indexForHist},cellOfStructX{indexForHist}] = hist(myData, cellOfStructNOB); %takes n and xout parameters for each electrode
                MyXsource = cellOfStructX{indexForHist};
                MyYsource = cellOfStructN{indexForHist};
                cla;
                drawnow;
                bar(MyXsource,MyYsource, 'YDataSource','myData');
%                 grid on;
%                 hold on;
%                 drawnow;
%                 myBar = bar(MyXsource,MyYsource, 'YDataSource','myData');
%                 pause(0.1);

%                 waitfor(myBar,'YDataSource','myData');
                
=======
                [cellOfStructN{indexForHist},cellOfStructX{indexForHist}] = hist(myData, cellOfStructNOB); %takes n and xout parameters for each electrode
                drawnow;
                pause(0.5);
>>>>>>> a7568c3daa2d76f3d4764f66130b7d5e650c8258
%                 MyXsource = cellOfStructX{indexForHist};
%                 MyYsource = cellOfStructN{indexForHist};
%                 drawnow;
            end
            
%             refreshdata(handlesCell{myIndex});
%             set(handlesCell{myIndex},'YData','Electrodes.n(indexForHist)');
    %             xlabel('Time', 'FontSize', 12);
    %             ylabel('number of spikes', 'FontSize', 12);
    %             title('spikes per 100 ms', 'FontSize', 18);
        end
    end