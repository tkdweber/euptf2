# euptf2
**R package of updated European hydraulic pedotransfer functions (euptf2)**
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4281046.svg)](https://doi.org/10.5281/zenodo.4281046)

The euptf package  provides  pedotransfer  functions  (PTFs) for  the  prediction  of  hydraulic  properties in  European  soils. The  PTFs  were  trained  and  validated  on  subsets  of  the  European  Hydropedological Data Inventory (Weynants et al., 2013, EU-HYDI). The methodology and the results are published in the Journal Geoscientific Model Development (Szabó et al., 2021).

The development version of the package can be installed from GitHub after opening an R session and typing the following at the command line:

```{r eval=FALSE}
# install the devtools, glue and Rdpack packages if not yet done:
install.packages("devtools")
install.packages("glue")
install.packages("Rdpack")
devtools::install_github("tkdweber/euptf2")
```
Please note that Rtools.exe is needed to build packages under R >= 4.0.0. It has to be installed from https://cran.r-project.org/bin/windows/Rtools/, if not done before. If any packages or namespaces load fail please install the problematic package(s) separately.

The content of the package can be made available by loading it into the R session:

```{r eval=FALSE}
# load the package
library(euptf2)
```

The package contains a sample input dataset
```{r eval=FALSE}
data(sample_data)
```
and a [vignette](https://github.com/tkdweber/euptf2/tree/master/vignettes)
```{r eval=FALSE}
vignette("euptf2")
```
shows some examples on how to apply the PTFs in R. 

Alternatively, a web interface (https://ptfinterface.rissac.hu) facilitates easy application of the updated prediction algorithms, too. The R scripts used to train, tune, and build the updated European prediction random forest algorithms are available from [here](https://github.com/TothSzaboBrigitta/euptfv2).

***Practical guidance on how to use the PTFs***

The minimum input requirements for all PTFs are sand, silt and clay content, and soil depth. Soil depth is defined as the mean sampling depth, e.g. if PSD, BD and OC are provided for a soil sample from a depth of 0–20 cm, then the soil depth input (DEPTH) to the prediction algorithm is set to 10 cm.
If only soil texture information is available for the predictions, the class PTFs from euptfv1 could be applied (Tóth et al., 2015).

We emphasize that:
1. the units of input soil properties (predictors) have to be the same as indicated in the text and that the sand, silt, and clay are defined by the following particle diameters: clay< 2 μm, silt between 2 and 50 μm, and sand between 50 and 2000 μm, 20
2. when only specific water content values at saturation, field capacity or wilting point are required (i.e. THS, FC_2, FC, WP) it is recommended to use point PTFs. This is also true for the prediction of KS,
3. for AWC, the most accurate way is to predict FC and WP with the point predictions, first, and then compute AWC using Eq. (1), and similarly for AWC_2 using FC_2 and Eq. (2),
4. it is recommended to do the VG prediction if only moisture retention curve parameters are needed, and
5. the MVG prediction when both moisture retention and hydraulic conductivity parameters are required.


***Please cite as:***

Szabó, B., Weynants, M. and Weber, T. K. D. (2021) Updated European hydraulic pedotransfer functions with communicated uncertainties in the predicted variables (euptfv2). Geoscientific Model Development, 14, 151–175 [doi: 10.5194/gmd-14-151-2021](https://doi.org/10.5194/gmd-14-151-2021).

Weber, T. K. D., Weynants, M., Szabó, B. (2020) R package of updated European hydraulic pedotransfer functions (euptf2). [doi: 10.5281/zenodo.4281045](https://doi.org/10.5281/zenodo.4281045).


*References:*

* Weynants, M., Montanarella, L., Tóth, G., Arnoldussen, A., Anaya Romero, M., Bilas, G., Borresen, T., Cornelis, W., Daroussin, J., Gonçalves, M. D. C., Haugen, L.-E., Hennings, V., Houskova, B., Iovino, M., Javaux, M., Keay, C. A., Kätterer, T., Kvaerno, S., Laktinova, T., Lamorski, K., Lilly, A., Mako, A., Matula, S., Morari, F., Nemes, A., Patyka, N. V., Romano, N., Schindler, U., Shein, E., Slawinski, C., Strauss, P., Tóth, B. and Woesten, H. (2013) European HYdropedological Data Inventory (EU-HYDI), EUR – Scientific and Technical Research series – ISSN 1831-9424, Luxembourg.
