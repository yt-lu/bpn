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
  
  withMathJax(),
  
  # Application title
  titlePanel("Approximate Binomial by Poisson and Normal"),

  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
      useShinyalert(),
      numericInput("n", "n", 10, step = 10),
      useShinyalert(),
      numericInput("lambda", HTML("&lambda;"), 1),
      checkboxInput("pois", "Show Poisson", TRUE),
      checkboxInput("norm", "Show normal", FALSE)
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
