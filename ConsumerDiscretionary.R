library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/ConsumerDiscretionary.Rnw", compiler = 'xelatex')