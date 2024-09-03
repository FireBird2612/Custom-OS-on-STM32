#include "log_init.h"

int main(){
    log_data((unsigned char *)"FPU Initialised!\n");
    volatile float val = 1.0f, val1 = 3.0f, result;
    result = val + val1;
}