wildcard_constraints:
    pipeline=r"[_a-zA-Z.~0-9\-]*"

features = config["features"]
scenario = config["workflow"]
name = config["name"]

rule mad_normalize:
    input:
        f"outputs/profiles/variant_feats.parquet",
        f"outputs/profiles/neg_stats.parquet",
    output:
        f"outputs/profiles/mad.parquet",
    run:
        pp.normalize.mad(*input, *output)


rule featselect:
    input:
        f"outputs/profiles/mad.parquet",
    output:
        f"outputs/profiles/mad_featselect.parquet",
    params:
        outlier_thresh=config["outlier_feat_thresh"],
    run:
        pp.select_features(*input, params.outlier_thresh, *output)