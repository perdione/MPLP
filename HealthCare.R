library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/HealthCare.Rnw", compiler = 'xelatex')