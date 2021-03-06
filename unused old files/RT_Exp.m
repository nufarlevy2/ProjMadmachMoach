%%
clear all;
clear variables;

%%
%===============PRE-PROCESING===============
%===========================================

% propertiesFile.interface = 0; %0 (Automatic), 1 (Central), 2 (UDP)
%open neuroport
[connection, instrument] = cbmex('open', 'inst-addr', '192.168.137.128', 'inst-port', 51001, 'central-addr', '255.255.255.255', 'central-port', 51002);
connection = 1; %TODO: delete
instrument = 1; %TODO: delete
%print connection details
fprintf('>>>>>>>>>>> in openNeuroport: connection: %d, instrument: %d\n', connection, instrument);

%get number of electrode to present  
%TODO: this should return a map of active neurons (not channels) and their index.
%[numOfElecToPres, neuronMap] = getNumOfElecToPres(); % TODO: this should create a mapping
numOfElecToPres = 4; %TODO: delete
%%
%===============TRAINING====================
%===========================================
numberOfHistograms = 80; %TODO: get this from function
collect_time = propertiesFile.collectTime; %propertiesFile.collectTime;
fast_update_time = propertiesFile.fastUpdateTime;
slow_update_time = propertiesFile.slowUpdateTime;
nGraphs = propertiesFile.numOfElec;
Syllables = []; % ADD propertiesFile.Syllables;
allTimestampsMatrix = NaN(propertiesFile.numOfElec,200);
index = ones(propertiesFile.numOfElec, 1);
fastUpdateFlag = propertiesFile.fastUpdateFlag;
slowUpdateFlag = propertiesFile.slowUpdateFlag;

%cyclic arrays for time stamps - one for each neuron
spikesTimeStamps = cell(numOfElecToPres, 1);
for ii = 1:numOfElecToPres
    spikesTimeStamps{ii, 1} = NaN(1, propertiesFile.numOfStamps);
end

prompt = 'press ENTRR to start training\n';
input(prompt);

fprintf('>>>>>>>>>>> in RT_Exp: TRAINING started\n');

%%
%init clocks
t_Fdisp0 = tic; %fast display time
t_Sdisp0 = tic; %slow display time
t_SYLdisp = tic; %Syllables change time
t_col0 = tic; %collection time
bCollect = true; %do we need to collect
neuronTimeStamps = NaN(200, 80);
lastSample = 0;
last_col = 0;
last_updated_slow = 0;

%%
%init figures
fast_fig = figure; %fast update display

slow_fig = figure; %slow update display

raster_fig = figure; %raster plot display

%%
%while slow and fast figures are open
while(or(ishandle(slow_fig), ishandle(fast_fig)))
    if(bCollect)
        et_col = toc(t_col0); %elapsed time of collection
        
        if(et_col >= collect_time + last_col)
%             [neuronTimeStamps, index, lastSample] = getAllTimestampsSim(et_col, neuronTimeStamps, index, lastSample); %TODO: delete this
            neuronTimeStamps = getAllTimestamps(neuronTimeStamps, index); %read some data - the data should retern in cyclic arrays
            elecToPresent = getElecToPresent();%ask which neurons to present in fast update            
            %if the figure is open
            if(ishandle(fast_fig))
                fastUpdateFlag = fastUpdate(elecToPresent, fast_fig, neuronTimeStamps, fastUpdateFlag); %plot the choosen fast histograms 
            end
            
            et_disp = toc(t_Fdisp0);  % elapsed time since last display
            last_col = et_col;
            
            %if(et_disp >= display_period)
            %    t_col0 = tic; % collection time
            %    t_disp0 = tic; % restart the period
            %    bCollect = true; % start collection
            %end
        end
        
        if(et_col >= slow_update_time + last_updated_slow)
            if(ishandle(slow_fig))
                slowUpdateFlag = slowUpdate(numberOfHistograms, slow_fig, raster_fig, neuronTimeStamps, slowUpdateFlag); %plot all active histograms and rasterplots 
                last_updated_slow = et_col;
            end
        end
    end
end