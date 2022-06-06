library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/RealEstate.Rnw", compiler = 'xelatex')