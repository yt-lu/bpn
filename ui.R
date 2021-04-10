library(shiny)
library(DT)
library(shinyalert)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  tags$head(
    tags$style(HTML("
                    * {
                    font-family: Palatino,garamond,serif;
                    font-weight: 400;
                    line-height: 1.2;
                    #color: #000000;
                    }
                    
                    hr {border-top: 0.5px solid #ffffff;}
                    br {font-size: 5px;}
                    "))
  ), 
  # Application title
  titlePanel(h3("The Binomial, Poisson, and Normal Distributions", align = 'left')),

  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
      useShinyalert(),
      numericInput("n", "Binomial parameter n", 10, min = 1, max = 2000, step = 1),
      useShinyalert(),
      numericInput("lambda", HTML("Poisson Parameter &lambda;"), 1, min = 0.001, max = 100),
      checkboxInput("normal", "Display Normal Curve", FALSE)
    ),
  
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("graph"),
      hr(),
      htmlOutput("copyright")
        )#end of mainPanel
)#end of sidebar layout
)#end of fluidpage
)#end of shinyUI
