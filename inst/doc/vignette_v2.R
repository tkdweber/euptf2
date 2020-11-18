## ---- include = FALSE----------------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------
#  # install the devtools package if not yet done:
#  if (!require("devtools")){install.packages("devtools"); library(devtools)}
#  if (!require("euptf2")){devtools::install_github("tkdweber/euptf2"); library(euptf2)}

## ----setup---------------------------------------------------------------------------------------------------------------------------------------------------------
# load the package:
library(euptf2)

## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------
#  data(sample_data)

## ----eval=TRUE-----------------------------------------------------------------------------------------------------------------------------------------------------
sample_data

## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------
#  # import data from csv file:
#  mydata <- read.csv("myworksheet.csv")
#  
#  # import data from xlsx file with package xlsx:
#  # install the xlsx package if not yet done:
#  if (!require("xlsx")){install.packages("xlsx"); library(xlsx)}
#  # load the package:
#  library("xlsx")
#  # import data from xlsx file:
#  mydata <- read.xlsx("myworkbook.xlsx", sheetName="myworksheet")
#  # see ?read.xlsx for more options

## ----eval=TRUE-----------------------------------------------------------------------------------------------------------------------------------------------------
# check which_PTF to use to predict THS based on the predictor variables available in sample_data
which_PTF(predictor= sample_data, target = c("THS"))

# check which_PTF to use to predict multiple soil hydraulic properties
which_PTF(predictor= sample_data, target = c("THS", "FC", "WP", "KS", "VG", "MVG"))

## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------
#  data(suggested_PTF)
#  suggested_PTF

## ----eval=TRUE-----------------------------------------------------------------------------------------------------------------------------------------------------
# predict parameters of the van Genuchten model (VG)
pred_VG <- euptfFun(ptf = "PTF11", predictor = sample_data, target = "VG", query = "predictions")
pred_VG

# predict VG with predefined quantiles
pred_VG_q <- euptfFun(ptf = "PTF11", predictor = sample_data, target = "VG", query = "quantiles", quantiles = c(0.1, 0.5, 0.9))
pred_VG_q

# please note that output is list, can be formatted to data frame:
pred_VG_q.df <- as.data.frame(pred_VG_q)

# predict parameters of the Mualem-van Genuchten model (MVG)
pred_MVG <- euptfFun(ptf = "PTF05", predictor = sample_data, target = "MVG", query = "predictions")
pred_MVG

## ----eval=TRUE-----------------------------------------------------------------------------------------------------------------------------------------------------
# predict saturated water content (THS)
pred_THS <- euptfFun(ptf = "PTF03", predictor = sample_data, target = "THS", query = "predictions")
pred_THS

# predict THS with predefined quantiles
pred_THS_q <- euptfFun(ptf = "PTF03", predictor = sample_data, target = "THS", query = "quantiles", quantiles = c(0.05, 0.5, 0.95))
pred_THS_q

# predict saturated hydraulic conductivity (KS)
pred_KS <- euptfFun(ptf = "PTF05", predictor = sample_data, target = "KS", query = "predictions")
pred_KS

## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------
#  # example to save the predicted values to a csv file:
#  write.csv(pred_THS, file = "pred_THS.csv", row.names = FALSE)
#  # see ?write.csv for additional options
#  
#  # example to save predicted values to xlsx file:
#  # install the openxlsx package if not yet done:
#  if (!require("openxlsx")){install.packages("openxlsx"); library(openxlsx)}
#  library(openxlsx)
#  write.xlsx(pred_THS, file = "pred_THS.xlsx")

