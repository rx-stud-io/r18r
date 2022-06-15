#' Find calling package
#' @export
#' @return package name or \code{NULL}
#' @param shift integer if need to shift the number of parent environments
caller <- function(shift = 0L) {
    packageName(topenv(parent.frame(n = 1 + shift)))
}


## #' Example function using caller
#' @return string
#' @keywords internal
caller2 <- function() {
    caller(1L)
}


#' Example function using caller
#' @return string
#' @keywords internal
caller3 <- function(x=caller(1L)) {
    x
}
