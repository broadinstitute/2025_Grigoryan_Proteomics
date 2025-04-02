"""
Functions to load metadata information
"""
import logging
from collections.abc import Iterable

import pandas as pd

logger = logging.getLogger(__name__)

def find_feat_cols(cols: Iterable[str]):
    """Find column names for features"""
    feat_cols = [c for c in cols if not c.startswith("Metadata")]
    return feat_cols


def find_meta_cols(cols: Iterable[str]):
    """Find column names for metadata"""
    meta_cols = [c for c in cols if c.startswith("Metadata")]
    return meta_cols