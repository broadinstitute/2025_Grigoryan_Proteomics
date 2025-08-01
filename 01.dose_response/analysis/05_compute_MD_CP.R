source("./01.dose_response/Rscripts/gmd_functions.R")
source("./01.dose_response/Rscripts/cmd_functions.R")

require(dplyr)
require(arrow)
require(tidyr)
require(stringr)


input_file <- "./00.exploratory_analysis/inputs/CP_data/normalized.parquet"
output_dist <- "./01.dose_response/outputs/CP_distances.parquet"

cover_var <- 0.975

treatment <- "Metadata_Perturbation"

categories <- c("Cells_AGP", "Cells_DNA", "Cells_Mito", "Cells_RNA", "Cells_ER", "Cells_AreaShape",
                "Nuclei_AGP", "Nuclei_DNA", "Nuclei_Mito", "Nuclei_RNA", "Nuclei_ER", "Nuclei_AreaShape",
                "Cytoplasm_AGP", "Cytoplasm_DNA", "Cytoplasm_Mito", "Cytoplasm_RNA", "Cytoplasm_ER", "Cytoplasm_AreaShape")


# Process data
all_dat <- read_parquet(input_file) %>% as.data.frame()
all_dat <- all_dat[all_dat$Metadata_BROAD_ID != "EMPTY", ]
all_dat$`Metadata_Compound Name`[is.na(all_dat$`Metadata_Compound Name`)] <- "DMSO"
all_dat$Metadata_Perturbation <- paste(all_dat$`Metadata_Compound Name`, all_dat$Metadata_assay_conc_uM, sep="_")
colnames(all_dat)[colnames(all_dat) == "Metadata_Compound Name"] <- "Metadata_Compound"

dat_cols <- colnames(all_dat)
feat_cols <- dat_cols[!grepl("Metadata_", dat_cols)]
feat_cols <- feat_cols[!grepl("ObjectSkeleton", feat_cols)] # causes major problems
meta_cols <- dat_cols[grepl("Metadata_", dat_cols)]

treatment_labels <- all_dat[, treatment] %>% c()

dat <- all_dat[, feat_cols] %>% as.matrix()
dat <- apply(dat, 2, function(x) {
  x[is.na(x)] <- mean(x, na.rm = TRUE)
  return(x)
})
dat <- as.matrix(dat)


############## 1. gmd
print("Running GMD")

gmd_prep <- prep_gmd(dat, cover_var, treatment_labels)

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


############## 2. cmd
cmd_df <- data.frame()
for (category in categories) {
  print(category)
  
  feat_cols <- colnames(dat)[!grepl("Metadata", colnames(dat))]
  noimg_cols <- feat_cols[!grepl("Image", feat_cols)]
  cat_vals <- str_split(category, "_")
  compartment <- cat_vals[[1]][1]
  channel <- cat_vals[[1]][2]
  compartment_cols <- noimg_cols[grepl(compartment, noimg_cols)]
  category_cols <- compartment_cols[grepl(channel, compartment_cols)]
  
  # Extract category profile
  category_dat <- dat[, category_cols]
  category_res <- compute_matrices(category_dat, cover_var, treatment_labels)
  
  plates <- unique(all_dat$Metadata_Plate)
  for (plate in plates) {
    plate_dat <- all_dat[all_dat$Metadata_Plate == plate, category_cols]
    plate_dat <- as.matrix(plate_dat)
    plate_meta <- all_dat[all_dat$Metadata_Plate == plate, meta_cols]
    plate_labels <- plate_meta[, "Metadata_Compound"] %>% c()
    
    cmd <- compute_cmd(plate_dat, category_res$rot_mat,
                       category_res$inv, plate_labels, "DMSO")
    
    plate_meta$Metadata_Distance <- category
    plate_meta$Distance <- cmd
    
    cmd_df <- rbind(cmd_df, plate_meta)
  }
}



############## 3. combine into one dataframe and write out file
dist_df <- rbind(gmd_df, cmd_df)
dist_df <- dist_df %>%
  pivot_wider(
    names_from = Metadata_Distance,
    values_from = Distance
  )

write_parquet(dist_df, output_dist)



