import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge


@cocotb.test()
async def test_field_adder_no_overflow(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.width.value = 100

    for _ in range(100):
        await FallingEdge(dut.clk)
        assert dut.pulse.value == 1

    await FallingEdge(dut.clk)
    assert dut.pulse.value == 0
