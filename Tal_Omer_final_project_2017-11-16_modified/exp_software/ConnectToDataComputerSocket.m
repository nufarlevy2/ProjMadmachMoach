function ConnectToDataComputerSocket()
    
    warning('off','instrument:fread:unsuccessfulRead');
    global cfg;
    
    %% SERVER SOCKET
    cfg.server_data_socket = tcpip(cfg.DATA_COMPUTER_IP,cfg.DATA_COMPUTER_PORT, 'NetworkRole', 'server');
    fopen(cfg.server_data_socket);
    cfg.data_computer.Timeout = cfg.DATA_COMPUTER_TIMEOUT;
    fprintf(cfg.logfile,'%f DATA COMPUTER- SERVER_SOCKET_CONNECTED PORT:%d\n',GetSecs,cfg.DATA_COMPUTER_PORT);
    
    %% CLIENT SOCKET
    cfg.client_data_socket = tcpip(cfg.PARADIGM_COMPUTER_IP,cfg.PARADIGM_COMPUTER_PORT, 'NetworkRole', 'client');
    fopen(cfg.client_data_socket);
    fprintf(cfg.logfile,'%f DATA COMPUTER- CLIENT_SOCKET_CONNECTED PORT:%d\n',GetSecs,cfg.PARADIGM_COMPUTER_PORT);
    
end