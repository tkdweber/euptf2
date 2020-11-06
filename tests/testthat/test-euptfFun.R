
### ptf ---------
test_that("argument ptf is correctly provided", {
        load("../../data/sample_data.rda")

 #1
        expect_that(euptfFun(ptf         = c("PTF01", "PTF02")
                             , predictor = sample_data[!is.na(sample_data$USSAND),]
                             , target    = "THS"
                             , query     = "predictions"
        )
        , throws_error("argument ptf has to be length 1"))
 #2
        expect_that(euptfFun(ptf         = "PT01"
                             , predictor = sample_data[!is.na(sample_data$USSAND),]
                             , target    = "THS"
                             , query     = "predictions"
        )
        , throws_error("number of characters in ptf has to be 5. Try inserting a leading zero in the single digit numbers"))
 #3
        expect_that(euptfFun(ptf         = 12345
                             , predictor = sample_data[!is.na(sample_data$USSAND),]
                             , target    = "THS"
                             , query     = "predictions"
        )
        , throws_error("argument ptf has to be a character"))

})

### predictor -----------
test_that("argument ptf is correctly provided", {

        df <- data.frame(matrix(1:8, ncol = 4))
        colnames(df) <- NULL

        expect_that(euptfFun(ptf         = c("PTF01")
                             , predictor = is.list(1)
                             , target    = "THS"
                             , query     = "predictions"
        )
        , throws_error("predictor has to be class vector, data.frame or data.table"))

        expect_that(euptfFun(ptf         = c("PTF01")
                             , predictor = df
                             , target    = "THS"
                             , query     = "predictions"
        )
        , throws_error("provide column names for the data table/data frame"))

        colnames(df) <- c("", "USCLAY", "USSILT", "DEPTH_M")
        expect_that(euptfFun(ptf         = c("PTF01")
                             , predictor = df
                             , target    = "THS"
                             , query     = "predictions"
        )
        , throws_error("column names in predictor has to contain at least USSAND, USSILT, USCLAY and DEPTH_M"))

})

### target -----------

# "target has to be one of: ", paste(query.target, collapse =" "))

test_that("argument ptf is correctly provided", {

        load("../../data/suggested_PTF.rda")
        query.target <- colnames(suggested_PTF)[-1]

        df           <- data.frame(matrix(2, ncol = 4))
        colnames(df) <- c("USSAND", "USSILT", "USCLAY", "DEPTH_M")

        expect_that(euptfFun(ptf         = "PTF01"
                             , predictor = df
                             , target    = "THS1"
                             , query     = "predictions"
        )
        , throws_error(paste("target has to be one of: ", paste(query.target, collapse =" ")))
        )

})


### quantiles -----------
test_that("argument ptf is correctly provided", {

        df           <- data.frame(matrix(2, ncol = 4))
        colnames(df) <- c("USSAND", "USSILT", "USCLAY", "DEPTH_M")
        expect_that(euptfFun(ptf         = c("PTF01")
                             , predictor = df
                             , target    = "THS"
                             , query     = "quantiles"
                             , quantiles = c(1.1)
        )
        , throws_error("quantiles have to be given between 0 and 1"))
})

### query -----------
test_that("argument ptf is correctly provided", {

        df           <- data.frame(matrix(2, ncol = 4))
        colnames(df) <- c("USSAND", "USSILT", "USCLAY", "DEPTH_M")
        expect_that(euptfFun(ptf         = c("PTF01")
                             , predictor = df
                             , target    = "THS"
                             , query     = "quant"
                             , quantiles = c(0.1)
        )
        , throws_error("query has to be specified as predictions or quantiles"))

        expect_that(euptfFun(ptf         = c("PTF01")
                             , predictor = df
                             , target    = "THS"
                             , query     = 1
                             , quantiles = c(0.1)
        )
        , throws_error("query has to be a character"))
})

### colnames -----------
test_that("argument ptf is correctly provided", {

        df           <- data.frame(matrix(2, ncol = 4))
        colnames(df) <- c("USSAND", "USSILT", "USCLAY", "DEPTH_M")
        expect_that(euptfFun(ptf         = c("PTF29")
                             , predictor = df
                             , target    = "THS"
                             , query     = "quantiles"
                             , quantiles = c(0.1)
        )
        , throws_error("the provided input columnames in predictor do not match the specified PTF"))

})


### colnames -----------
# test_that("input data ok?", {
#         load("../../data/sample_data.rda")
#
#         expect_that(euptfFun(ptf         = "PTF01"
#                              , predictor = sample_data[!is.na(sample_data$USSAND),][1:10, ]
#                              , target    = "THS"
#                              , query     = "predictions"
#
#         )
#         , throws_error("the provided input columnames in predictor do not match the specified PTF"))
#
# })
