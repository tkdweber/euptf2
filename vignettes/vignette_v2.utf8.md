---
title: "R package of updated European hydraulic pedotransfer functions (euptf2)"
output: rmarkdown::html_vignette
author: "Tobias KD Weber, Melanie Weynants, Brigitta Szabó"
date: "17 November 2020"
vignette: >
  %\VignetteIndexEntry{vignette_v2}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



The `euptf2` package provides pedotransfer functions (PTFs) for the prediction of hydraulic properties in European soils. The PTFs were trained and validated on subsets of the European Hydropedological Data Inventory (Weynants et al., 2013, EU-HYDI). The methodology and the results are published in the Journal Geoscientific Model Development (Szabó et al., 2020).

This vignette is a short tutorial explaining how to use the PTFs and how to export the results outside R for non-R users.

## Installation

Install the development version from GitHub:


```r
# install the devtools package if not yet done:
if (!"devtools" %in% IP){install.packages("devtools")}
devtools::install_github("tkdweber/euptf2")
```

## Usage

The predictions can be performed through the following steps.

Load the package:


```r
# load the package:
library(euptf2)
#> Loading required package: plyr
#> Loading required package: stringr
#> Loading required package: data.table
#> Loading required package: ranger
```

**1. Data preparation** Before using the PTFs you need to format your data so that the package's functions can access them. An example data frame is provided:


```r
data(sample_data)
```

```r
sample_data
#>    SAMPLE_ID DEPTH_M USSAND USSILT USCLAY   OC   BD PH_H2O CACO3  CEC
#> 1        801    60.0    1.0   53.0   46.0 1.69 1.41    7.9   3.6 43.4
#> 2        802    20.0    3.4   58.1   38.6 3.16 1.34    7.5   1.9 44.8
#> 3        803    62.5    1.1   62.6   36.3 1.00 1.53    8.1   4.6 40.0
#> 4        804    22.5    1.4   62.3   36.3 2.46 1.40    7.7   2.3 42.2
#> 5        805   105.0    3.4   67.0   29.7 1.20 1.49    8.1   6.0 40.0
#> 6        806    30.0    9.0   52.0   38.9 2.42 1.37    7.4   6.0 46.1
#> 7        807    90.0    7.8   54.0   38.1 1.00 1.49    7.7  31.0 42.7
#> 8        808   150.0   10.6   57.1   32.3 0.60 1.45    7.9  45.0 45.9
#> 9        809    25.0   34.9   47.8   17.3 1.20 1.50    7.5   1.3 25.5
#> 10       810    10.0   34.3   49.3   16.4 1.27 1.57    7.4   1.3 30.9
```

When creating a new data frame, the available variables should be named as in the example. If one of the variables has no observations, it can be omitted from the data frame. Missing values should be assigned value NA. The name, unit, data type of soil properties in the dataset should be as given in Szabó et al. (2020).

For non R users, the data can also be prepared in an other software and imported into R. In that case, the names of the columns have to be respected in the source file. For example, data prepared in an Excel workbook named myworksheet.xlsx could be imported either by first saving the relevant Excel worksheet in comma separated table, for instance myworksheet.csv or by importing them directly:


```r
# import data from csv file:
mydata <- read.csv("myworksheet.csv")

# import data from xlsx file with package xlsx:
# install the xlsx package if not yet done:
if (!"xlsx" %in% IP){install.packages("xlsx")}
# load the package:
library("xlsx")
# import data from xlsx file:
mydata <- read.xlsx("myworkbook.xlsx", sheetName="myworksheet")
# see ?read.xlsx for more options
```


**2. Choosing the right PTF** The function which_PTF() returns a suggested PTF based on the available (that is provided) predictor variables and optionally a specified target variable. The following soil hydraulic parameters can be computed with the package:

- water content at saturation (THS) [cm3/cm3]: water content at 0 cm matric potential head;
- water content at field capacity at
	-100 cm matric potential head (FC_2) [cm3/cm3], and
	-330 cm matric potential head (FC) [cm3/cm3];
- water content at wilting point (WP) [cm3/cm3]: water content at -15,000 cm matric potential head;
- plant available water content (AWC) [cm3/cm3] based on the following equations:

	AWC=FC-WP									(1)
	
	AWC_2=FC_2-WP									(2)
- saturated hydraulic conductivity (KS) [cm/day]: hydraulic conductivity at 0 cm matric potential head;
- Mualem-van Genuchten model parameters (VG; for the water retention model only, MVG; for the water retention and hydraulic conductivity model).


