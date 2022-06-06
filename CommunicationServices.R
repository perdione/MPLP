library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/CommunicationServices.Rnw", compiler = 'xelatex')