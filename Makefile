PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

all: move rmd2md

move:
	cp -r inst/vign/img/ vignettes/img/;\
	cp inst/vign/spplit.md vignettes;\
	cp inst/vign/occurrences_meta.md vignettes;\
	cp inst/vign/geospatial_queries.md vignettes

rmd2md:
	cd vignettes;\
	mv spplit.md spplit.Rmd;\
	mv occurrences_meta.md occurrences_meta.Rmd;\
	mv geospatial_queries.md geospatial_queries.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

test:
	${RSCRIPT} -e "devtools::test()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"

