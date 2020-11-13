#' Loads the built object to use for predictions.
#'
#' @description The function is intended for internal use in \code{euptfFun}. The aim is to load the
#' object from the data provided in the package, given a specific target variable ptf number combination.
#' No are made on the consistency of the argument, because this is done in euptfFun. 
#' Loaded algorithm provides possibility to use it as a ranger.forest object in the ranger package. 
#'
#' @param x A string apsted from two strings specifyng the combination ofthe target variable and PTF number.
#' The format is as in "THS_PTF29", i.e. the target and ptf seperated by an underscore.
#'
#' @return The loaded object as specified by \code{x}.
#'
#' @author Tobias KD Weber, \email{tobias.weber@uni-hohenheim.de}
#' @examples
#'\dontrun{
#' this_object <- load_PTF_object(x = "THS_PTF02"))
#'}
#' @export
#'
load_PTF_object <- function(x){

     if(stringr::str_detect(x, "KS")){x <- gsub("KS", "log10KS", x)}
     # the warning is irrelevant, therefore it is suppressed. Let's see if devtools::build() likes this.
     suppressWarnings({
          data(x, envir = environment())
     })
     return(get(x))
}
