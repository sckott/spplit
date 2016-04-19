all: move rmd2md

move:
		cp inst/vign/spplit_vignette.md vignettes;\
		cp inst/vign/occurrences_meta.md vignettes

rmd2md:
		cd vignettes;\
		mv spplit_vignette.md spplit_vignette.Rmd;\
		mv occurrences_meta.md occurrences_meta.Rmd
