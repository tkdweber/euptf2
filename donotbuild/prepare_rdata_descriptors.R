# create the .R files for the rdata
library(stringr)

rm(list = ls());gc()
tpl      <- readLines("./donotbuild/rdata_descriptors/__all.tpl")
tpl_head <- readLines("./donotbuild/rdata_descriptors/__header.tpl")

path_in <- "C:/Users/tkdweber/Dropbox/Work Toby Brigi/euptfs_v2/final_PTFs/"
sel     <-  -c(1,grep(paste(c("old"), collapse = "|"), list.dirs(path_in, full.names = FALSE), invert = FALSE))

targets <- list.dirs(path_in, full.names = FALSE)[sel]
targets <- str_replace(targets, "KS", "log10KS")
for(i in 1:length(targets)){

     itarget <- targets[i]
     thefiles <- list.files("./data", pattern = itarget, ignore.case = TRUE)
     if(itarget =="VG"){
          thefiles <- grep(thefiles, pattern = "MVG", invert = TRUE, value = TRUE)
     }


     tpl_i <- tpl
     tpl_i <- str_replace(tpl_i, pattern = "\\$header", replacement = tpl_head[i])

     for(k in 1:length(thefiles)){

          tpl_k <- tpl_i

          substr_start <-  tail(gregexpr(pattern ='P', thefiles[k])[[1]],1)
          substr_end   <- substr_start + 4

          kptf         <- substr(thefiles[k], substr_start,substr_end)
          iktarget_PTF <- paste(itarget,"_",kptf, sep = "")

          tpl_k <- str_replace(tpl_k, pattern = "\\$PTF", replacement = kptf)

          tpl_k <- str_replace(tpl_k, pattern = "\\$target_PTF", replacement = iktarget_PTF)
          writeLines(text = tpl_k, con = str_replace(file.path("./R",thefiles[k]), pattern = "rdata", replacement = "R"))

     }
}
rm(list=ls())