```r
# check which_PTF to use to predict THS based on the predictor variables available in sample_data
which_PTF(predictor= sample_data, target = c("THS"))
#> 
#> 
#> 
#> Use   PTF03   to predict    THS
#>      THS
#> 1: PTF03

# check which_PTF to use to predict multiple soil hydraulic properties
which_PTF(predictor= sample_data, target = c("THS", "FC", "WP", "KS", "VG", "MVG"))
#> 
#> 
#> 
#> Use   PTF03   to predict    THS
#> 
#> Use   PTF03   to predict    FC
#> 
#> Use   PTF01   to predict    WP
#> 
#> Use   PTF05   to predict    KS
#> 
#> Use   PTF11   to predict    VG
#> 
#> Use   PTF23   to predict    MVG
#>      THS    FC    WP    KS    VG   MVG
#> 1: PTF03 PTF03 PTF01 PTF05 PTF11 PTF23
```

The result is conditional to the provided set of predictor variables such as USSAND, USSILT, USCLAY and DEPTH_M. The suggested_PTF data lists the recommended pedotransfer functions (PTF) by predicted soil hydraulic property and available predictor variables (Table 11 in Szabó et al. (2020)):


```r
data(suggested_PTF)
suggested_PTF
```

**3. Running the PTFs** Once the data are ready and the PTF has been chosen, it can be called with function euptfFun. The output of the function varies from one PTF to another, depending if prediction of quantiles are required. Let's take some examples that can illustrate the different cases and run them on the example dataset sample_data.

Parameter estimation:


