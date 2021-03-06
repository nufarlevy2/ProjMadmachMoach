% Author: Ariel Tankus.
% Created: 2018-01-12.
% Derived from RunBasic() by Tal & Omer.

function sync_pulse_loop()
global cfg;
global use_direct_dev;

use_direct_dev = false;

%% initilize params 
openArduinoPort();

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
            closeArduinoPort;
            KbQueueRelease;
            break;
        end
    end

    %% sending pulses
    %arduino_control();
    t_sent = Send_pulse_to_ard_cfg;
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
