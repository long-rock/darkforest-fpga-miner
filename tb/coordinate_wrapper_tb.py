import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from conftest import PRIME


@cocotb.test()
async def test_field_adder_no_overflow(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.rst.value = 0
    dut.ce_in.value = 1
    dut.coord.value = 123

    await FallingEdge(dut.clk)

    assert dut.ce_out.value == 1
    assert dut.wrapped_coord.value == 123

    dut.coord.value = 0
    await FallingEdge(dut.clk)
    assert dut.wrapped_coord.value == 0

    dut.coord.value = -123
    await FallingEdge(dut.clk)
    dut._log.info(dut.wrapped_coord.value.integer)
    assert dut.wrapped_coord.value == PRIME - 123
