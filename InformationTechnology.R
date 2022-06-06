library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/InformationTechnology.Rnw", compiler = 'xelatex')