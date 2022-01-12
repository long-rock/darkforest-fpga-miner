from pathlib import Path

import pytest


class RtlData:
    """Gives access to files in the `rtl/` folder."""

    def __init__(self, rtl_dir: Path):
        self._rtl_dir = rtl_dir

    def file(self, filename: str) -> str:
        return str(self._rtl_dir / filename)


@pytest.fixture
def rtl_dir():
    basedir = Path(__file__).parent.parent / "rtl"
    return RtlData(basedir)
