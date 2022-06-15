library(r18r)
library(testthat)
library(devtools)

if (require(r18r.example)) {
    test_that('read PO files', {
        expect_equal(r18r_example_translation(), 'Egy szöveg egyenes az r18r.example csomagból')
        expect_equal(r18r_example_translation('en'), 'Text from r18r.example')
    })
}
