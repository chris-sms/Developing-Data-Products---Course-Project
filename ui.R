# Developing Data Products - Course Project
# 10/12/2016

library(shiny)
shinyUI(fluidPage(
  titlePanel("Diamond Price Estimator"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("carat", "Carat Weight", 0, 2, value = 1,step=0.25),
      radioButtons("cut", "Cut Quality:",
                     c("Fair" = "Fair",
                       "Good" = "Good",
                       "Very Good" = "Very Good",
                       "Premium" = "Premium",
                       "Ideal" = "Ideal"),inline=TRUE,selected="Very Good"),
      radioButtons("color", "Color:",
                   c("D" = "D",
                     "E" = "E",
                     "F" = "F",
                     "G" = "G",
                     "H" = "H",
                     "I" = "I",
                     "J" = "J"),inline=TRUE,selected="G"),
      radioButtons("clarity", "Clarity:",
                   c("I1" = "I1",
                     "SI1" = "SI1",
                     "SI2" = "SI2",
                     "VS1" = "VS1",
                     "Vs2" = "VS2",
                     "VVS1" = "VVS1",
                     "VVS2" = "VVS2",
                     "IF" = "IF"),inline=TRUE,selected="VS1"),
      submitButton("Submit"),
      width=4
    ),
    mainPanel(
              plotOutput("plot1"),
              h4("Predicted Price from Each Model:"),
              textOutput("pred1"),
              textOutput("pred2"),
              textOutput("pred3"),
              h4("Documentation:"),
              h6("This app allows you to estimate the price of a diamond based on its carat weight, cut quality, color, and clarity.  Use the controls on the left side of the screen to specify the attributes of a diamond whose price you would like to estimate.  The Diamond Price Estimator returns the estimated price for your diamond based on three different price estimation models."),
              h6("Model 1 is a simple linear model of the form price~carat+cut+color+clarity."),
              h6("Model 2 is a linear model with interaction terms allowing different relationships between carat and price for each level of cut, color, and clarity."),
              h6("Model 3 uses square terms to capture the nonlinear relationship between carat weight and price."),
              h6("The plots show the prices vs carat weights of indivdual diamonds for the selected cut-color-clarity combination, along with each model's estimations.  The data are from the diamonds dataset available in the ggplot2 library, described here: http://docs.ggplot2.org/0.9.3.1/diamonds.html")
    )
  )
))
