library(data.table)

suggested_PTF <- fread("../euptf2_untracked/table11.csv", sep = "\t")

suggested_PTF$Predictor_variables <- stringr::str_replace(suggested_PTF$Predictor_variables,  pattern = "PSD", "USSAND+USSILT+USCLAY")

save(suggested_PTF, file='./data/suggested_PTF.rda')

class(suggested_PTF)
