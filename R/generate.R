#nocov start
#' Generate \code{PO} files for the package based on \code{translate} calls
#' @param folder path to R package
#' @param copyright_holder name of the organization or person owning the rights over the PO files
#' @param language_team name and email address of the team
#' @export
#' @note System dependency of \code{gettext}.
#' @importFrom processx run
#' @importFrom logger log_trace skip_formatter log_error
#' @importFrom desc desc
#' @importFrom stats na.omit
#' @importFrom utils head
translations_generate <- function(folder,
                                  copyright_holder = NA_character_,
                                  language_team = NA_character_
                                  ) { # nolint

    d <- tryCatch(
        desc(file.path(folder, 'DESCRIPTION')),
        error = function(e) {
            log_error(e$message)
            stop('Error while trying to parse the pkg DESCRIPTION file in', folder)
        }
    )
    package_name <- d$get_field('Package')
    package_date <- d$get_field('Date')

    ## based on tools::xgettext
    find_strings <- function(e) {
        if (is.call(e) && is.name(e[[1L]]) && (as.character(e[[1L]]) %in% c('T', 'translatable'))) {
            ## extract text to be translated and comment to be passed to the translator
            text <- eval(e[[2]])
            if (!is.null(text) && is.character(text)) {
                log_trace(skip_formatter(paste('Text to translate:', as.character(text))))
                comment <- ifelse(length(e) > 2, eval(e[[3]]), NA_character_)
                strings <<- c(strings, list(list(text = text, comment = comment)))
            }
        } else {
            if (is.recursive(e)) {
                for (i in seq_along(e)) {
                    Recall(e[[i]])
                }
            }
        }
    }

    ## storage for all the terms to be translated
    strings <- list()

    ## extract terms from package source
    files <- list.files(file.path(folder, 'R'), pattern = '.R$', full.names = TRUE)
    for (f in files) {
        find_strings(parse(file = f))
    }

    ## TODO make this modular to be able to look up Rmd files etc.
    ##      as the current implementation is too specific to the Rx Studio packages

    pot <- path.expand(file.path(folder, 'inst', 'i18n', paste(package_name, 'pot', sep = '.')))
    if (!dir.exists(dirname(pot))) {
        dir.create(dirname(pot), recursive = TRUE)
    }
    cat('# Copyright (C) ', format(Sys.time(), '%Y'), ' ', copyright_holder, '\nmsgid ""\nmsgstr ""\n"Project-Id-Version: ', package_name, ' 1.0\\n"\n"POT-Creation-Date: ', package_date, '\\n"\n"PO-Revision-Date: ', format(Sys.time()), '\\n"\n"Last-Translator: ', language_team, '\\n"\n"Language-Team: ', language_team, '\\n"\n"MIME-Version: 1.0\\n"\n"Content-Type: text/plain; charset=UTF-8\\n"\n"Content-Transfer-Encoding: 8bit\\n"\n\n', sep = '', file = pot) # nolint

    ## drop duplicates
    strings <- unique(strings)
    ## merge empty comments
    texts <- as.character(sapply(strings, `[`, 'text'))
    comments <- as.character(sapply(strings, `[`, 'comment'))
    for (t in unique(texts[duplicated(texts)])) {
        indexes <- which(texts == t)
        if (length(unique(na.omit(comments[indexes]))) > 1) {
            log_error(skip_formatter(t))
            stop('Duplicate comments defined for the same text')
        }
        comment <- head(sort(comments[indexes], na.last = TRUE), 1)
        for (i in indexes) {
            strings[[i]]$comment <- comment
        }
    }
    strings <- strings[!duplicated(sapply(strings, `[[`, 'text'))]

    for (s in strings) {
        if (!is.na(s$comment)) {
            cat('#. ', s$comment, '\n', sep = '', file = pot, append = TRUE)
        }
        cat('msgid ', shQuote(s$text, type = 'cmd'), '\n', sep = '', file = pot, append = TRUE)
        cat('msgstr ', shQuote('', type = 'cmd'), '\n\n', sep = '', file = pot, append = TRUE)
    }

    ## disable saving PO file's backup
    VERSION_CONTROL <- Sys.getenv('VERSION_CONTROL')
    Sys.setenv('VERSION_CONTROL' = 'off')

    ## English template
    enpo <- path.expand(file.path(folder, 'inst', 'i18n', 'en.po'))

    run(
        command = 'msgmerge',
        args = c(
            '--no-fuzzy-matching', '--quiet', '--update', '--no-wrap',
            enpo, pot))

    ## further languages
    pos <- list.files(file.path(folder, 'inst', 'i18n'), pattern = '.po$', full.names = TRUE)
    pos <- pos[basename(pos) != 'en.po']
    for (po in pos) {
        run(
            command = 'msgmerge',
            args = c(
                '--no-fuzzy-matching', '--quiet', '--update', '--no-wrap',
                po, enpo))
    }

    Sys.setenv('VERSION_CONTROL' = VERSION_CONTROL)

}
#nocov end