```r
# predict parameters of the van Genuchten model (VG)
pred_VG <- euptfFun(ptf = "PTF11", predictor = sample_data, target = "VG", query = "predictions")
pred_VG
#>    OBS_ID THS_PTF11  THR_PTF11   ALP_PTF11  N_PTF11   M_PTF11 OBS_ID SAMPLE_ID
#> 1       1 0.4525725 0.02138011 0.003012617 1.220249 0.1804954      1       801
#> 2       2 0.4694341 0.01969870 0.004956295 1.214478 0.1766010      2       802
#> 3       3 0.4096313 0.02323656 0.003081313 1.243543 0.1958462      3       803
#> 4       4 0.4346168 0.03499473 0.003032626 1.241919 0.1947943      4       804
#> 5       5 0.4264491 0.02076698 0.004206764 1.232170 0.1884237      5       805
#> 6       6 0.4658808 0.01429767 0.010254010 1.192185 0.1612041      6       806
#> 7       7 0.4333395 0.01646192 0.005642242 1.214627 0.1767022      7       807
#> 8       8 0.4394707 0.02453333 0.005462810 1.249553 0.1997141      8       808
#> 9       9 0.4198857 0.01049133 0.013029620 1.228008 0.1856732      9       809
#> 10     10 0.4057881 0.01088939 0.012772311 1.224139 0.1830994     10       810
#>    DEPTH_M USSAND USSILT USCLAY   OC   BD PH_H2O CACO3  CEC
#> 1     60.0    1.0   53.0   46.0 1.69 1.41    7.9   3.6 43.4
#> 2     20.0    3.4   58.1   38.6 3.16 1.34    7.5   1.9 44.8
#> 3     62.5    1.1   62.6   36.3 1.00 1.53    8.1   4.6 40.0
#> 4     22.5    1.4   62.3   36.3 2.46 1.40    7.7   2.3 42.2
#> 5    105.0    3.4   67.0   29.7 1.20 1.49    8.1   6.0 40.0
#> 6     30.0    9.0   52.0   38.9 2.42 1.37    7.4   6.0 46.1
#> 7     90.0    7.8   54.0   38.1 1.00 1.49    7.7  31.0 42.7
#> 8    150.0   10.6   57.1   32.3 0.60 1.45    7.9  45.0 45.9
#> 9     25.0   34.9   47.8   17.3 1.20 1.50    7.5   1.3 25.5
#> 10    10.0   34.3   49.3   16.4 1.27 1.57    7.4   1.3 30.9

# predict VG with predefined quantiles
pred_VG_q <- euptfFun(ptf = "PTF11", predictor = sample_data, target = "VG", query = "quantiles", quantiles = c(0.1, 0.5, 0.9))
pred_VG_q
#> $THS_PTF11
#>       OLD_ID quantile= 0.1 quantile= 0.5 quantile= 0.9
#>  [1,]      1     0.3758036     0.4600403     0.4926723
#>  [2,]      2     0.3855742     0.4794434     0.5268559
#>  [3,]      3     0.3758036     0.4145375     0.4414298
#>  [4,]      4     0.3557563     0.4458334     0.4905164
#>  [5,]      5     0.3623991     0.4384784     0.4623176
#>  [6,]      6     0.4161750     0.4698349     0.5022655
#>  [7,]      7     0.3892791     0.4414298     0.4578957
#>  [8,]      8     0.3784891     0.4461427     0.4897307
#>  [9,]      9     0.3798153     0.4243993     0.4527968
#> [10,]     10     0.3492810     0.4021911     0.4316552
#> 
#> $THR_PTF11
#>       OLD_ID quantile= 0.1 quantile= 0.5 quantile= 0.9
#>  [1,]      1             0             0    0.13737601
#>  [2,]      2             0             0    0.08951102
#>  [3,]      3             0             0    0.13677970
#>  [4,]      4             0             0    0.15385150
#>  [5,]      5             0             0    0.10447500
#>  [6,]      6             0             0    0.08205653
#>  [7,]      7             0             0    0.06111657
#>  [8,]      8             0             0    0.11149946
#>  [9,]      9             0             0    0.06661793
#> [10,]     10             0             0    0.06661793
#> 
#> $ALP_PTF11
#>       OLD_ID quantile= 0.1 quantile= 0.5 quantile= 0.9
#>  [1,]      1  0.0004633615   0.004555535    0.03370950
#>  [2,]      2  0.0002722474   0.006146634    0.05814848
#>  [3,]      3  0.0003149742   0.002374609    0.03255895
#>  [4,]      4  0.0003149742   0.002861682    0.02400840
#>  [5,]      5  0.0008487525   0.003636789    0.05976881
#>  [6,]      6  0.0012824054   0.011559993    0.21629040
#>  [7,]      7  0.0007054351   0.006099480    0.02933736
#>  [8,]      8  0.0001858580   0.006146634    0.05721784
#>  [9,]      9  0.0031507070   0.012641660    0.05814778
#> [10,]     10  0.0035562933   0.012564451    0.05635863
#> 
#> $N_PTF11
#>       OLD_ID quantile= 0.1 quantile= 0.5 quantile= 0.9
#>  [1,]      1      1.084128      1.245593      1.340236
#>  [2,]      2      1.106513      1.186037      1.378603
#>  [3,]      3      1.107217      1.255302      1.510439
#>  [4,]      4      1.111579      1.252936      1.510439
#>  [5,]      5      1.108516      1.253372      1.371152
#>  [6,]      6      1.088440      1.205171      1.298184
#>  [7,]      7      1.090876      1.200842      1.481073
#>  [8,]      8      1.113091      1.229774      1.481073
#>  [9,]      9      1.130530      1.232723      1.302176
#> [10,]     10      1.142623      1.226641      1.301559

# please note that output is list, can be formatted to data frame:
pred_VG_q.df <- as.data.frame(pred_VG_q)

# predict parameters of the Mualem-van Genuchten model (MVG)
pred_MVG <- euptfFun(ptf = "PTF05", predictor = sample_data, target = "MVG", query = "predictions")
pred_MVG
#>    OBS_ID THS_PTF05  THR_PTF05  ALP_PTF05  N_PTF05  K0_PTF05 TAU_PTF05
#> 1       1 0.5125947 0.03910288 0.07190149 1.114352 136.86973 -4.442060
#> 2       2 0.5163581 0.04085018 0.05396194 1.133638  99.44281 -2.960080
#> 3       3 0.4972545 0.04984928 0.04619772 1.156112  71.30923 -4.229289
#> 4       4 0.5169550 0.04388186 0.04929935 1.157375  98.41656 -4.065015
#> 5       5 0.4779253 0.04769280 0.02599210 1.165111  50.97020 -4.050940
#> 6       6 0.4998801 0.03988877 0.05230811 1.137353  68.69971 -2.878928
#> 7       7 0.4752784 0.04689760 0.03474308 1.147174  43.34225 -3.965977
#> 8       8 0.4580555 0.06105130 0.02318105 1.178909  30.31429 -3.689226
#> 9       9 0.4351635 0.06942873 0.02563644 1.231165  35.15156 -2.951609
#> 10     10 0.4535633 0.07993340 0.02792337 1.324397  40.88664 -1.996218
#>      M_PTF05 OBS_ID SAMPLE_ID DEPTH_M USSAND USSILT USCLAY   OC   BD PH_H2O
#> 1  0.1026173      1       801    60.0    1.0   53.0   46.0 1.69 1.41    7.9
#> 2  0.1178841      2       802    20.0    3.4   58.1   38.6 3.16 1.34    7.5
#> 3  0.1350322      3       803    62.5    1.1   62.6   36.3 1.00 1.53    8.1
#> 4  0.1359758      4       804    22.5    1.4   62.3   36.3 2.46 1.40    7.7
#> 5  0.1417130      5       805   105.0    3.4   67.0   29.7 1.20 1.49    8.1
#> 6  0.1207654      6       806    30.0    9.0   52.0   38.9 2.42 1.37    7.4
#> 7  0.1282929      7       807    90.0    7.8   54.0   38.1 1.00 1.49    7.7
#> 8  0.1517581      8       808   150.0   10.6   57.1   32.3 0.60 1.45    7.9
#> 9  0.1877610      9       809    25.0   34.9   47.8   17.3 1.20 1.50    7.5
#> 10 0.2449396     10       810    10.0   34.3   49.3   16.4 1.27 1.57    7.4
#>    CACO3  CEC
#> 1    3.6 43.4
#> 2    1.9 44.8
#> 3    4.6 40.0
#> 4    2.3 42.2
#> 5    6.0 40.0
#> 6    6.0 46.1
#> 7   31.0 42.7
#> 8   45.0 45.9
#> 9    1.3 25.5
#> 10   1.3 30.9
```

