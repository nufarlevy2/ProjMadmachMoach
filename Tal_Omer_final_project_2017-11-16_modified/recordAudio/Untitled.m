global H_RECORD F_RECORD AXIS_RECORD ai data z_data R_fs R_samp_len
global IMAGE
global BLANK
global ZOOM_HISTORY
IMAGE = imread('recbutton.png');
IMAGE = imresize(IMAGE,[100 100]);
im_size = size(IMAGE);
BLANK = zeros(im_size(1:2));
width = 380;
height = 240;
   
   F_RECORD = figure('Position',[25 50 width height],...
      'NumberTitle','off',...
      'Color',[.8 .8 .8],...
      'Name','Record');
   
   H_RECORD(1) = uicontrol(...
        'Parent',F_RECORD,...
        'FontUnits',get(0,'defaultuicontrolFontUnits'),...
        'Units','characters',...
        'String','Record',...
        'Style',get(0,'defaultuicontrolStyle'),...
        'Position',[13 12.3846153846154 20.4 2.84615384615385],...
        'Callback',@(hObject,eventdata)untitled1_export('pushbutton1_Callback',hObject,eventdata,guidata(hObject)),...
        'ForegroundColor',[1 0 0],...
        'FontWeight','bold');
    
    H_RECORD(2) = uicontrol(...
        'Parent',F_RECORD,...
        'FontUnits',get(0,'defaultuicontrolFontUnits'),...
        'Units','characters',...
        'String','Stop & Save',...
        'Style',get(0,'defaultuicontrolStyle'),...
        'Position',[13 8.23076923076923 20.4 2.84615384615385],...
        'Callback',@(hObject,eventdata)untitled1_export('pushbutton1_Callback',hObject,eventdata,guidata(hObject)),...
        'ForegroundColor',[1 0 0],...
        'Enable','off');
        
    H_RECORD(2) = uicontrol(...
        'Parent',F_RECORD,...
        'FontUnits',get(0,'defaultuicontrolFontUnits'),...
        'Units','characters',...
        'String','Stop & Save',...
        'Style',get(0,'defaultuicontrolStyle'),...
        'Position',[13 8.23076923076923 20.4 2.84615384615385],...
        'Callback',@(hObject,eventdata)untitled1_export('pushbutton1_Callback',hObject,eventdata,guidata(hObject)),...
        'ForegroundColor',[1 0 0],...
        'Enable','off');
     
    H_RECORD(3) = uicontrol(...
        'Parent',F_RECORD,...
        'FontUnits',get(0,'defaultuicontrolFontUnits'),...
        'Units','characters',...
        'String','Restore',...
        'Style',get(0,'defaultuicontrolStyle'),...
        'Position',[13 4.07692307692308 20.4 2.84615384615385],...
        'Callback',@(hObject,eventdata)untitled1_export('pushbutton1_Callback',hObject,eventdata,guidata(hObject)),...
        'ForegroundColor',[1 1 1],...
        'Enable','on');
   
    Log_String = {'log';'1st line';'2nd line';'3';'4';'5'};
    H_RECORD(4) = uipanel(...
        'Parent',F_RECORD,...
        'FontUnits',get(0,'defaultuipanelFontUnits'),...
        'Units','characters',...
        'HighlightColor',[0 0 1],...
        'Title','LOG',...
        'Tag','uipanel2',...
        'Position',[39.8 0.923076923076923 30.2 9.38461538461539],...
        'FontSize',10,...
        'FontWeight','bold' );


    H_RECORD(5) = uicontrol(...
        'Parent', H_RECORD(4),...
        'FontUnits',get(0,'defaultuicontrolFontUnits'),...
        'Units','characters',...
        'String',Log_String,...
        'Style','text',...
        'Position',[1.6 1 26.2 6.38461538461539],...
        'Children',[],...
        'Tag','text4');
    
    H_RECORD(6) = uicontrol(...
        'Parent',F_RECORD,...
        'FontUnits',get(0,'defaultuicontrolFontUnits'),...
        'Units','characters',...
        'String','Rec',...
        'Style','text',...
        'Visible','on',...
        'Position',[39.8 12.0769230769231 10.6 2.46153846153846],...
        'BackgroundColor',[1 0 0],...
        'FontSize',18);
    