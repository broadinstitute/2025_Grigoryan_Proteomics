from __future__ import annotations

import numpy as np
import pandas as pd

from .metadata import find_feat_cols, find_meta_cols


def split_parquet(
    dframe_path: str,
    features=None,
) -> tuple[pd.DataFrame, np.ndarray, list[str]]:
    dframe = pd.read_parquet(dframe_path)
    if features is None:
        features = find_feat_cols(dframe)
    vals = np.empty((len(dframe), len(features)), dtype=np.float32)
    for i, c in enumerate(features):
        vals[:, i] = dframe[c]
    meta = dframe[find_meta_cols(dframe)].copy()
    return meta, vals, features


def merge_parquet(meta, vals, features, output_path: str) -> None:
    """Save the data in a parquet file resetting the index."""
    dframe = pd.DataFrame(vals, columns=features)
    for c in meta:
        dframe[c] = meta[c].reset_index(drop=True)
    dframe.to_parquet(output_path)
