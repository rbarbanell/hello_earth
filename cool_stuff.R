library(DT)
library(plotly)
library(crosstalk)

shared <- SharedData$new(cars)

bscols(plot_ly(shared, x = ~speed, y = ~dist), datatable(shared, width = "100%"))

#rayshader

