# Checking built forest, e.g.:
# - general check of the No. 7 built forest (PTF):
rm(list = ls())
library(ranger); library(magrittr)


rm(list = ls())

#### all (not MVG/VG) ----------------------
path_out     <- "./data/"
path_in      <- "C:/Users/tkdweber/Dropbox/Work Toby Brigi/euptfs_v2/final_PTFs/"

sel <- -c(1,grep(paste(c("MVG", "VG", "old"), collapse = "|"), list.dirs(path_in, full.names = FALSE), invert = FALSE))
targets      <- list.dirs(path_in, full.names = FALSE)[sel]
path_targets <- list.dirs(path_in, full.names = TRUE, recursive = TRUE)[sel]

dfile <- file.path(path_out,lapply(path_targets, list.files, recursive = TRUE, full.names = FALSE) %>% unlist)
sfile <- lapply(path_targets, list.files, recursive = TRUE, full.names = TRUE) %>% unlist

mapply(file.copy,
       from = sfile, to = dfile)


# emptyList <- lapply(X = path_targets, function(x) {
#
#      this_target     <- list.files(x)
#      this_path_target<- list.files(x, full.names = TRUE)
#      query.ptf       <- strsplit(this_target, split = c(".rdata|_")) %>% do.call(what = "rbind")
#      ncol.query.ptf  <- ncol(query.ptf)
#      nptfs           <- query.ptf[ ,ncol.query.ptf]
#
#      lapply(this_path_target, load, environment())
#
#      result <- lapply(ls()[grep(paste(nptfs, collapse="|"), ls())], function(y){
#           get(x = y)})
#      names(result) <- nptfs
#      return(result)
# })

names(emptyList) <- targets

# save them to disk

#### VG ----------------------

# Checking built forest, e.g.:
# - general check of the No. 7 built forest (PTF):
library(ranger); library(magrittr)

path_in      <- "C:/Users/tkdweber/Dropbox/Work Toby Brigi/euptfs_v2/final_PTFs/"

targets      <- list.files(path_in, full.names = TRUE, pattern = "VG", recursive = FALSE)[2]
path_targets <- list.files(targets, full.names = TRUE, recursive = TRUE)

vg.ptf       <- paste0("PTF",sprintf("%02d", c(1:16,21:22,24:25,29)))

sel.sort     <- c(4,3,1,2)

sel.shp      <- c("THS", "log10THR",  "log10ALP","log10N_1")

gg <- lapply(vg.ptf, function(y){

     vector_targets <- path_targets[grep(y, path_targets)]
     lapply(vector_targets, load, environment())

     namez <- ls()[grep(paste(sel.shp, collapse="|"), ls())][sel.sort]

     result <- lapply(namez, function(yy){
          get(x = yy)})

     names(result) <- namez
     return(result)
})

names(gg) <- paste("VG",vg.ptf, sep = "_")

# lapply(names(gg), function(x) x1 <- gg[[x]] )
# # write out
mapply(function(x, y){
     save(x, file = y)
}, x = gg
, y = file.path(path_out, paste0(paste(names(gg), sep = "_"), ".rdata"))
)
#
#
#

for(i in 1:length(gg)){

        load(file.path(path_out, paste0(paste(names(gg), sep = "_"), ".rdata"))[i])

        gdata::mv(from =  "x", to = names(gg[i]))
        save(list = ls()[grep(ls(), pattern = names(gg[i]))]
             , file = file.path(path_out, paste0(paste(names(gg), sep = "_"), ".rdata"))[i]
             , compress = "xz")

        rm(list = ls()[grep(ls(), pattern = "VG_")])
 }

#### MVG ----------------------

# Checking built forest, e.g.:
# - general check of the No. 7 built forest (PTF):
library(ranger); library(magrittr)

rm(list = ls())

path_in      <- "C:/Users/tkdweber/Dropbox/Work Toby Brigi/euptfs_v2/final_PTFs/"

targets      <- list.files(path_in, full.names = TRUE, pattern = "MVG", recursive = FALSE)
path_targets <- list.files(path_in, full.names = TRUE, pattern = "MVG", recursive = TRUE)

mvg.ptf      <- paste0("PTF",sprintf("%02d", c(1,2,4,5,6,12,13,20,21,23,27,28,29)))

sel.sort     <- c(6,5,2,4,3,1)

sel.shp      <- c("THS", "log10THR",  "log10ALP","log10N_1","log10K0", "L" )

gg <- lapply(mvg.ptf, function(y){

     vector_targets <- path_targets[grep(y, path_targets)]
     lapply(vector_targets, load, environment())

     namez <- ls()[grep(paste(sel.shp, collapse="|"), ls())][sel.sort]

     result <- lapply(namez, function(yy){
          get(x = yy)})

     names(result) <- namez
     return(result)
})


names(gg) <- paste("MVG",mvg.ptf, sep = "_")

# lapply(names(gg), function(x) x1 <- gg[[x]] )
# # write out
mapply(function(x, y){
        save(x, file = y)
}, x = gg
, y = file.path(path_out, paste0(paste(names(gg), sep = "_"), ".rdata"))
)
#
#
#

for(i in 1:length(gg)){

        load(file.path(path_out, paste0(paste(names(gg), sep = "_"), ".rdata"))[i])

        gdata::mv(from =  "x", to = names(gg[i]))
        save(list = ls()[grep(ls(), pattern = names(gg[i]))]
             , file = file.path(path_out, paste0(paste(names(gg), sep = "_"), ".rdata"))[i]
             , compress = "xz")

        rm(list = ls()[grep(ls(), pattern = "MVG_")])
}
