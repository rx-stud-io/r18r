#' Extract lines from a character vector with the provided prefix
#' @param lines string
#' @param prefix string
#' @keywords internal
getlines <- function(lines, prefix) {
    sub(paste0('^', prefix, ' "(.*)"$'), '\\1', grep(paste0('^', prefix, ' '), lines, value = TRUE))
}


#' Parse \code{PO} file
#'
#' This is a quick and dirty \code{PO} file parser that should be
#' replaced with a proper library when needed. For the record,
#' \pkg{poio} looks promising, but I don't like bringing in
#' \pkg{dplyr} dependency, so will just go with this home-brewed
#' solution for now.
#'
#' Potential issues: double quotes in strings, plural forms.
#' @param file PO file path
#' @return list
#' @keywords internal
po_read <- function(file) {

    if (!file.exists(file)) {
        stop(paste('Translation file not found at', file))
    }
    po <- readLines(file)

    msgids <- getlines(po, 'msgid')[-1]
    msgstrs <- getlines(po, 'msgstr')[-1]

    if (basename(file) == 'en.po') {
        msgstrs <- msgids
    }

    as.list(setNames(msgstrs, msgids))

}


#' Returns the i18n folder of an installed R package
#' @param package string
#' @return path
#' @export
po_folder <- function(package) {
    path <- system.file('i18n', package = package)
    if (!dir.exists(path)) {
        stop(paste('i18n folder not found at', file.path(dirname(system.file()), package, 'i18n')))
    }
    path
}


#' List PO files in a folder
#' @param folder path
#' @return character vector of file paths
#' @export
po_files <- function(folder) {
    list.files(folder, pattern = '.po$')
}
