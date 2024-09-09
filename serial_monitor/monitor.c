#include<stdio.h>
#include<stdlib.h>
#include<strings.h>
#include<signal.h>
#include<unistd.h>
#include<fcntl.h>
#include<termios.h>

int fd = -1;

void exit_handler(int n){
    if(fd != -1){
        close(fd);
        printf("Serial port closed!\n");
    }
    exit(EXIT_SUCCESS);
}

int main(int argc, char **argv){
    if(argc != 2){
        printf("Usage error!\n");
        exit(EXIT_SUCCESS);
    }
    
    // open the file argv[1]
    fd = open(argv[1], O_RDWR | O_NOCTTY | O_NONBLOCK);
    if(fd == -1){
        perror("open");
        exit(EXIT_SUCCESS);
    }
    /*  configuration to change the signal disposition  */
    struct sigaction sig_config;
    sig_config.sa_handler = exit_handler;       // register the function to call at arrival of CTRL +  C
    sigemptyset(&sig_config.sa_mask);           // blocks the signals from interrupting the handler
    sig_config.sa_flags = 0;
    sigaction(SIGINT, &sig_config, 0);              

    /*  configuration of serial terminal    */
    struct termios u_config;
    tcgetattr(fd, &u_config);                   
    cfsetispeed(&u_config, B9600);              // Baudrate of 9600
    
    u_config.c_cflag &= ~PARENB;                // disable parity 
    u_config.c_cflag &= ~CSTOPB;                // 1 stop bit
    u_config.c_cflag &= ~CSIZE;                 
    u_config.c_cflag |= CS8;                    // 8 data bits

    tcsetattr(fd, TCSANOW, &u_config);          // Set the configuration by using TCSANOW flag

    char buffer[256];
    int n = 0;
    while (1)
    {
        n = read(fd, (char *)buffer, sizeof(buffer) - 1);
        if(n > 0){
            buffer[n] = '\0';
            printf("%s", buffer);
            bzero((char *)buffer, sizeof(buffer));
        }
    }
}