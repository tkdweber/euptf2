#' An example data set from the EU-HYDI database.
#'
#' A data.frame with 2231 observations. The data can be used as a template for guidance in data preparation.
#' It is a subset of the Hungarian dataset in the EU-HYDI database. >insert 2 references<
#' @docType data
#'
#' @usage data(sample_data)
#' @keywords datasets
#'
#' @format A data table with 2231 rows and 36 columns
#' \itemize{
#'   \item PROFILE_ID: numeric, unique ID identifying a profile.
#'   \item SAMPLE_ID: numeric, unique ID identifying a the sample.
#'   \item BD: numeric, bulk density in g/cm^-3.
#'   \item OC: [g/kg] numeric, soil organic carbon.
#'   \item PH_H2O: [-], numeric
#'   \item CEC: numeric, cation exchange capacity.
#'   \item USSAND: [%], numeric, sand content of the soils
#'   \item USSILT: [%], numeric, silt content of the soils
#'   \item USCLAY: [%], numeric, clay content of the soils
#'   \item TEXT_FAO: factor, giving the texture according to the FAO classes.
#'   \item TEXT_US: factor, texture classes of the US soil taxonomy.
#'   \item TOPSOIL: logical, TRUE: sample is from the TOPSOIL, FALSE: sample is from the SUBSOIL.
#'   \item DEPTH_M:
#' }
#' @references
#' \insertRef{Szabo.2020}{euptf2}
#'
"sample_data"
