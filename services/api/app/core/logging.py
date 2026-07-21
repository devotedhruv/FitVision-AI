"""Minimal process logging configuration."""

import logging
from typing import Final

LOG_FORMAT: Final = "%(asctime)s %(levelname)s %(name)s %(message)s"


def configure_logging(level: str) -> None:
    """Configure the root logger once without exposing request payloads."""

    root = logging.getLogger()
    root.setLevel(level)
    if not root.handlers:
        handler = logging.StreamHandler()
        handler.setFormatter(logging.Formatter(LOG_FORMAT))
        root.addHandler(handler)
        return

    for handler in root.handlers:
        handler.setLevel(level)

