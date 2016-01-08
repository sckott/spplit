spplit
======

[![Build Status](https://travis-ci.org/ropenscilabs/spplit.svg?branch=master)](https://travis-ci.org/ropenscilabs/spplit)

`spplit` - connect species occurrence data to literature

Possible workflow:

* get species occurrences
* get species list
* get BHL metadata
* get BHL ocr page content -> to corpus
* (optionally: vizualize ocr text with matches)
* save corpus

## Install


```r
devtools::install_github("ropenscilabs/spplit")
```


```r
library("spplit")
```

## Example - connect iDigBio species occurrence data to BHL


```r
geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
res <- sp_occ(geometry = geom, limit = 3) %>% 
  sp_list() %>% 
  sp_bhl_meta() %>% .[1:3] %>% 
  sp_bhl_ocr()
```

After getting text, could do one of a number of things:

a) Save text to disk (or any database, etc.)


```r
res %>% sp_bhl_save()
```

```
## ocr text written to files in 2016_01_08_10_17_54
```

b) Mine the text


```r
library("tm")
```

```
## Loading required package: NLP
```

```r
src <- VectorSource(unlist(res, use.names = FALSE))
corp <- VCorpus(src)
corp <- tm_map(corp, removeWords, stopwords("english"))
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, removePunctuation)
tdm <- TermDocumentMatrix(corp)
findFreqTerms(tdm, lowfreq = 10)
```

```
##  [1] "328"        "albizia"    "bot"        "brown"      "fig"       
##  [6] "genera"     "java"       "key"        "long"       "lophantha" 
## [11] "malesia"    "merr"       "new"        "non"        "schefflera"
## [16] "species"    "the"        "tubers"
```

## Meta

* A collaboration with [California Academy of Sciences](http://www.calacademy.org/)
* Please [report any issues or bugs](https://github.com/ropenscilabs/spplit/issues)
* License: MIT
