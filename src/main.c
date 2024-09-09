#include "../include/log_init.h"

int main(){
    char count = 3;
    while(count--){
        log_data((unsigned char *)"FPU Initialised!\r\n");
    }
}