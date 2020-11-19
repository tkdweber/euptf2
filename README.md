# euptf2
**R package of updated European hydraulic pedotransfer functions (euptf2)**

The euptf package  provides  pedotransfer  functions  (PTFs) for  the  prediction  of  hydraulic  properties in  European  soils. The  PTFs  were  trained  and  validated  on  subsets  of  the  European  Hydropedological Data Inventory (Weynants et al., 2013, EU-HYDI). The methodology and the results are published in the Journal Geoscientific Model Development (Szabó et al., 2020).

The development version of the package can be installed from GitHub after opening an R session and typing the following at the command line:

```{r eval=FALSE}
# install the devtools package if not yet done:
if (!require("devtools")){install.packages("devtools"); library(devtools)}
if (!require("euptf2")){devtools::install_github("tkdweber/euptf2"); library(euptf2)}
```
The content of the package can be made available by loading it into the R session:

```{r eval=FALSE}
# load the package
library(euptf2)
```

The package contains a sample input dataset
```{r eval=FALSE}
data(sample_data)
```
and a vignette (https://github.com/tkdweber/euptf2/tree/master/vignettes)

```{r eval=FALSE}
vignette("euptf2")
```
shows some examples on how to apply the PTFs in R. 

Alternatively, a web interface (https://ptfinterface.rissac.hu) facilitates easy application of the updated prediction algorithms, too. The R scripts used to train, tune, and build the updated European prediction random forest algorithms are available from [here](https://github.com/TothSzaboBrigitta/euptfv2).

***Please cite as:***

Szabó, B., Weynants, M. and Weber, T. K. D. (2020) Updated European hydraulic pedotransfer functions with communicated uncertainties in the predicted variables (euptfv2). Geoscientific Model Development Discussions, 2020, 1–33. doi: 10.5194/gmd-2020-36, https://gmd.copernicus.org/preprints/gmd-2020-36/.

Weber, T. K. D., Weynants, M., Szabó, B. (2020) R package of updated European hydraulic pedotransfer functions (euptf2).



*References:*

* Weynants, M., Montanarella, L., Tóth, G., Arnoldussen, A., Anaya Romero, M., Bilas, G., Borresen, T., Cornelis, W., Daroussin, J., Gonçalves, M. D. C., Haugen, L.-E., Hennings, V., Houskova, B., Iovino, M., Javaux, M., Keay, C. A., Kätterer, T., Kvaerno, S., Laktinova, T., Lamorski, K., Lilly, A., Mako, A., Matula, S., Morari, F., Nemes, A., Patyka, N. V., Romano, N., Schindler, U., Shein, E., Slawinski, C., Strauss, P., Tóth, B. and Woesten, H. (2013) European HYdropedological Data Inventory (EU-HYDI), EUR – Scientific and Technical Research series – ISSN 1831-9424, Luxembourg.
