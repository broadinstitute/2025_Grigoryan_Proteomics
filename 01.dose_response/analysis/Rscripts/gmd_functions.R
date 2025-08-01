
require(dplyr)
require(arrow)

prep_gmd <- function(dat, cover_var, treatment_labels) {

  ############## 1. Calculate the Eigen features from the well-level data
  pca <- prcomp(dat, center = TRUE, scale = TRUE)
  rotation_matrix <- pca$rotation
  cumul_proportion <- cumsum(pca$sdev^2) / sum(pca$sdev^2)

  ##############  2. Find the inverse of the covariance matrix
  pc <- length(which(cumul_proportion < cover_var)) + 1
  if (pc > dim(dat)[1]) {
    pc <- dim(dat)[1]
  }
  rotation_matrix <- rotation_matrix[, 1:pc]
  model <- lm(pca$x[, 1:pc] ~ 0 + treatment_labels)

  # get covariance matrix
  cov <- estVar(model) %>% as.data.frame()

  # compute inverse
  inv_cov <- solve(cov) %>% as.data.frame()

  return(list(rot = rotation_matrix, inv_cov = inv_cov))

}


compute_gmd <- function(dat, rot_mat, inv_cov, treatment, control) {
  # get PC scores using loadings and number PCs computed previously
  dat <- dat %*% rot_mat

  # compute the centroid of control samples
  ctrl_mean <- apply(dat[treatment == control, ], 2, mean)

  # subtract the control centroid from each sample
  delta <- sweep(dat, 2, as.matrix(ctrl_mean), "-")

  # compute the Mahalanobis distance
  gmd <- apply(delta, 1, function(x) {
    gmd_util(x, inv_cov)
  })

  return(gmd)
}

gmd_util <- function(x, inv_cov) {
  x_int <- x %*% inv_cov %*% x
  x_int <- sqrt(x_int)
  return(round(x_int, 3))
}