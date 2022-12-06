// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// For std::unique_ptr
#include <memory>

// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "top.v"
#include "Vadd.h"
#include "Vsub.h"
#include "catch2/catch_test_macros.hpp"

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

template<typename T>
struct VerilatorInfo {
    std::shared_ptr<VerilatedContext> context;
    std::shared_ptr<T> model;
};

template<typename T>
VerilatorInfo<T> setupContext() {
    // This is a more complicated example, please also see the simpler examples/make_hello_c.

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    std::shared_ptr<VerilatedContext> context = std::make_shared<VerilatedContext>();
    context->debug(0);
    context->randReset(2);
    context->traceEverOn(true);
    std::shared_ptr<T> top = std::make_shared<T>(context.get(), "TOP");

    VerilatorInfo<T> info = {0};
    info.context = std::move(context);
    info.model = std::move(top);

    return info;
}

template<typename T>
void cycle(VerilatorInfo<T> info) {
    info.context->timeInc(1); 
    info.model->clk = 1;
    info.model->eval();
    info.context->timeInc(1); 
    info.model->clk = 0;
    info.model->eval();
}

TEST_CASE("Add", "[Add]") {
    auto verilatorInfo = setupContext<Vadd>();

    cycle(verilatorInfo);

    verilatorInfo.model->a = 10;
    verilatorInfo.model->b = 20;

    cycle(verilatorInfo);

    REQUIRE(verilatorInfo.model->c == 30);

    verilatorInfo.model->final();
}

TEST_CASE("Sub", "[Sub]") {
    auto verilatorInfo = setupContext<Vsub>();

    cycle(verilatorInfo);

    verilatorInfo.model->a = 20;
    verilatorInfo.model->b = 10;

    cycle(verilatorInfo);

    REQUIRE(verilatorInfo.model->c == 10);

    verilatorInfo.model->final();
}