Point estimation:


```r
# predict saturated water content (THS)
pred_THS <- euptfFun(ptf = "PTF03", predictor = sample_data, target = "THS", query = "predictions")
pred_THS
#>    THS_PTF03 OBS_ID SAMPLE_ID DEPTH_M USSAND USSILT USCLAY   OC   BD PH_H2O
#> 1  0.4680155      1       801    60.0    1.0   53.0   46.0 1.69 1.41    7.9
#> 2  0.4837732      2       802    20.0    3.4   58.1   38.6 3.16 1.34    7.5
#> 3  0.4324118      3       803    62.5    1.1   62.6   36.3 1.00 1.53    8.1
#> 4  0.4716993      4       804    22.5    1.4   62.3   36.3 2.46 1.40    7.7
#> 5  0.4484716      5       805   105.0    3.4   67.0   29.7 1.20 1.49    8.1
#> 6  0.4845906      6       806    30.0    9.0   52.0   38.9 2.42 1.37    7.4
#> 7  0.4388267      7       807    90.0    7.8   54.0   38.1 1.00 1.49    7.7
#> 8  0.4502922      8       808   150.0   10.6   57.1   32.3 0.60 1.45    7.9
#> 9  0.4453103      9       809    25.0   34.9   47.8   17.3 1.20 1.50    7.5
#> 10 0.4057250     10       810    10.0   34.3   49.3   16.4 1.27 1.57    7.4
#>    CACO3  CEC
#> 1    3.6 43.4
#> 2    1.9 44.8
#> 3    4.6 40.0
#> 4    2.3 42.2
#> 5    6.0 40.0
#> 6    6.0 46.1
#> 7   31.0 42.7
#> 8   45.0 45.9
#> 9    1.3 25.5
#> 10   1.3 30.9

# predict THS with predefined quantiles
pred_THS_q <- euptfFun(ptf = "PTF03", predictor = sample_data, target = "THS", query = "quantiles", quantiles = c(0.05, 0.5, 0.95))
pred_THS_q
#>    THS_PTF03_quantile= 0.05 THS_PTF03_quantile= 0.5 THS_PTF03_quantile= 0.95
#> 1                   0.43260                  0.4650                  0.52210
#> 2                   0.37200                  0.4890                  0.51500
#> 3                   0.40000                  0.4360                  0.46600
#> 4                   0.43775                  0.4710                  0.49965
#> 5                   0.41975                  0.4415                  0.47600
#> 6                   0.45555                  0.4840                  0.52600
#> 7                   0.40500                  0.4370                  0.46600
#> 8                   0.42295                  0.4510                  0.48900
#> 9                   0.39182                  0.4500                  0.47000
#> 10                  0.37085                  0.4030                  0.45218
#>    OBS_ID SAMPLE_ID DEPTH_M USSAND USSILT USCLAY   OC   BD PH_H2O CACO3  CEC
#> 1       1       801    60.0    1.0   53.0   46.0 1.69 1.41    7.9   3.6 43.4
#> 2       2       802    20.0    3.4   58.1   38.6 3.16 1.34    7.5   1.9 44.8
#> 3       3       803    62.5    1.1   62.6   36.3 1.00 1.53    8.1   4.6 40.0
#> 4       4       804    22.5    1.4   62.3   36.3 2.46 1.40    7.7   2.3 42.2
#> 5       5       805   105.0    3.4   67.0   29.7 1.20 1.49    8.1   6.0 40.0
#> 6       6       806    30.0    9.0   52.0   38.9 2.42 1.37    7.4   6.0 46.1
#> 7       7       807    90.0    7.8   54.0   38.1 1.00 1.49    7.7  31.0 42.7
#> 8       8       808   150.0   10.6   57.1   32.3 0.60 1.45    7.9  45.0 45.9
#> 9       9       809    25.0   34.9   47.8   17.3 1.20 1.50    7.5   1.3 25.5
#> 10     10       810    10.0   34.3   49.3   16.4 1.27 1.57    7.4   1.3 30.9

# predict saturated hydraulic conductivity (KS)
pred_KS <- euptfFun(ptf = "PTF05", predictor = sample_data, target = "KS", query = "predictions")
pred_KS
#>      KS_PTF05 OBS_ID SAMPLE_ID DEPTH_M USSAND USSILT USCLAY   OC   BD PH_H2O
#> 1    4.298604      1       801    60.0    1.0   53.0   46.0 1.69 1.41    7.9
#> 2    2.800375      2       802    20.0    3.4   58.1   38.6 3.16 1.34    7.5
#> 3    4.357384      3       803    62.5    1.1   62.6   36.3 1.00 1.53    8.1
#> 4    4.397835      4       804    22.5    1.4   62.3   36.3 2.46 1.40    7.7
#> 5    3.522154      5       805   105.0    3.4   67.0   29.7 1.20 1.49    8.1
#> 6    3.632902      6       806    30.0    9.0   52.0   38.9 2.42 1.37    7.4
#> 7    1.967128      7       807    90.0    7.8   54.0   38.1 1.00 1.49    7.7
#> 8    7.497750      8       808   150.0   10.6   57.1   32.3 0.60 1.45    7.9
#> 9   66.198044      9       809    25.0   34.9   47.8   17.3 1.20 1.50    7.5
#> 10 118.422040     10       810    10.0   34.3   49.3   16.4 1.27 1.57    7.4
#>    CACO3  CEC
#> 1    3.6 43.4
#> 2    1.9 44.8
#> 3    4.6 40.0
#> 4    2.3 42.2
#> 5    6.0 40.0
#> 6    6.0 46.1
#> 7   31.0 42.7
#> 8   45.0 45.9
#> 9    1.3 25.5
#> 10   1.3 30.9
```

