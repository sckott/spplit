all: move rmd2md

move:
		cp -r inst/vign/img/ vignettes/img/;\
		cp inst/vign/spplit_vignette.md vignettes;\
		cp inst/vign/occurrences_meta.md vignettes;\
		cp inst/vign/geospatial_queries.md vignettes

rmd2md:
		cd vignettes;\
		mv spplit_vignette.md spplit_vignette.Rmd;\
		mv occurrences_meta.md occurrences_meta.Rmd;\
		mv geospatial_queries.md geospatial_queries.Rmd
