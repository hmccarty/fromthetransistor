#include "Vhelloworld.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void tick(int tickcount, Vhelloworld *tb, VerilatedVcdC* tfp) {
    tb->eval();
    if (tfp) tfp->dump(tickcount * 10 - 2);
    tb->i_clk = 1;
    tb->eval();
    if (tfp) tfp->dump(tickcount * 10);
    tb->i_clk = 0;
    tb->eval();
    if (tfp) {
        tfp->dump(tickcount * 10 + 5);
        tfp->flush();
    }
}
  
int main(int argc, char** argv, char** env) {
    VerilatedContext* contextp = new VerilatedContext;
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);
    Vhelloworld* tb = new Vhelloworld;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("helloworld.vcd");

    unsigned tickcount = 0;
    for (int k = 0; k <(1<<20); k++) {
        tick(++tickcount, tb, tfp);
    }

    tb->final();
    delete tb;
    return 0;
}