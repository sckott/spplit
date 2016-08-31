<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Geospatial Queries}
%\VignetteEncoding{UTF-8}
-->



Geospatial Queries
==================

`spplit` allows you query species occurrence data sources in a variety of ways. One of them
is via a geospatial definition. This geospatial definition can be a variety of different
things:

* Bounding box
* WKT - Well Known Text
* SpatialPolygons/SpatialPolygonsDataFrame

While GBIF allows only WKT submitted to their API, the user here can pass in all the things
above, and we internally convert to WKT.

While iDigBio allows only a bounding box submitted to their API, the user here can pass in
all the things above, and we internally convert to a bounding box.

Thus, as you can pass a detailed and complex WKT geospatial definition to GBIF and
it will get passed directlty to GBIF, that same complex WKT when passed to iDigBio will
first be simplified to a bounding box.

## Bounding boxes

A bounding box is a simple numeric vector of length 4, with the following format:

`[min-longitude, min-latitude, max-longitude, max-latitude]`

An example in R:

`c(-120, 40, -100, 45)`

where -120 is the min longitude, 40 is the min latitude, -100 is the max longitude
and 45 is the max latitude.

You can pass a bounding box to the `geometry` parameter in `sp_occ_gbif()`, or 
`sp_occ_idigbio()`. 

## WKT

WKT is a text string, and is defined by a set of spatial classes. Check out the Wikipedia entry
on WKT for more info ([https://en.wikipedia.org/wiki/Well-known_text](https://en.wikipedia.org/wiki/Well-known_text)).

The only type of WKT class you can use here is `POLYGON`. Other classes are defined in WKT,
but GBIF doesn't support any other class.

A simple example of a WKT string of a `POLYGON` class is:

```
POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))
```

You can pass a WKT string for a `POLYGON` to the `geometry` parameter in `sp_occ_gbif()`, or 
`sp_occ_idigbio()`. 

An easy to use website for getting WKT after drawing a shape on a map is
<http://arthur-e.github.io/Wicket/sandbox-gmaps3.html>.

You can get WKT from within R using the `wellknown` package <https://cran.r-project.org/package=wellknown>. With `wellknown` you can get 
WKT from R objects, and convert GeoJSON to WKT as well. For example:


```r
df <- us_cities[2:5,c('long','lat')]
df <- rbind(df, df[1,])
polygon(df, fmt=2)
#> [1] "POLYGON ((-81.52 41.08, -122.26 37.77, -84.18 31.58, -73.80 42.67, -81.52 41.08))"
```

## SpatialPolygons/SpatialPolygonsDataFrame

`SpatialPolygons` and `SpatialPolygonsDataFrame` are two classes of object defined in the package `sp` (<https://cran.r-project.org/package=sp>).
There are other object types defined in `sp`, but only these two are supported here.
We take those inputs internally and convert to a WKT for GBIF or a bounding box for
iDigBio.

You can create a `SpatialPolygons` object like:


```r
library("sp")
poly <- SpatialPolygons(list(Polygons(list(Polygon(cbind(
  c(-124.07, -119.99, -119.99, -124.07, -124.07),
  c(41.48, 41.48, 35.57, 35.57, 41.48)
))), "s1")), 1L)
class(poly)
#> [1] "SpatialPolygons"
#> attr(,"package")
#> [1] "sp"
```

Then use the `SpatialPolygons` class object for a geometry based search:


```r
library("spplit")
sp_occ_gbif(geometry = poly, limit = 10)
#> Geometry [<geo1> (10)] 
#> # A tibble: 10 × 70
#>                       name longitude latitude  prov         issues
#>                      <chr>     <dbl>    <dbl> <chr>          <chr>
#> 1    Meconella californica -122.8204 38.16849  gbif cdround,gass84
#> 2   Brachythecium albicans -122.6965 38.92440  gbif  cdrep,cdround
#> 3         Juncus capitatus -122.8963 39.10842  gbif  cdrep,cdround
#> 4    Metaneckera menziesii -122.3766 41.20893  gbif          cdrep
#> 5         Grimmia torquata -122.3766 41.20893  gbif          cdrep
#> 6     Vaccinium cespitosum -122.4362 37.69014  gbif               
#> 7   Fritillaria pluriflora -122.4809 38.80458  gbif cdround,gass84
#> 8    Orobanche fasciculata -120.9542 38.95750  gbif cdround,gass84
#> 9  Toxicoscordion fontanum -122.5999 38.40661  gbif cdround,gass84
#> 10    Angelica californica -122.6142 38.04393  gbif cdround,gass84
#> # ... with 65 more variables: key <int>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   elevation <dbl>, continent <chr>, stateProvince <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <date>, lastInterpreted <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, recordNumber <chr>,
#> #   identifier <chr>, habitat <chr>, verbatimEventDate <chr>,
#> #   nomenclaturalCode <chr>, higherGeography <chr>, institutionID <chr>,
#> #   locality <chr>, county <chr>, collectionCode <chr>, gbifID <chr>,
#> #   language <chr>, occurrenceID <chr>, type <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, otherCatalogNumbers <chr>, institutionCode <chr>,
#> #   startDayOfYear <chr>, verbatimElevation <chr>,
#> #   higherClassification <chr>, identifiedBy <chr>,
#> #   occurrenceRemarks <chr>
```

Same goes for `SpatialPolygonsDataFrame`
