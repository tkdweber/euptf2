# euptf2
**R package of updated European hydraulic pedotransfer functions (euptf2)**

The euptf package  provides  pedotransfer  functions  (PTFs) for  the  prediction  of  hydraulic  properties in  European  soils. The  PTFs  were  trained  and  validated  on  subsets  of  the  European  Hydropedological Data Inventory (Weynants et al., 2013, EU-HYDI). The methodology and the results are published in the Journal Geoscientific Model Development (Szabó et al., 2020).

The package contains a sample input dataset
```{r eval=FALSE}
data(sample_data)
```
and an R script which shows some examples on how to apply the PTFs in R. 

As an alternate a web interface (https://ptfinterface.rissac.hu) facilitates too easy application of the updated prediction algorithms. The R scripts used to derive the updated European prediction algorithms are available from [here](https://github.com/TothSzaboBrigitta/euptfv2).

***Please cite as:***

Szabó, B., Weynants, M. and Weber, T. K. D. (2020) Updated European hydraulic pedotransfer functions with communicated uncertainties in the predicted variables (euptfv2). Submitted to Geoscientific Model Development.

Weber, T. K. D. (2020) SPECIFY TITLE, suggestion: R package of updated European hydraulic pedotransfer functios (euptf2).



*References:*

* Weynants, M., Montanarella, L., Tóth, G., Arnoldussen, A., Anaya Romero, M., Bilas, G., Borresen, T., Cornelis, W., Daroussin, J., Gonçalves, M. D. C., Haugen, L.-E., Hennings, V., Houskova, B., Iovino, M., Javaux, M., Keay, C. A., Kätterer, T., Kvaerno, S., Laktinova, T., Lamorski, K., Lilly, A., Mako, A., Matula, S., Morari, F., Nemes, A., Patyka, N. V., Romano, N., Schindler, U., Shein, E., Slawinski, C., Strauss, P., Tóth, B. and Woesten, H.: European HYdropedological Data Inventory (EU-HYDI), EUR – Scientific and Technical Research series – ISSN 1831-9424, Luxembourg., 2013.
