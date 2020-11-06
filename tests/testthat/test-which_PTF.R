
test_that("predictor is character", {
     expect_that(which_PTF(2, "THS"), throws_error())

})

test_that("predictor breaks if PSD and DEPTH_M are both not given", {
     expect_that(which_PTF(c("PSD", "DEPTH_M1"), "THS"), throws_error())

})

test_that("target is character", {
     expect_that(which_PTF("THS", 2), throws_error())
     expect_that(which_PTF("THS", 2), throws_error())
     expect_that(which_PTF("THS", list(2)), throws_error())
})

test_that("target allows only certain strings", {
     expect_that(which_PTF(c("PSD","BD","DEPTH_M"), c("THS", "VG2")), throws_error())
})


