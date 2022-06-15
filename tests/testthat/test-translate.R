library(r18n)
library(testthat)

translations_cleanup('r18n')

test_that('fail without init', {
    expect_error(translated_languages())
    expect_error(translated_languages('r18n'))
    expect_error(translate_get_language())
    expect_error(translate_get_language('r18n'))
    expect_error(translations())
    expect_error(translations('r18n'))
    expect_error(translations('en', 'r18n'))
})

test_that('import', {
    ## not enough args
    expect_error(translations_import(po_folder()))
    expect_error(translations_import(po_folder('r18n')))
    ## finally
    expect_error(translations_import(po_folder('r18n'), 'r18n'), NA)
})

test_that('set default language', {
    ## not enough args
    expect_error(translate_get_language())
    expect_error(translate_get_language('r18n'))
    expect_error(translate_set_language())
    expect_error(translate_set_language('en'))
    ## finally
    expect_error(translate_set_language('en', 'r18n'), NA)
    expect_equal(translate_get_language('r18n'), 'en')
})

test_that('cleanup', {
    expect_error(translations_cleanup('r18n'), NA)
})
