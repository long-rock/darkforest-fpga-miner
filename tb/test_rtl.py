from cocotb_test.simulator import run
from conftest import rtl_dir


def test_pwm(rtl_dir):
    run(verilog_sources=[rtl_dir.file("pwm.v")], toplevel="pwm", module="pwm_tb")


def test_coordinate_wrapper(rtl_dir):
    run(
        verilog_sources=[
            rtl_dir.file("mimc_prime.v"),
            rtl_dir.file("coordinate_wrapper.v"),
        ],
        toplevel="coordinate_wrapper",
        module="coordinate_wrapper_tb",
    )
