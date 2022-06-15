library(r18r)
library(testthat)

translations_cleanup('r18r')

test_that('fail without init', {
    expect_error(translated_languages())
    expect_error(translated_languages('r18r'))
    expect_error(translate_get_language())
    expect_error(translate_get_language('r18r'))
    expect_error(translations())
    expect_error(translations('r18r'))
    expect_error(translations('en', 'r18r'))
})

test_that('import', {
    ## not enough args
    expect_error(translations_import(po_folder()))
    expect_error(translations_import(po_folder('r18r')))
    ## finally
    expect_error(translations_import(po_folder('r18r'), 'r18r'), NA)
})

test_that('set default language', {
    ## not enough args
    expect_error(translate_get_language())
    expect_error(translate_get_language('r18r'))
    expect_error(translate_set_language())
    expect_error(translate_set_language('en'))
    ## finally
    expect_error(translate_set_language('en', 'r18r'), NA)
    expect_equal(translate_get_language('r18r'), 'en')
})

test_that('translations', {
    ## not enough args
    expect_error(translate())
    expect_error(translate('Text to be translated', 'en'))
    ## finally
    expect_equal(translate('Text to be translated', 'en', 'r18r'), 'Text to be translated')
    expect_equal(test_translate(), 'Text to be translated')
    expect_equal(test_translate(language = 'hu'), 'Fordítandó szöveg')
})

test_that('cleanup', {
    expect_error(translations_cleanup('r18r'), NA)
})
