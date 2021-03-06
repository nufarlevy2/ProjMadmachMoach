function varargout = slowUpdateGui_v3(varargin)
    % SLOWUPDATEGUI_V3 MATLAB code for slowUpdateGui_v3.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @slowUpdateGui_v3_OpeningFcn, ...
                       'gui_OutputFcn',  @slowUpdateGui_v3_OutputFcn, ...
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
end


% --- Executes just before slowUpdateGui_v3 is made visible.
function slowUpdateGui_v3_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for slowUpdateGui_v3
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes slowUpdateGui_v3 wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    % Global Variables
    currPage = [1:propertiesFile.numOfElectrodesPerPage];
    setappdata(hObject, 'currPageElecs', currPage);
    numOfActiveElectrodes = getappdata(findall(0,'Name', 'RTExp_v3'), 'numOfActiveElectrodes');
    neuronMap = getappdata(findall(0,'Name', 'RTExp_v3'), 'neuronMap');
    setappdata(hObject, 'numOfActiveElectrodes', numOfActiveElectrodes);
    setappdata(hObject, 'neuronMap', neuronMap);
    setappdata(hObject, 'selected', zeros(numOfActiveElectrodes,1));
    setappdata(hObject, 'histograms', []);
    setappdata(hObject, 'currFilterIndex', 0);
    setappdata(hObject, 'filtersView', {});
    setappdata(hObject, 'selectedPerView', {});
    for inti = 1:propertiesFile.numOfElectrodesPerPage
        currText = findobj('Tag',['elec',num2str(inti),'Label']);
        set(currText, 'string', ['Elec: ',num2str(currPage(inti)),'-',neuronMap{currPage(inti),2}]);
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = slowUpdateGui_v3_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end



