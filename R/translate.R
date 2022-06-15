.translations <- new.env()


#' Assert a namespace has been initialized
#' @param ns namespace used from \code{translations_import}
#' @return No return value.
#' @keywords internal
assert_namespace <- function(ns) {
    stopifnot(!missing(ns), !is.null(ns))
    if (is.null(.translations[[ns]])) {
        stop(paste('r18r namespace not found for', shQuote(ns), '- did you run translations_import?'))
    }
}


#' Assert a language is available in a namespace
#' @param language two-character language code, e.g. \code{en}
#' @inheritParams assert_namespace
#' @return No return value.
#' @keywords internal
#' @examples \dontrun{
#' assert_language_in_namespace('en', 'r18r')
#' }
assert_language_in_namespace <- function(language, ns) {
    assert_namespace(ns)
    if (!language %in% translated_languages(ns)) {
        stop(paste('Unknown language', shQuote(language), 'in the', shQuote(ns), 'namespace.'))
    }
}


#' List translated languages based on the list of PO files in the folder
#' @return character vector of language codes
#' @export
#' @inheritParams assert_namespace
translated_languages <- function(ns = caller()) {
    assert_namespace(ns)
    get(ns, envir = .translations)$`.languages`
}


#' Load PO files and cache in the package namespace
#' @param folder path to root folder of language files, where to find
#'     the \code{po} file for \code{language}, e.g. \code{en.po}
#' @param ns namespace under the content of the PO files will be stored
#' @export
#' @return No return value.
#' @examples \dontrun{
#' translations_import(system.file('i18n', package = 'r18r'), 'r18r')
#' translate_set_language('en', 'r18r')
#' translate_get_language('r18r')
#' translations('en', 'r18r')
#' translate('Text to be translated', ns = 'r18r')
#' translations_cleanup('r18r')
#' }
translations_import <- function(folder, ns = caller()) {

    files <- po_files(folder)
    languages <- sub('.po', '', files)

    assign(ns, list2env(list(.folder = folder, .languages = languages, translations = NULL)), envir = .translations)
    assign(
        'translations',
        list2env(mapply(function(language, file) {
            po_read(file.path(folder, file))
        }, languages, files, SIMPLIFY = FALSE, USE.NAMES = TRUE)),
        envir = .translations[[ns]])

}


#' Drop all translations and settings for a namespace
#' @return No return value.
#' @export
#' @inheritParams assert_namespace
translations_cleanup <- function(ns = caller()) {
    .translations[[ns]] <- NULL
}


#' Set translation language
#' @return No return value.
#' @export
#' @inheritParams translated_languages
translate_set_language <- function(language, ns = caller()) {
    assert_namespace(ns)
    assert_language_in_namespace(language, ns)
    .translations[[ns]]$`.language` <- language
}


#' Get current translation language
#' @return string
#' @export
#' @inheritParams translated_languages
translate_get_language <- function(ns = caller()) {
    assert_namespace(ns)
    language <- tryCatch(.translations[[ns]]$`.language`, error = function(e) NULL)
    if (is.null(language)) {
        stop('No default language set. Did you call r18r::translate_set_language?')
    }
    language
}


#' Return all translations for a language
#' @inheritParams translate_set_language
#' @return list
#' @export
translations <- function(language, ns = caller()) {
    assert_namespace(ns)
    assert_language_in_namespace(language, ns)
    .translations[[ns]]$translations[[language]]
}


#' Translate string
#' @param text string to be translated
#' @param language target language for the translation
#' @inheritParams translated_languages
#' @return string
#' @export
#' @note This is usually need to be called around \code{translatable}
#'     or \code{T}, as extracting all text withing \code{translate}
#'     would not be possible due to dynamic values to be translated
#'     (e.g. when text to be translated is stored in a variable).
translate <- function(text, language = translate_get_language(ns), ns = caller()) {
    translation <- translations(language, ns)[[text, exact = TRUE]]
    if (is.null(translation) || translation == '') {
        stop(paste('Missing translation of', shQuote(text),
                   'in language', shQuote(language)))
    }
    translation
}


#' Dummy function to mark text to be added to the list of terms to be translated
#' @inheritParams translate
#' @param comment_to_translator optional free text to be added to the
#'     \code{po} file for the translator
#' @return \code{text}
#' @export
#' @aliases T
translatable <- function(text, comment_to_translator = NA_character_) {
    text
}


#' @export
T <- translatable


#' Test if translation works for a language by looking up a term
#' @inheritParams assert_language_in_namespace
#' @return string
#' @export
test_translate <- function(language = 'en') {
    translate(translatable('Text to be translated', 'Example comment'), language, ns = 'r18r')
}


#' Container for future translations
#' @keywords internal
unused <- function() {
    T('R', 'The best programming language all around!')
    T('OK')
}
