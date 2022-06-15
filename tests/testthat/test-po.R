library(r18r)
library(testthat)

po_folder <- system.file('i18n', package = 'r18r')
po_file <- file.path(po_folder, 'en.po')

test_that('read PO files', {
    expect_length(po_read(po_file), 2)
    expect_equal(po_read(po_file)$`Text to be translated`,'Text to be translated')
})

test_that('list PO files', {
    expect_equal(po_folder, po_folder('r18r'))
    expect_length(po_files(po_folder), 2)
    expect_equal(po_files(po_folder), c('en.po', 'hu.po'))
})

