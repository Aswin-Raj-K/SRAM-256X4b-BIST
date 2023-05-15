`define CLK_PERIOD 10

//SRAM Parameters
`define SRAM_WORD_WIDTH 4
`define SRAM_ADDR_WIDTH 8
`define SRAM_DEPTH 256

//BIST Parameters
`define COUNTER_WIDTH `SRAM_ADDR_WIDTH + 3

//Blanket Test Parameters
`define BL_TEST_PATTERN_COUNT 2
`define BL_COUNTER_WIDTH `SRAM_ADDR_WIDTH + $clog2(`BL_TEST_PATTERN_COUNT) + 2


//March A Test Parameters
`define MA_TEST_PATTERN_COUNT 2
`define MA_COUNTER_WIDTH `SRAM_ADDR_WIDTH + $clog2(`BL_TEST_PATTERN_COUNT) + 2

//March C- Parameters
`define MC_TEST_PATTERN_COUNT 2
`define MC_COUNTER_WIDTH 1 + `SRAM_ADDR_WIDTH + 3 + $clog2(`MC_TEST_PATTERN_COUNT) + 1

//CheckerBoard Parameters
`define CH_TEST_PATTERN_COUNT 2
`define CH_COUNTER_WIDTH `SRAM_ADDR_WIDTH + 3

//State Machine
`define NO_OF_STATES  3
`define DONE 2
`define TEST 1
`define RESET 0
