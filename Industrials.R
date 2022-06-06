library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/Industrials.Rnw", compiler = 'xelatex')
