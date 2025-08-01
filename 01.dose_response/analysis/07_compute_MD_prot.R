source("./01.dose_response/Rscripts/gmd_functions.R")

require(dplyr)
require(arrow)
require(tidyr)
require(stringr)

input_file <- "./00.exploratory_analysis/inputs/proteomics_data/mad_featselect.parquet"
#normalized_signal.csv"
output_dist <- "./01.dose_response/outputs/distances_test.parquet"

cover_var <- 0.975

treatment <- "Metadata_Perturbation"

# Process data
all_dat <- read.csv(input_file) %>% as.data.frame()
all_dat$Metadata_Perturbation <- paste(all_dat$Metadata_Compound, all_dat$Metadata_Concentration, sep="_")

dat_cols <- colnames(all_dat)
feat_cols <- dat_cols[!grepl("Metadata_", dat_cols)]
meta_cols <- dat_cols[grepl("Metadata_", dat_cols)]

treatment_labels <- all_dat[, treatment] %>% c()

dat <- all_dat[, feat_cols] %>% as.matrix()


############## 1. gmd
print("Running GMD")

gmd_prep <- prep_gmd(dat, cover_var, treatment_labels)

#plates <- unique(all_dat$Metadata_plate_barcode)
plates <- unique(all_dat$Metadata_Plate)
gmd_df <- data.frame()
for (plate in plates) {
  plate_dat <- all_dat[all_dat$Metadata_Plate == plate, feat_cols]
  plate_dat <- as.matrix(plate_dat)
  plate_meta <- all_dat[all_dat$Metadata_Plate == plate, meta_cols]
  plate_labels <- plate_meta[, "Metadata_Compound"] %>% c()

  gmd <- compute_gmd(plate_dat, as.matrix(gmd_prep$rot),
                     as.matrix(gmd_prep$inv_cov),
                     plate_labels, "DMSO")
  plate_meta$Metadata_Distance <- "gmd"
  plate_meta$Distance <- gmd
  gmd_df <- rbind(gmd_df, plate_meta)
}


############## 2. write out file
dist_df <- gmd_df %>%
  tidyr::pivot_wider(
    names_from = Metadata_Distance,
    values_from = Distance
  )

write_parquet(dist_df, output_dist)