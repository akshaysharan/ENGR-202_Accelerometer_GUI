% ENGR 202
% Aurdino-Accelerometer
% Section 068 Group 8
% Authors:
% Akshay Sharan
% Brett Williams


function varargout = Sec68_G8_App(varargin)
% SEC68_G8_APP MATLAB code for Sec68_G8_App.fig
%      SEC68_G8_APP, by itself, creates a new SEC68_G8_APP or raises the existing
%      singleton*.
%
%      H = SEC68_G8_APP returns the handle to a new SEC68_G8_APP or the handle to
%      the existing singleton*.
%
%      SEC68_G8_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEC68_G8_APP.M with the given input arguments.
%
%      SEC68_G8_APP('Property','Value',...) creates a new SEC68_G8_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sec68_G8_App_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sec68_G8_App_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sec68_G8_App

% Last Modified by GUIDE v2.5 02-Aug-2013 16:25:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sec68_G8_App_OpeningFcn, ...
    'gui_OutputFcn',  @Sec68_G8_App_OutputFcn, ...
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


% --- Executes just before Sec68_G8_App is made visible.
function Sec68_G8_App_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sec68_G8_App (see VARARGIN)

% Choose default command line output for Sec68_G8_App
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sec68_G8_App wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sec68_G8_App_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% -------------------------------- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.comPort = '/dev/tty.usbmodemfa131';% Setting the value for comPort
%for Windows Machines
%handles.comPort = COM3

%startlButton runs setupSerial function
%if loop that connects MATLAB, GUI to accelerometer
% if there exists a variable called serialFlag
if (~exist('handles.serialFlag', 'var'))
    %call method: setupSerial and send value of comPort to
    %estabilish connection
    [handles.accelerometer.s, handles.serialFlag]...
        = setupSerial(handles.comPort);
end
% Display 'Complete' on the GUI startButton
% once intial serial setup is complete
set(handles.startButton, 'String', 'Complete')

%Update Handles
guidata(hObject, handles);


% -------------------------- Executes on button press in calibrateButton.
function calibrateButton_Callback(hObject, eventdata, handles)
% hObject    handle to calibrateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if there exists a variable called calCo
if(~exist('handles.calCo', 'var')) %if loop calibrates accelerometer
    % Call the method: calibrate to initialize calibration
    handles.calCo = calibrate(handles.accelerometer.s)'
end

set(handles.calibrateButton, 'String', 'Complete')

guidata(hObject, handles); %Updates handles


% ----------------------------------Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Call the method: closeSerial to terminate connection and close serial
% ports
closeSerial;


% --------------------------------Executes on button press in plot1button.
function plot1button_Callback(hObject, eventdata, handles)
% hObject    handle to plot1button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get data from the String variable of the plot1button
%handles.str = get(handles.plot1button, 'String');

% The strcmp function checks whether the String variable of the plot1button
% is 'Plot1', if yes, go head and plot the data, if not set plot1button to
% 'Stop'
if strcmp(get(handles.plot1button, 'String'), 'Plot') %if loop changes Plot string to Stop
    set(handles.plot1button, 'String', 'Stop');
else
    set(handles.plot1button,'String','Plot'); %Sets button to Stop
end

% Inititalize the variables that will control the input and the output of
% the program


% Set buffer length for the plot
handles.buf_len = 200;
% Create input buffers for all the three axis inputs and an index buffer to
% store the x-axis index of the accelerometer magnitude data

handles.gxdata = zeros(handles.buf_len,1);
handles.gydata = zeros(handles.buf_len,1);
handles.gzdata = zeros(handles.buf_len,1);
handles.magnitudedata = zeros(handles.buf_len,1);
handles.index = 1:handles.buf_len;

% Initialize variables to store Moving Average filtered data
    handles.gxMov = 0;
    handles.gyMov = 0;
    handles.gzMov = 0;
% Create Buffers for Moving Average data variables to store the rolling
% Moving Average filtered data
%
handles.gxMovData = zeros(handles.buf_len,1);
handles.gyMovData = zeros(handles.buf_len,1);
handles.gzMovData = zeros(handles.buf_len,1);
handles.magnitudeMovData = zeros(handles.buf_len,1);
handles.indexMov = 1:handles.buf_len;
% Initialize variables 
    handles.gxFilt = 0;
    handles.gyFilt = 0;
    handles.gzFilt = 0;
% Create Buffers for Alpha Filter data variables
% to store the rolling Alpha filtered data
%
handles.gxFiltData = zeros(handles.buf_len,1);
handles.gyFiltData = zeros(handles.buf_len,1);
handles.gzFiltData = zeros(handles.buf_len,1);
handles.magnitudeFiltData = zeros(handles.buf_len,1);
handles.indexFilt = 1:handles.buf_len;

