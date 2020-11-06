#' Table of suggested PTF given the available predictor variables and target variable
#'
#' List of recommended pedotransfer functions (PTF) by predicted soil hydraulic property and available predictor variables.
#' Table 11 in \insertCite{Szabo.2020}{euptf2}, the data table is used to query the suggested PTF use.
#'
#' @docType data
#'
#' @usage data(suggested_PTF)
#' @keywords datasets
#'
#' @format A data table with 32 rows and 10 variables
#' \itemize{
#'   \item Predictor_variables: combination of predictor variables
#'   \item THS: combination of predictor variables
#'   \item FC_2: Field capacity, as the measured soil water content at a pressure head of 330 cm.
#'   \item FC_2: Field capacity, as the measured soil water content at a pressure head of 60 cm.
#'   \item WP: Wilting point as the measured soil water content at a pressure head of 15000 cm.
#'   \item AWC_2: Available water content as the difference in soil water content between FC_2 and WP.
#'   \item AWC: Available water content as the difference in soil water content between FC and WP.
#'   \item KS: Saturated hydraulic conductivity  (\insertCite{vanGenuchten.1980}{euptf2}).
#'   \item VG: van-Genuchten model parameters (\insertCite{Mualem.1976}{euptf2}, \insertCite{vanGenuchten.1980}{euptf2}).
#'   \item MVG: Mualem-van-Genuchten model parameters.
#' }
#' @author
#' Tobias KD Weber <\email{tobias.weber@uni-hohenheim.de}>
#' Brigitta Toth <\email{toth.brigitta@agrar.mta.hu}>
#' Melanie Weynants <\email{melanie.weynants@ec.europa.eu}>

"suggested_PTF"
