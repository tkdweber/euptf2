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

 res.trans$ths   <-  function(x) x
 res.trans$thr.t <-  function(x) 10^x-1
 res.trans$alf.t <-  function(x) 10^x
 res.trans$n.t   <-  function(x) 10^x+1
 if(length(ptf.L) == 6){
         res.trans$ks.t  <-  function(x) 10^x
         res.trans$tau   <-  function(x) x
 }
 res.df <- mapply(function(f, x) f(x), res.trans, ptf.L)

 return(res.df)

}
