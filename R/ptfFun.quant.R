#' Uncertainties (quantiles) of predicted soil hydraulic properties
#'
#' @param ptf.object object of ranger class with the built random forest.
#' @param df data.frame with data, specific column names are required. It is advised to use euptfFun.
#' @param quantiles vector of quantiles for the uncertainties to be calculated at. HAve to be between 0 and 1.
#'
#' @return data.frame of observations and quantiles, a list in the case of van Genuchten and Mualem-van Genuchten parameters.
#' @export
#'
#' @examples
#' # cf euptfFun
#' load(MVG_PTF01)
#' load(sample_data)
#' ptfFun.quant(ptf.object =MVG_PTF01 , df = sample_data)
#'


ptfFun.quant <- function(ptf.object, df, quantiles = c(.05,.25,.5,.75,.95)){

     #' @importFrom stats predict

     # thanks to flodel@stackoverflow
     depth <- function(this) ifelse(is.list(this), 1L + max(sapply(this, depth)), 0L)

     if(depth(ptf.object)==5){
          result <- lapply(ptf.object, function(x) {predict(x, data = df, type = "quantiles", quantiles)$predictions})
     }else{
          result <- predict(ptf.object, data = df, type = "quantiles", quantiles)$predictions
     }
     return(result)
}
