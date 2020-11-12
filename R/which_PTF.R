#' Query which PTF can be used.
#'
#'@description If in doubt which pedotransfer function to use, apply this function. It returns a suggested PTF based on the available (that is provided)
#' predictor variables and optionally a specified target variable.
#' This is conditional to the provided set of predictor variables such as PSD and DEPTH
#'
#' @param predictor A vector of \code{n} strings specifying the available predictor variables. Alternatively, a data.table or data.frame with named columns.
#' @param target A vector of \code{m} elements with target variables to be predicted.
#'
#' @return A vector of length \code{m}, with suggested PTF to use.
#'
#' @details (insert a table for explanations, hereof. or, insert a link elsewehere)
#' PSD, DEPTH_M, OC, BD, CACO3, PH_H2O, CEC
#' THS  FC_2    FC    WP AWC_2   AWC    KS    VG   MVG
#'
#' @references
#' @author Tobias KD Weber, \email{tobias.weber@uni-hohenheim.de}
#' @author Brigitta Szabo, \email{toth.brigitta@atk.hu}
#' @import plyr
#' @examples
#' \dontrun{use_these <- which_PTF(predictor = c("USSAND", "USSILT","USCLAY" , "DEPTH_M"), target = c("THS", "VG"))}
#'
#' @export
which_PTF <- function(predictor, target = NULL) {

        # CHECKS ----
        ## for predictor

        if(!any(c(is.data.frame(predictor), is.vector(predictor), is.data.table(predictor)))){stop("predictor has to be class vector, data.frame or data.table ")
        }
        if(is.vector(predictor) & all(is.character(predictor))!=TRUE){stop("argument predictor has to be a character")
        }

        if(is.data.table(predictor) | is.data.frame(predictor) ){
                predictor <- colnames(predictor)
                if(is.null(predictor)){stop("provide column names for the data table/data frame")}
        }else if(is.vector(predictor) & is.null(names(predictor)) != TRUE ){
                predictor <- names(predictor)
        }else if(is.vector(predictor) & is.null(names(predictor)) == TRUE ){
                predictor <- predictor
        }else(stop("check that colnames or names of the predictor variable agree."))


        if(sum(c("USSAND", "USSILT","USCLAY", "DEPTH_M")%in%predictor)!=4){stop("predictor has to have USSAND, USSILT, USCLAY, and DEPTH_M as columnnames")}

        ## target
        if(all(is.character(target))!=TRUE ){stop("argument target has to be a character or default NULL")}
        if(is.null(target)){target = c("USSAND", "USSILT","USCLAY", "DEPTH_M", "OC", "BD", "CACO3", "PH_H20", "CEC")}

        # LOAD ----
        data("suggested_PTF", envir = environment())

        # PREPARE ----
        query <- suggested_PTF$Predictor_variables
        query <- strsplit(query, "\\+")
        query <- lapply(query, function(x) {
                int <- data.frame(x)
                int <- t(int)
                int <- as.data.frame(int)
                return(int)
        })
        query.unique <- unique(unlist(do.call("c", query)))

        query        <- do.call("rbind.fill", query)

        # query.test   <- apply(query,1, function(y){
        #         all(unlist(lapply(c("USSAND", "USSILT","USCLAY","DEPTH_M", "BD", "CACO3", "PH_H2O"), function(x){
        #                 x%in%y[!is.na(y)]
        #                 })
        #
        #
        #                 ))
        # })
        #
        # query[query.test,]
        # DO MATHC ----

        t1 <- lapply(apply(query,1, function(y){y[!is.na(y)]%in%c("USSAND", "USSILT","USCLAY","BD","DEPTH_M",  "CACO3", "PH_H2O")}), function(x) length(x)==length(c("USSAND", "USSILT","USCLAY","DEPTH_M", "BD", "CACO3", "PH_H2O")))
        t2 <- lapply(apply(query,1, function(y){y[!is.na(y)]%in%c("USSAND", "USSILT","USCLAY","BD","DEPTH_M",  "CACO3", "PH_H2O")}), all)

        result <- suggested_PTF[as.logical(unlist(t1)*unlist(t2)), target, with = FALSE]

        # PRINT OUT
        cat("\n", paste("Use  ", result, "  to predict   ", target), sep="\n\n", "\n" )

        # PRINT OUT
        return(result)
}
