#' An example data set from the EU-HYDI database.
#'
#' A data.frame with 10 observations. The data can be used as a template for guidance in data preparation.
#' It is a subset of the Hungarian dataset in the EU-HYDI database (Weynants et al., 2013, Szabó et al., 2020).
#' @docType data
#'
#' @usage data(sample_data)
#' @keywords datasets
#'
#' @format A data table with 10 rows and 10 columns
#' \itemize{
#'   \item SAMPLE_ID: numeric, unique ID identifying a the sample.
#'   \item DEPTH_M: [cm], numeric, mean soil depth.
#'   \item USSAND: [g / 100 g], numeric, sand content of the soil.
#'   \item USSILT: [g / 100 g], numeric, silt content of the soil.
#'   \item USCLAY: [g / 100 g], numeric, clay content of the soil.
#'   \item OC: [g / 100 g] numeric, soil organic carbon content.
#'   \item BD: [g/cm^-3], numeric, bulk density of the soil.
#'   \item PH_H2O: [-], numeric, soil pH.
#'   \item CACO3: [g / 100 g], numeric, calcium carbonate content of the soil.
#'   \item CEC: [meq / 100 g], numeric, cation exchange capacity.
#' }
#' @references
#' \insertRef{Szabo.2020}{euptf2}
#' \insertRef{Weynants.2013}{euptf2}
#'
"sample_data"