**4. Exporting the results**
For non-R users, the results can be exported for use with other software, either as text files or directly in Excel. For example, the two ways of predicting the saturated water content can be exported as a table:


```r
# example to save the predicted values to a csv file:
write.csv(pred_THS, file = "pred_THS.csv", row.names = FALSE)
# see ?write.csv for additional options

# example to save predicted values to xlsx file:
# install the openxlsx package if not yet done:
if (!"openxlsx" %in% IP){install.packages("openxlsx")}
library(openxlsx)
write.xlsx(data.KS.VG, file = "pred_THS.xlsx")
```





<!-- ***References*** -->

<!-- Szabó B., Weynants M., Weber TKD (2020). “Updated European hydraulic pedotransfer functions with communicated uncertainties in the predicted variables (euptfv2).” Geoscientific Model Development Discussions, 2020, 1–33. doi: 10.5194/gmd-2020-36, https://gmd.copernicus.org/preprints/gmd-2020-36/. -->

<!-- Weynants, M., Montanarella, L., Tóth, G., Arnoldussen, A., Anaya Romero, M., Bilas, G., Borresen, T., Cornelis, W., Daroussin, J., Gonçalves, M. D. C., Haugen, L.-E., Hennings, V., Houskova, B., Iovino, M., Javaux, M., Keay, C. A., Kätterer, T., Kvaerno, S., Laktinova, T., Lamorski, K., Lilly, A., Mako, A., Matula, S., Morari, F., Nemes, A., Patyka, N. V., Romano, N., Schindler, U., Shein, E., Slawinski, C., Strauss, P., Tóth, B. and Woesten, H.: European HYdropedological Data Inventory (EU-HYDI), EUR – Scientific and Technical Research series – ISSN 1831-9424, Luxembourg., 2013. -->
