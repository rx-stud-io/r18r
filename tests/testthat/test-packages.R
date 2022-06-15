library(r18r)
library(testthat)
library(devtools)

po_folder <- system.file('i18n', package = 'r18r')
po_file <- file.path(po_folder, 'en.po')

test_that('read PO files', {
    load_all(system.file('r18r.example', package = 'r18r'))
    expect_equal(r18r_example_translation(), 'Egy szöveg egyenes az r18r.example csomagból')
    expect_equal(r18r_example_translation('en'), 'Text from r18r.example')
})
