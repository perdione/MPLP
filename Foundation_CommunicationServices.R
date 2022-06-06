install.packages("devtools")
install.packages("FinancialInstrument")
install.packages("PerformanceAnalytics")
devtools::install_github("braverock/blotter")
devtools::install_github("braverock/quantstrat")
devtools::install_github("IlyaKipnis/IKTrading")
install.packages("tableHTML")
remotes::install_github("joshuaulrich/quantmod@358-getsymbols-new.session")

library(devtools)
library(quantmod)
library(png)
library(tableHTML)
library(testthat)
library(tibble)
library(knitr)
library(quantstrat)
library(TTR)
library(png)
library(IKTrading)


rm(list = ls(.blotter), envir = .blotter)

initdate <- "2021-09-17"
from <- "2021-07-09" #start of backtest
to <- Sys.Date()+1 #end of backtest

Sys.setenv(TZ= "UTC") #Set up environment for timestamps

currency("USD") #Set up environment for currency to be used

symbols <- c("ATVI","CHTR","CMCSA","DIS","DISH","EA","FB","FOX","FOXA","GOOG",
"GOOGL","IPG","LUMN","LYV","MTCH","NFLX","NWS","NWSA","OMC","PARA","T","TMUS","TTWO",
"TWTR","VZ","WBD")

getSymbols(Symbols = symbols, src = "yahoo", from=from, to=to, adjust = TRUE,auto.assign = TRUE)

stock(symbols, currency = "USD", multiplier = 1)

tradesize <-1000 #default trade size
initeq <- 12000 #default initial equity in our portfolio

strategy.st <- portfolio.st <- account.st <- "firststrat" #naming strategy, portfolio and account
#removes old portfolio and strategy from environment

rm.strat(portfolio.st)
rm.strat(strategy.st)

#initialize portfolio, account, orders and strategy objects

initPortf(portfolio.st, symbols = symbols, initDate = initdate, currency = "USD")
initAcct(account.st, portfolios = portfolio.st, initDate = initdate, currency = "USD", initEq = initeq)
initOrders(portfolio.st, initDate = initdate)
strategy(strategy.st, store=TRUE)

add.indicator(strategy = strategy.st,
              name = 'SMA',
              arguments = list(x = quote(Cl(mktdata)), n=50),
              label = 'SMA50')

add.indicator(strategy = strategy.st,
              name = 'SMA',
              arguments = list(x = quote(Cl(mktdata)), n=20),
              label = 'SMA20')

add.indicator(strategy = strategy.st,
              name = 'RSI',
              arguments = list(price = quote(Cl(mktdata)), n=3),
              label = 'RSI_3')

add.signal(strategy.st, name = 'sigComparison',
           arguments = list(columns=c("SMA20", "SMA50")),
           relationship = "gt",
           label = "longfilter")

add.signal(strategy.st, name = "sigCrossover",
           arguments = list(columns=c("SMA20", "SMA50")),
           relationship = "lt",
           lablel = "sigCrossover.sig")

add.signal(strategy.st, name = "sigThreshold",
           arguments = list(column = "RSI_3", threshold = 20,
           relationship = "lt", cross = FALSE),
           label = "longthreshold")

add.signal(strategy.st, name = "sigThreshold",
           arguments = list(column = "RSI_3", threshold = 80,
           relationship = "gt", cross = TRUE),
           label = "thresholdexit")

add.signal(strategy.st, name = "sigFormula",
           arguments = list(formula = "longfilter & longthreshold",
           cross = TRUE),
           label = "longentry")

add.rule(strategy.st, name = "ruleSignal",
         arguments = list(sigcol = "sigCrossover.sig", sigval = TRUE,
         orderqty = "all", ordertype = "market",
         orderside = "long", replace = FALSE,
         prefer = "Open"),
         type = "exit")

add.rule(strategy.st, name = "ruleSignal",
         arguments = list(sigcol = "thresholdexit", sigval = TRUE,
         orderqty = "all", ordertype = "market",
         orderside = "long", replace = FALSE,
         prefer = "Open"),
         type = "exit")

add.rule(strategy.st, name = "ruleSignal",
         arguments = list(sigcol = "longentry", sigval = TRUE,
         orderqty = 1, ordertype = "market",
         orderside = "long", replace = FALSE,
         prefer = "Open", osFUN = IKTrading::osMaxDollar,
         tradeSize = tradesize, maxSize = tradesize),
         type = "enter")


Action <- capture_output_lines(out <- applyStrategy(strategy = strategy.st, portfolios = portfolio.st), print = FALSE, width = 80)

 

Action <- as.data.frame(Action)

 

colnames(Action) <- "DateandTransaction"

print(Action)

Date <- Sys.Date()
Act <- Action[grepl(Date, Action$DateandTransaction), ]
as.data.frame(Act)
print(Act)

