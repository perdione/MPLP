library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/Materials.Rnw", compiler = 'xelatex')