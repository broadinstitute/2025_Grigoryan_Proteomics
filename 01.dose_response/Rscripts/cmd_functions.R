require(dplyr)
require(arrow)

compute_cmd <- function(dat, rot_mat, inv_cov, treatment, control) {
  # get PC scores using loadings and number PCs computed previously
  dat <- dat %*% rot_mat

  # compute the centroid of control samples
  ctrl_mean <- apply(dat[treatment == control, ], 2, mean)

  # subtract the control centroid from each sample
  delta <- sweep(dat, 2, as.matrix(ctrl_mean), "-")

  # compute the Mahalanobis distance
  gmd <- apply(delta, 1, function(x) {
    cmd_util(x, inv_cov)
  })

  return(gmd)
}


cmd_util <- function(x, inv_cov) {
  x_int <- x %*% inv_cov %*% x
  x_int <- sqrt(x_int)
  return(round(x_int, 3))
}


comsub <- function(x) {
  # sort the vector
  x <- sort(x)
  # split the first and last element by character
  d_x <- strsplit(x[c(1, length(x))], "")
  # search for the first not common element and so, get the last matching one
  der_com <- match(FALSE, do.call("==", d_x)) - 1
  # return empty vector if no matching, else return the common part
  ifelse(der_com == 0, return(character(0)), return(substr(x[1], 1, der_com)))
}


compute_matrices <- function(dat, cover_var, treatment_labels) {
  pca <- prcomp(dat, center = TRUE, scale = TRUE)
  rotation_matrix <- pca$rotation
  cum_proportion <- cumsum(pca$sdev^2) / sum(pca$sdev^2)

  pc <- length(which(cum_proportion < cover_var)) + 1
  if (pc > dim(dat)[1]) {
    pc <- dim(dat)[1]
  }
  rotation_matrix <- rotation_matrix[, 1:pc]
  model <- lm(pca$x[, 1:pc] ~ 0 + treatment_labels)

  # get covariance matrix
  cov <- as.data.frame(estVar(model))

  # compute inverse
  inv_cov <- solve(cov)

  return(list(rot_mat = rotation_matrix, inv = inv_cov))
}