% Use the strcmp function compare teh string value of plot1button with
% and alternate string
% While the string value on the plot1button is 'Stop Plot' run the loop
% that plots the 2 seperate plots
%
while strcmp(get(handles.plot1button,'String'),'Stop')
    
    
%---------- The following code block that has been commented out 
% plots a 3D vector plot that is redundant for the purpose of this app
%     %read accelerometer output
%     [handles.gx handles.gy handles.gz] = readAcc(handles.accelerometer, handles.calCo);
%     
%     axes(handles.axes1)
%     %plot X, Y, Z and resultant acceleration vectors and resultant
%     %acceleration vector
%     cla;
%     % X Vector
%     line([0 handles.gx], [0 0], [0 0], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');
%     % Y Vector
%     line([0 0], [0 handles.gy], [0 0], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
%     % Z Vector
%     line([0 0], [0 0], [0 handles.gz], 'Color', 'g', 'LineWidth', 2, 'Marker', 'o');
%     % Resultant Vector
%     line([0 handles.gx], [0 handles.gy], [0 handles.gz], 'Color', 'k', 'LineWidth', 2, 'Marker', 'o');
%     grid on
%     
%     %limit plot to +/- 2.5 g in all directions and make axis square
%     limits = 2.5;
%     axis([-limits limits -limits limits -limits limits]);
%     axis square;
%     %calculate the angle of the resultant acceleration vector and print
%     handles.theta = atand(handles.gy/handles.gx);
%     title(['Accelerometer tilt angle: ' num2str(handles.theta, '%.0f')]);
%     
%     %Keep updating the string value of plot1button with every iteration to
%     %encounter possible 'Plot1' String that will stop the function
%     %handles.str = get(handles.plot1button, 'String');
%     %Force MATLAB to redraw the figure
%     drawnow;
    
%   -----------------Original SENSOR MAGNITUDE DATA Accquisition(REAL TIME)
    % Read accelerometer output in Real time
    [handles.gx handles.gy handles.gz] = readAcc(handles.accelerometer, handles.calCo); %Reads new accelerometer values
    
    %Replace old data with new data in order to keep rolling plot
    %moving
    handles.gxdata = [handles.gxdata(2:end) ;handles.gx];
    handles.gydata = [handles.gydata(2:end) ;handles.gy];
    handles.gzdata = [handles.gzdata(2:end) ;handles.gz];
    
    % Set axes value to plot unfiltered data in real time over the
    % specified buffer length
    axes(handles.axes2)
    % Plot the buffer index vs the rela time magnitude data for the
    % accelerometer
    plot(handles.index, handles.gxdata, 'g',...
        handles.index, handles.gydata, 'r',...
        handles.index, handles.gzdata, 'b');
    % Standard Plot formatting that involves defining axis limits,
    % labelling the axes adding a title, turning the background grid on
    % and finally, using the drawnow function
    %
    % Define axis limitations
    axis([1 handles.buf_len -3.5 3.5]);
    
    xlabel('Time');% xlabel
    ylabel('Magnitude of Individual Axis Acceleration');%ylabel
    title('Sensor Data Magnitude(Unfiltered');% title
    grid on; %Turns on grid
    %drawnow; %Forces MATLab to redraw plot
    pause(.01); %Pauses for .01 seconds
    %handles.str = get(handles.plot1button, 'String'); %Contiuously refreshes to continually look for data
    drawnow;
    
%   ----------------- PLOTTING FILTERED DATA WITH BUTTON PANEL CONTROL
    % Get the value for the No Filter Radio button
    % If radio button is pressed,
    % Plot Unfiltered data on axes4
    if((get(handles.noFiltTrigger,'value'))== 1);
        
        axes(handles.axes4)
        
        plot(handles.index, handles.gxdata, 'g',...
        handles.index, handles.gydata, 'r',...
        handles.index, handles.gzdata, 'b');
    % Standard Plot formatting that involves defining axis limits,
    % labelling the axes adding a title, turning the background grid on
    % and finally, using the drawnow function
    %
    % Define axis limitations
    axis([1 handles.buf_len -3.5 3.5]);
    
    xlabel('Time');% xlabel
    ylabel('Magnitude of Individual Axis Acceleration');%ylabel
    title('Sensor Data Magnitude(Unfiltered');% title
    grid on; %Turns on grid
    %drawnow; %Forces MATLab to redraw plot
    pause(.01); %Pauses for .01 seconds
    %handles.str = get(handles.plot1button, 'String'); %Contiuously refreshes to continually look for data
    drawnow;
    end
    
    
    %--------------------------Aplpha Filter Implementation:
    % Step 1: Obtaining Slider Value
    
    
    handles.alpha = get(handles.sliderControlAlpha,'value');% Obtain Alpha value from slider
    
    % Step 2: Displaying current alpha value
    
    set(handles.sliderTextAlpha,'String',num2str(handles.alpha));% Set the Text box to the alpha value
    
    
    %Step 3: Implementing the Alpha Filter on the orignal data
    
    % Implementing the filter
    % Filtering x-axis data
    handles.gxFilt = (1-handles.alpha)*handles.gxFilt...
        +handles.alpha*handles.gx;
    % Filtering y-axis data
    handles.gyFilt = (1-handles.alpha)*handles.gyFilt...
        +handles.alpha*handles.gy;
    % Filtering z-axis data
    handles.gzFilt = (1-handles.alpha)*handles.gzFilt...
        +handles.alpha*handles.gz;
    
    % Step 4: Replace old data with new data in order to keep rolling plot
    %moving
    handles.gxFiltData = [handles.gxFiltData(2:end) ;handles.gxFilt];
    handles.gyFiltData = [handles.gyFiltData(2:end) ;handles.gyFilt];
    handles.gzFiltData = [handles.gzFiltData(2:end) ;handles.gzFilt];
     
    % Step 5: Plot the Filtered Data
    
    % Get the value for the Alpha Radio button
    % If radio button is pressed,
    % Plot Aplha Filtered data on axes4
    if((get(handles.alphaTrigger,'value'))== 1);
    
    axes(handles.axes4)
    plot(handles.indexFilt, handles.gxFiltData, 'g',...
        handles.indexFilt, handles.gyFiltData, 'r',...
        handles.indexFilt, handles.gzFiltData, 'b');
    % Standard Plot formatting that involves defining axis limits,
    % labelling the axes adding a title, turning the background grid on
    % and finally, using the drawnow function
    %
    % Define axis limitations
    
    axis([1 handles.buf_len -3.5 3.5]);
    
    xlabel('Time');% xlabel
    ylabel('Magnitude of Filtered Individual Axis Acceleration');%ylabel
    title('Sensor Data Magnitude (Filtered)');% title
    grid on; %Turns on grid
    drawnow; %Forces MATLab to redraw plot
    pause(.01); %Pauses for .01 seconds
    end
    
    
    %------------------Moving Average Filter implementation
    % Step 1 & 2: Obtaining the user input for number of taps and 
    % storing the user inputed value as the window size for Moving Average
    % Calculation purposes 
    %
     handles.movWindowSize = str2num(get(handles.movTaps,'String'));
   
    % Step 3: Implementing the Moving Average Filter filter
    
    % Filtering x-axis buffer data
   handles.gxMov =...
        mean(handles.gxdata(length(handles.gxdata): -1: (length(handles.gxdata)- handles.movWindowSize -1)));
    % Filtering y-axis buffer data
   handles.gyMov =...
        mean(handles.gydata(length(handles.gydata): -1: (length(handles.gydata)- handles.movWindowSize -1)));
    % Filtering  z-axis buffer data   
   handles.gzMov =...
        mean(handles.gzdata(length(handles.gzdata): -1: (length(handles.gzdata)- handles.movWindowSize -1)));
        
        
    %Step 4: Replace old data with new data in order to keep rolling plot
    %moving
    %
    handles.gxMovData = [handles.gxMovData(2:end) ;handles.gxMov];
    handles.gyMovData = [handles.gyMovData(2:end) ;handles.gyMov];
    handles.gzMovData = [handles.gzMovData(2:end) ;handles.gzMov];
    
    
    
    % Step 5: Plotting the new Filtered Data in real time
    
    % Get the value for the Moving Average Radio button
    % If radio button is pressed,
    % Plot Moving Average Filtered data on axes4
   if ((get(handles.movTrigger,'value'))== 1);
   
    axes(handles.axes4)
    plot(handles.indexMov, handles.gxMovData, 'g',...
        handles.indexMov, handles.gyMovData, 'r',...
        handles.indexMov, handles.gzMovData, 'b');
    
    % Standard Plot formatting that involves defining axis limits,
    % labelling the axes adding a title, turning the background grid on
    % and finally, using the drawnow function
    %
    % Define axis limitations
    axis([1 handles.buf_len -3.5 3.5]);
    
    xlabel('Time');% xlabel
    ylabel('Magnitude of Filtered Individual Axis Acceleration');%ylabel
    title('Sensor Data Magnitude (Filtered)');% title
    grid on; %Turns on grid
    drawnow; %Forces MATLab to redraw plot
    pause(.01); %Pauses for .01 seconds
   
   end
   
    
end
guidata(hObject, handles); %Updates handles


% --- Executes on slider movement.
function sliderControlAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to sliderControlAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderControlAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderControlAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function movTaps_Callback(hObject, eventdata, handles)
% hObject    handle to movTaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movTaps as text
%        str2double(get(hObject,'String')) returns contents of movTaps as a double


% --- Executes during object creation, after setting all properties.
function movTaps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movTaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
