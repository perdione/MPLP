library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/Utilities.Rnw", compiler = 'xelatex')