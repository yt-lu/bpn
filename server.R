library(shiny)
library(shinyalert)
library(DT)

Sys.setenv(TZ = 'US/Eastern')

shinyServer(function(input, output, session) {
  
  output$copyright <- renderText({
    print(HTML("<p style='text-align: center;'>A tale of three distributions.<br>&copy; 2021 Yuanting Lu</p>"))
  })
  
  ##################################
  # Create graph
  ################################## 
  output$graph <- renderPlot({
    
    req(input$n)
    req(input$lambda)
    
    if (input$n > 2000) {
      shinyalert('Oops. My capacity is n = 2000 :)', 
                 type = 'info')
      updateNumericInput(session, 'n', "Binomial parameter n", 10, min = 1, max = 2000, step = 1)
    }
    
    n <- ifelse(input$n > 2000, 2000, input$n)
    lambda <- input$lambda
    p <- lambda / n
    
    par(family = "mono")
    if (p > 1) {
      plot.new()
      title(expression(paste("Error: p = ", lambda, "/n cannot be larger than 1.")))
    } else if (lambda <= 0) {
      plot.new()
      title(expression(paste("Error: ", lambda, " has to be positive.")))
    } else if (n <= 0 | !is.integer(n)) {
      plot.new()
      title(expression(paste("Error: ", n, " has to be a positive integer.")))
    } else {
      m <- max(2 * lambda, lambda + 6)
      x <- 0 : m
      xx <- seq(0, m, 0.05)
      ymax <- max(dbinom(x, n, p), dpois(x, lambda))
      par(oma = c(2, 0, 2, 2), mar = c(2,2,6,2), mgp = c(4, 1, 0), xpd = T)
      
      # Binomial distribution
      plot(x, dbinom(x, n, p), type = 'h', lwd = 3,
           frame.plot = F, 
           ylim = c(0, ymax), 
           ylab = "Probability")
      
      # Poisson distribution
      if (input$pois) {
        lines(x + 0.1, dpois(x, lambda), type = 'h', lwd = 3, col = 'red')
      }
      
      # Normal distribution
      if (input$norm) {
        lines(xx, dnorm(xx, lambda, sqrt(lambda * (1 - p))), 
              col = 'grey50', 
              type = 'l', 
              lwd = 3, 
              lty = 3)
      }
      
      if (input$pois & input$norm) {
        legend('topright', inset = c(0, -0.2), 
               col = c('black', 'red', 'grey50'), 
               lty = c(1, 1, 3), lwd = 3,
               legend = c(sprintf('Binomial(%d, %g)', n, p), 
                          sprintf('Poisson(%g)', lambda),
                          sprintf('N(%g, %g^2)', lambda, sqrt(lambda * (1 - p)))
                          ))
        
      } else if (input$pois & !input$norm){
        legend('topright', inset = c(0, -0.2), 
               col = c('black', 'red'), 
               lty = 1, lwd = 3,
               legend = c(sprintf('Binomial(%d, %g)', n, p), 
                          sprintf('Poisson(%g)', lambda)))
        title(bquote("Binomial(" ~ n ~ "," ~ lambda/n  ~ ") vs. Poisson(" ~ lambda ~ ")"), 
              line = 5)
      } else if (!input$pois & input$norm) {
        legend('topright', inset = c(0, -0.2), 
               col = c('black', 'grey50'), 
               lty = c(1, 3), lwd = 3,
               legend = c(sprintf('Binomial(%d, %g)', n, p),
                          sprintf('N(%g, %g^2)', lambda, sqrt(lambda * (1 - p)))
               ))
        title(bquote("Binomial(" ~ n ~ "," ~ lambda/n  ~ ") vs. N(" ~ lambda ~ "," ~ lambda(1-lambda/n) ~")"), 
              line = 5)
      } else{
        legend('topright', inset = c(0, -0.2), 
               col = 'black', 
               lty = 1, lwd = 3,
               legend = sprintf('Binomial(%d, %g)', n, p))
        title(bquote("Binomial(" ~ n ~ "," ~ lambda/n  ~ ")"), line = 5)
      }
      
      axis(1)
      axis(2)
    }
    
  })
  
 
})
