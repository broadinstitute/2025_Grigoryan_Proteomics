# Imports
import os
import preprocessing as pp
#import classifier as cl
#import concresponse as cr
#import visualize as vs

features = config["features"]
scenario = config["workflow"]
name = config["name"]

# Rules 
rule compute_negcon_stats:
    input:
        f"/Users/grigoryanmariam/newproject/2025_Grigoryan_Proteomics/00.exploratory_analysis/CP_data/raw.parquet",
    output:
        f"outputs/profiles/neg_stats.parquet",
    run:
        pp.stats.compute_negcon_stats(*input, *output)


rule select_variant_feats:
    input:
        f"/Users/grigoryanmariam/newproject/2025_Grigoryan_Proteomics/00.exploratory_analysis/CP_data/raw.parquet",
        f"outputs/profiles/neg_stats.parquet",
    output:
        f"outputs/profiles/variant_feats.parquet",
    run:
        pp.stats.select_variant_features(*input, *output)


rule compute_norm_stats:
    input:
        f"outputs/profiles/mad.parquet",
    output:
        f"outputs/profiles/norm_stats.parquet",
    run:
        pp.stats.compute_stats(*input, *output)