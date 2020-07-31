spplit
======



`spplit` - connect species occurrence data to literature

Possible workflow:

* get species occurrences
* get species list
* get BHL metadata
* get BHL ocr page content -> to corpus
* (optionally: vizualize ocr text with matches)
* save corpus

## Install

install dev versions of `rgbif` and `spocc` first, then install `spplit`


```r
devtools::install_github(c("ropensci/rgbif", "ropensci/spocc"))
devtools::install_github("ropenscilabs/spplit")
```


```r
library("spplit")
```

## Example - connect iDigBio species occurrence data to BHL

For access to Biodiveristy Heritage Library data, you'll need an API key from them.
To get one fill out the brief form at <https://www.biodiversitylibrary.org/getapikey.aspx> -
they'll ask for your name and email address.


```r
geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
res <- sp_occ_idigbio(geometry = geom, limit = 3) %>% 
  sp_list() %>% 
  sp_bhl_meta() %>% .[1:3] %>% 
  sp_bhl_ocr()
```

After getting text, could do one of a number of things:

a) Save text to disk (or any database, etc.)


```r
res %>% sp_bhl_save()
```

b) Mine the text


```r
library("tm")
src <- VectorSource(unlist(res, use.names = FALSE))
corp <- VCorpus(src)
corp <- tm_map(corp, removeWords, stopwords("english"))
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, removePunctuation)
tdm <- TermDocumentMatrix(corp)
findFreqTerms(tdm, lowfreq = 10)
#>  [1] "328"        "albizia"    "bot"        "brown"      "fig"       
#>  [6] "genera"     "java"       "key"        "long"       "lophantha" 
#> [11] "malesia"    "merr"       "new"        "non"        "schefflera"
#> [16] "species"    "the"        "tubers"
```

## Viewer

there's a tool for visualizing results from OCR. It's still a work in progress.


```r
geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
res <- sp_occ_gbif(geometry = geom)
x <- res %>% sp_list() %>% sp_bhl_meta()
out <- x[1:3] %>% sp_bhl_ocr
viewer(out)
```

![image](inst/img/viewer_eg1.png)

## Meta

* A collaboration with [California Academy of Sciences](http://www.calacademy.org/)
* Please [report any issues or bugs](https://github.com/ropenscilabs/spplit/issues)
* License: MIT
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

