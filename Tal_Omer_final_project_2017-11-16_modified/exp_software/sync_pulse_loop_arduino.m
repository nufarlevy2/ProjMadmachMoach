function sync_pulse_loop_arduino()
% sync_pulse_loop_arduino    
%

% Author: Ariel Tankus.
% Created: 06.03.2018.


global cfg;
global ard_obj;

%% initilize params 
cfg.Pulse.state = 0;
cfg.Pulse.TimerStarted = 0;
cfg.Pulse.PeriodStarted = 0 ;
cfg.Pulse.Counter = 0;
ard_obj = arduino();

cfg.LOG_PREFIX = 'sync_pulse_loop';
create_log_file();
%%
cfg.SYNC_INTERVAL_MIN = 0.5;
cfg.SYNC_INTERVAL_MAX = 1;

    
%% initilize keyboard queue
KbName('UnifyKeyNames');
keysOfInterest = zeros(1, 256);
keysOfInterest(KbName({'q', 'ESCAPE'})) = 1;
KbQueueCreate(-1, keysOfInterest);
KbQueueStart;

while true
    
    % Check keys for stop signal: 'q' or 'ESCAPE':
    [pressed, firstPress] = KbQueueCheck;
    %% pressed a button
    if (pressed)
        
        pressedCode = find(firstPress);
        time = firstPress(pressedCode);
        pressedCode = KbName(pressedCode);
%        fprintf('%s\n', pressedCode);
        if (strcmp(pressedCode, 'q') || strcmp(pressedCode, 'ESCAPE'))
            fclose(cfg.logfile);    % write all pending events.
            clear global ard_obj;
            KbQueueRelease;
            break;
        end
    end

    %% sending pulses
    %arduino_control();
    t_pre_sent = GetSecs;
    writeDigitalPin(ard_obj, 'D7', cfg.Pulse.state);
    t_sent = GetSecs;
    dt = t_sent - t_pre_sent
    
    fprintf(cfg.logfile,'%f EVENT: CHEETAH_SIGNAL %d %d\n', t_sent, ...
            cfg.Pulse.Counter, cfg.Pulse.state);
    
    next_rand = 0.5 + rand;
    next_rand = floor(next_rand.*1000) ./ 1000;   % timer StartDelay is limited
                                              % to 1ms precision.
    fprintf('Sync sent: %d. %d   Going to sleep for %.3f sec.\n', ...
            cfg.Pulse.Counter, cfg.Pulse.state, next_rand);
    
    cfg.Pulse.Counter = cfg.Pulse.Counter + 1; 
    cfg.Pulse.state = 1 - cfg.Pulse.state;
    cfg.Pulse.TimerStarted = 0;

    WaitSecs(next_rand);

end