% --- Executes on slider movement.
function sliderForSlowUpdate_Callback(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_Callback');
    neuronMap = getappdata(hObject.Parent, 'neuronMap');
    currChoise = get(hObject, 'Value')+1;
    numOfActiveElectrodes = getappdata(hObject.Parent, 'numOfActiveElectrodes');
    if currChoise > ceil(numOfActiveElectrodes/propertiesFile.numOfElectrodesPerPage)
        currChoise = ceil(numOfActiveElectrodes/propertiesFile.numOfElectrodesPerPage);
    end
    set(handles.slowPlotsSliderResultLabel, 'String', currChoise);
    currGui = hObject.Parent;
    selected = getappdata(currGui, 'selected');
    for inti = 1:propertiesFile.numOfElectrodesPerPage
        currText = findobj('Tag',['elec',num2str(inti),'Label']);
        newElecNum = ((currChoise-1)*4)+inti;
        set(currText, 'string', ['Elec: ',num2str(newElecNum),'-',neuronMap{newElecNum,2}]);
        currPage(inti) = newElecNum;
        currPageSelection(inti) = selected(newElecNum);
    end
    setappdata(currGui, 'currPageElecs', currPage);
    for inti = 1:propertiesFile.numOfElectrodesPerPage
        currCheckbox = findobj('Tag', ['checkbox', num2str(inti)]);
        set(currCheckbox, 'Value', currPageSelection(inti));
    end
    currUpdateButton = findall(hObject.Parent, 'Tag', 'updateButton');
    currUpdateButton.Callback(currUpdateButton, eventdata);
end

% --- Executes during object creation, after setting all properties.
function sliderForSlowUpdate_CreateFcn(hObject, eventdata, handles)
    disp('sliderForSlowUpdate_CreateFcn');
    numOfActiveElectrodes = getappdata(findall(0,'Name', 'RTExp_v3'), 'numOfActiveElectrodes');
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    set(hObject, 'Max', ceil(numOfActiveElectrodes/propertiesFile.numOfElectrodesPerPage), 'Min', 0);
    set(hObject, 'SliderStep', [1/get(hObject, 'Max'), 1/get(hObject, 'Max')*5])
end


function slowPlotsSliderResultLabel_Callback(hObject, eventdata, handles)
    disp('slowPlotsSliderResultLabel_Callback');
end

% --- Executes during object creation, after setting all properties.
function slowPlotsSliderResultLabel_CreateFcn(hObject, eventdata, handles)
    disp('slowPlotsSliderResultLabel_CreateFcn');
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', '1');
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    disp('figure1_CloseRequestFcn');
    handles.figure1.UserData.closeFlag = true;
    currFilterIndex = getappdata(hObject.Parent, 'currFilterIndex');
    filtersViewList = getappdata(hObject.Parent, 'filtersView');
    for inti = 1:currFilterIndex
        if ishandle(filtersViewList{inti}) && filtersViewList{inti}.UserData.open == true
            delete(filtersViewList{inti})
        end
    end
    delete(hObject);
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
    disp('checkbox1_Callback');
    currGui = hObject.Parent;
    selected = getappdata(currGui, 'selected');
    currPage = getappdata(currGui, 'currPageElecs');
    currSelection = currPage(1);
    selected(currSelection) = xor(selected(currSelection), 1);
    setappdata(currGui, 'selected', selected);
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
    disp('checkbox2_Callback');
    currGui = hObject.Parent;
    selected = getappdata(currGui, 'selected');
    currPage = getappdata(currGui, 'currPageElecs');
    currSelection = currPage(2);
    selected(currSelection) = xor(selected(currSelection), 1);
    setappdata(currGui, 'selected', selected);
end

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    disp('checkbox3_Callback');
    currGui = hObject.Parent;
    selected = getappdata(currGui, 'selected');
    currPage = getappdata(currGui, 'currPageElecs');
    currSelection = currPage(3);
    selected(currSelection) = xor(selected(currSelection), 1);
    setappdata(currGui, 'selected', selected);
end

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
    disp('checkbox4_Callback');
    currGui = hObject.Parent;
    selected = getappdata(currGui, 'selected');
    currPage = getappdata(currGui, 'currPageElecs');
    currSelection = currPage(4);
    selected(currSelection) = xor(selected(currSelection), 1);
    setappdata(currGui, 'selected', selected);
end

% --- Executes on button press in viewSelectedButton.
function viewSelectedButton_Callback(hObject, eventdata, handles)
    disp('viewSelectedButton_Callback');
    elec = (getappdata(hObject.Parent, 'selected'));
    numOfElecs = find(elec==1)';
    if isempty(numOfElecs)
        errordlg('Please choose at least one electrode');
    else
        currFilterIndex = getappdata(hObject.Parent, 'currFilterIndex');
        currFilterIndex = currFilterIndex + 1;
        setappdata(hObject.Parent, 'currFilterIndex', currFilterIndex);
        UserData = get(hObject.Parent, 'UserData');
        UserData.numOfElecs = numOfElecs;
        UserData.filterNum = currFilterIndex;
        UserData.open = true;
        newFilterView = filterView_v1('UserData', UserData);
        filtersView = getappdata(hObject.Parent, 'filtersView');
        filtersView{currFilterIndex} = newFilterView;
        setappdata(hObject.Parent, 'filtersView', filtersView);
    end
    currUpdateButton = findall(hObject.Parent, 'Tag', 'updateButton');
    currUpdateButton.Callback(currUpdateButton, eventdata);
end

% --- Executes on button press in closeAllFilteredViewsButton.
function closeAllFilteredViewsButton_Callback(hObject, eventdata, handles)
    disp('closeAllFilteredViewsButton_Callback');
    currFilterIndex = getappdata(hObject.Parent, 'currFilterIndex');
    filtersViewList = getappdata(hObject.Parent, 'filtersView');
    for inti = 1:currFilterIndex
        % Adding relevant data to the UserData object of the relevant view
        if ishandle(filtersViewList{inti}) && filtersViewList{inti}.UserData.open == true
            delete(filtersViewList{inti})
        end
    end
end


% --- Executes on button press in createPlots.
function createPlots_Callback(hObject, eventdata, handles)
    % hObject    handle to createPlots (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    %Plots the histograms and rasters for the slowUpdateGui
    parameters = hObject.Parent.UserData;
    histograms = getappdata(hObject.Parent, 'histograms');
    rasters = getappdata(hObject.Parent, 'rasters');
    firstCreationFlag = false;
    if isempty(histograms) 
        for electrodeIndex = 1:propertiesFile.numOfElectrodesPerPage
            for labelsIndex = 1:propertiesFile.numOfLabelTypes
                histograms{electrodeIndex, labelsIndex} = findall(hObject.Parent, 'Tag',['slowPlot',num2str(electrodeIndex),'_',num2str(labelsIndex)]);
                rasters{electrodeIndex, labelsIndex} = findall(hObject.Parent, 'Tag', ['rasterPlot',num2str(electrodeIndex),'_',num2str(labelsIndex)]);
            end
        end
        firstCreationFlag = true;
        setappdata(hObject.Parent, 'histograms', histograms);
        setappdata(hObject.Parent, 'rasters', rasters);
    end
    createHistAndRasters(-parameters.preBipTime, parameters.postBipTime, parameters.slowUpdateFlag, parameters.numOfTrialsPerLabel, parameters.dataToSaveForHistAndRaster, histograms, hObject.Parent, rasters, firstCreationFlag);
    
    %Call for the create plots function of each filteres view
    currFilterIndex = getappdata(hObject.Parent, 'currFilterIndex');
    filtersViewList = getappdata(hObject.Parent, 'filtersView');
    guiUserData = get(hObject.Parent, 'UserData');
    for inti = 1:currFilterIndex
        % Adding relevant data to the UserData object of the relevant view
        if ishandle(filtersViewList{inti}) && filtersViewList{inti}.UserData.open == true
            filtersViewList{inti}.UserData.numOfTrialsPerLabel = guiUserData.numOfTrialsPerLabel;
            filtersViewList{inti}.UserData.dataToSaveForHistAndRaster = guiUserData.dataToSaveForHistAndRaster;
            filtersViewList{inti}.UserData.slowUpdateFlag = guiUserData.slowUpdateFlag;
            %Finds the relevant createPlots function
            createPlotsFunc = findall(filtersViewList{inti},'Tag', 'createPlots');
            %Execute its callback
            createPlotsFunc.Callback(createPlotsFunc, eventdata);
        end
    end
end


% --- Executes on button press in updateButton.
function updateButton_Callback(hObject, eventdata, handles)
    % hObject    handle to updateButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    bigFather = findall(0,'Name', 'RTExp_v3');
    if ~isempty(bigFather)
        bigFather.UserData.update = true;
    end
end
