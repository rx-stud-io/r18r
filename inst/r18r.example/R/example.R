#' Return a translation
#' @importFrom r18n translations_import
#' @export
r18r_example_translation <- function(language = translate_get_language('r18r.example')) {
    translate(T('Text from r18r.example', 'To demo the r18r package.'), language)
}
