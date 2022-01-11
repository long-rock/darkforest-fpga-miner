from cocotb_test.simulator import run

from conftest import rtl_dir


def test_pwm(rtl_dir):
    run(
        verilog_sources=[rtl_dir.file('pwm.v')],
        toplevel='pwm',
        module='pwm_tb'
    )
