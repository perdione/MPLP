library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/ConsumerStaples.Rnw", compiler = 'xelatex')