library(knitr)

tinytex::install_tinytex()

knit2pdf("/home/jovyan/Sectors/Financials.Rnw", compiler = 'xelatex')