library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/Energy.Rnw", compiler = 'xelatex')