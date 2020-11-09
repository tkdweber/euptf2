#' back transform MVG parameters
#'
#' @param ptf.L object returned by ptfFun.pred
#'
#' @return The prediction algorithms were created on transformed values/parameters. This function backtransform MVG parameters
#' @export
#'
#' @examples
#' #  put here later
#'

ptf.transFun <- function(ptf.L){
 res.trans <- list()

 res.trans$THS   <-  function(x) x
 res.trans$THR <-  function(x) 10^x-1
 res.trans$ALP <-  function(x) 10^x
 res.trans$N   <-  function(x) 10^x+1
 if(length(ptf.L) == 6){
         res.trans$K0  <-  function(x) 10^x
         res.trans$L   <-  function(x) x
 }
 res.df <- mapply(function(f, x) f(x), res.trans, ptf.L)

 return(res.df)

}
