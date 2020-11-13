#' Wrapper to predict and calculate prediction uncertainty for the soil hydraulic properties.
#'
#' @param ptf A character specifying the ptf. Permissible are "ptf01" "ptf02", ...., "ptf32".
#' @param predictor A data.frame or data.table of dimension \code{m x n}, with \code{m} observations and \code{n} predictor variables.
#' The column names specify the names of the predictor variables. At least \code{DEPTH_M} and \code{USSAND},\code{USSILT}, \code{USCLAY} have to be provided.
#' If in doubt, which PTF to select, use the function \code{which_PTF} first, to determine the suggested ptf, based on the available predictor variable.
#' (insert cross reference to the function, here.)
#'
#' @param target A vector of length \code{1} specifying the target variables to be predicted.
#'
#'      > insert table of which ones are available < or do that in details
#'
#' @param query either predictions for predictions of the parameters or quantiles for prediction of the uncertainties.
#' @param target either predictions for predictions of the parameters or quantiles for prediction of the uncertainties.
#' @param quantiles a vector of numeric values for calculating the quantiles at
#' @return
#'  \itemize{
#'         \item a data.frame with predicted target variables if no quantiles are predicted.
#'         \item a list with predicted target variables if quantiles are predicted.
#' }
#' @importFrom Rdpack reprompt
#' @references{
#'   \insertRef{Szabo.2020}{euptf2}
#' }
#' @examples
#' data(sample_data)
#' result <- euptfFun(ptf, predictor = sample_data, target = "THS", query = "predictions", quantiles = c(.05,.25,.5,.75,.95))
#' @export
euptfFun <- function(ptf, predictor, target = "THS", query = "predictions", quantiles = c(.05,.25,.5,.75,.95)){

        #' @importFrom utils data
        #' @importFrom stats predict
        #' @importFrom data.table is.data.table

        # load helper data

        data("suggested_PTF")
        query.target <- colnames(suggested_PTF)[-1]

        # CHECKS ----
        ## for ptf
        if(length(ptf) != 1){stop("argument ptf has to be length 1")}
        if(nchar(ptf)!=5){stop("number of characters in ptf has to be 5. Try inserting a leading zero in the single digit numbers")}
        if(isFALSE(is.character(ptf))){stop("argument ptf has to be a character")}
        # if(isFALSE(is.vector(ptf))){warning(paste("Provide argument ptf as a vector, ptf is a", class(ptf)[1]))}

        ptf <- toupper(ptf)
        if(substr(ptf,1,3)!="PTF"){stop("first three characters of the ptf have to be PTF")}
        if(is.na(as.numeric(substr(ptf,4,5)))){stop("fourth and fifth characters have to specify the PTF number, e.g. 29")}
        if(!as.numeric(substr(ptf,4,5))%in%1:32){stop(paste("\n","Valid PTF numbers are 1, 2,...,32", "\n", as.numeric(substr(ptf,4,5)),"was provided"))}

        ## for predictor

        if(!any(c(is.data.frame(predictor), is.numeric(predictor), is.data.table(predictor)))){stop("predictor has to be class vector, data.frame or data.table ")}

        # if(all(is.character(predictor))!=TRUE){stop("argument predictor has to be a character")}

        if(is.data.table(predictor) | is.data.frame(predictor) ){
                predictor.colnames <- colnames(predictor)
                if(is.null(predictor.colnames)){stop("provide column names for the data table/data frame")}
        }else if(is.vector(predictor) & is.null(names(predictor)) != TRUE ){
                predictor.colnames <- names(predictor)
        }else if(is.vector(predictor) & is.null(names(predictor)) == TRUE ){
                predictor.colnames <- predictor
        }else(stop("check that colnames or names of the predictor variable agree."))

        if(sum(c("USSAND", "USSILT","USCLAY", "DEPTH_M")%in%predictor.colnames)!=4){stop("column names in predictor has to contain at least USSAND, USSILT, USCLAY and DEPTH_M")}

        if(any(!abs((predictor$USSAND+predictor$USSCLAY+predictor$USSILT)-100) <= 1)){
                warning("not all texutures sum up to values between 99% and 101%")
        }

        ## for target
        # length 1
        if(length(target) != 1){stop("target has to be a vector of length 1, containing a single target variable name")}
        # is available
        if(!target%in%query.target){stop(paste("target has to be one of: ", paste(query.target, collapse =" ")))}

        ## for quantiles
        if(!all(quantiles > 0 & quantiles < 1)){stop("quantiles have to be given between 0 and 1")}

        ## for query
        if(!is.character(query)){stop("query has to be a character")}
        if(!query%in%c("predictions", "quantiles")){stop("query has to be specified as predictions or quantiles")}

        query.colnam <- colnames(predictor)
        query.ptf    <- as.numeric(unlist(strsplit(ptf, "PTF"))[2])
        if(is.na(query.ptf)){stop("ptf was ill specified, try capitilisation of letters")}
        query.ptf    <- suggested_PTF[query.ptf, ]
        query.ptf    <- unlist(strsplit(unlist(query.ptf[1])[1], "\\+"))

        # does input and required data match?
        if(sum(query.colnam %in% query.ptf) != length(query.ptf)){stop("the provided input columnames in predictor do not match the specified PTF")}

        predictor <- cbind("OBS_ID" = 1:nrow(predictor), predictor)
        dim_old   <- dim(predictor)
        predictor <- predictor[complete.cases(predictor[,query.ptf]),]
        dim_new   <- dim(predictor)

        if(!all(dim_old == dim_new)){
                warning(paste("For", ptf, "incomplete data was detected in predictor. Incomplete cases were removed.
                              \n Output has now a different number of rows than predictor. \n calculation continued \n"))

        }

        # PREPARE -----
        # The name of the data object which has to be called
        PTF_object_name <- paste(target, ptf, sep = "_")

        # load the data
        ptf_object      <- load_PTF_object(x = PTF_object_name)
        # print(ptf_object)
        # predict
        result <- switch(query,
                         "predictions" = {
                                 suppressWarnings(ptfFun.pred(ptf.object = ptf_object, df = predictor) )
                         },
                         "quantiles" = {
                                 suppressWarnings(ptfFun.quant(ptf.object = ptf_object, df = predictor, quantiles = quantiles))
                         })


        # back-transform parameters
        if(target %in% c("VG", "MVG")){
                result <- switch(query,
                                 "predictions" = {
                                         # account for VG vs / MVG differentiation, here, not in ptf.transFun, but
                                         # in the script. ptf.transfun is order sensitive, and requires 6 columns in df.

                                         res          <- ptf.transFun(result)

                                         if(target=="MVG"){
                                                 colnames(res)<- c("THS", "THR", "ALP", "N", "K0", "TAU")
                                         }else{
                                                 colnames(res)<- c("THS", "THR", "ALP", "N")
                                         }
                                         res          <- cbind(res, "M" = 1-1/res[,"N"])
                                         res
                                 },
                                 "quantiles" = {
                                         result[[2]] <- 10^result[[2]] - 1
                                         result[[3]] <- 10^result[[3]]
                                         result[[4]] <- 10^result[[4]]  + 1

                                         if(target=="MVG"){
                                                 result[[5]]  <- 10^result[[5]]
                                         }
                                         result
                                 })
                #
                # rename columns of the output list or data.frame
                switch(query,
                       "predictions" = {
                               result  <- data.frame("OBS_ID" = predictor$OBS_ID, result)
                               colnames(result)[-1] <- paste(colnames(result), ptf, sep = "_")[-1]
                       },
                       "quantiles" = {
                               if(target == "VG"){
                                       names(result) <- paste(c("THS", "THR", "ALP", "N"), ptf, sep = "_")
                                       result <- lapply(result, function(x) cbind("OLD_ID" = predictor$OBS_ID, x))
                               }
                               if(target == "MVG"){
                                       names(result) <- paste(c("THS", "THR", "ALP", "N", "K0", "L"), ptf, sep = "_")
                                       result <- lapply(result, function(x) cbind("OLD_ID" = predictor$OBS_ID, x))
                               }
                       }
                )


        }else{# non VG und MVG cases
                switch(query,
                       "predictions" = {
                               result <- data.frame("result" =  result)
                               colnames(result) <- paste(target, ptf, sep = "_")
                       },"quantiles" = {
                               colnames(result) <- paste(target, ptf, colnames(result), sep = "_")
                       }
                )
        }

        if(target == "KS"){
                result <- 10^result
        }

        # For Prudence: add the input data to the output data
        if(query == "predictions"  ){

                # result <- cbind("OBS_ID" = predictor$OBS_ID, result, predictor[,-1])
                result <- cbind(result, predictor)
        }
        if(query == "quantiles" & !target%in% c("MVG", "VG")){
                result <- cbind(result, predictor)
        }

        return(result)
}

