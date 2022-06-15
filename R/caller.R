#' Find calling package
#' @export
#' @return package name or \code{NULL}
#' @param shift integer if need to shift the number of parent environments
caller <- function(shift = 0L) {
    packageName(topenv(parent.frame(n = 2 + shift)))
}
