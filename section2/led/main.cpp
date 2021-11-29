#include "Vtop.h"
#include "verilated.h"

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}
  
int main(int argc, char** argv, char** env) {
    VerilatedContext* contextp = new VerilatedContext;
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;
    bool ledOn = false;
    while (!contextp->gotFinish()) { 
        if ((main_time % 10) == 1) {
            top->clk = 1;
        }
        if ((main_time % 10) == 6) {
            top->clk = 0;
        }

        top->eval(); 
        if (ledOn && !top->led) {
            printf("LED off\n");
            ledOn = false;
        } else if (!ledOn && top->led) {
            printf("LED on\n");
            ledOn = true;
        }

        main_time++;
    }

    top->final();
    delete top;
    return 0;
}