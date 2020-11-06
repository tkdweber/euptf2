#' Prediction of soil hydraulic properties
#'
#' @param ptf.object object of ranger class with the built random forest
#' @param df data.frame with data, specific column names are required. It is advised to use euptfFun.
#'
#' @return a vector of predicted, back transformed values. A data frame, if sets of Mualem-van Genuchten Paraemters, or van Genuchten Parameters are predicted.
#' @export
#'
#' @examples
#' # cf euptfFun
#' load(MVG_PTF01)
#' load(sample_data)
#' ptfFun.pred(ptf.object =MVG_PTF01 , df = sample_data)
#'


ptfFun.pred <- function(ptf.object, df){

 #' @importFrom stats predict

     # thanks to flodel@stackoverflow
     depth <- function(this) ifelse(is.list(this), 1L + max(sapply(this, depth)), 0L)

     if(depth(ptf.object)==5){
         result <-  suppressWarnings(lapply(ptf.object, function(x) {predict(x, data = df)$predictions}) )
     }else{
          result <- predict(ptf.object, data = df)$predictions
     }
return(result)
}
