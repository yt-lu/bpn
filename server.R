library(shiny)
library(shinyalert)
library(DT)

Sys.setenv(TZ = 'US/Eastern')

shinyServer(function(input, output, session) {
  
  ##################################
  # Create graph
  ################################## 
  output$graph <- renderPlot({
    
    n <- input$n
    lambda <- input$lambda
    p <- lambda / n
    
    if (p > 1) {
      plot.new()
      title(expression(paste("p = ", lambda, "/n cannot be larger than 1.")))
    } else {
      m <- max(2 * lambda, lambda + 6)
      x <- 0 : m
      xx <- seq(0, m, 0.05)
      ymax <- max(dbinom(x, n, p), dpois(x, lambda))
      par(mar = c(4,6,6,2), mgp = c(4, 1, 0), xpd = T)
      
      # Binomial distribution
      plot(x, dbinom(x, n, p), type = 'h', lwd = 3,
           frame.plot = F, 
           ylim = c(0, ymax), 
           ylab = "Probability")
      
      # Poisson distribution
      lines(x + 0.1, dpois(x, lambda), type = 'h', lwd = 3, col = 'red')
      
      # Normal distribution
      if (input$normal) {
        lines(xx, dnorm(xx, lambda, sqrt(lambda * (1 - p))), 
              col = 'grey50', 
              type = 'l', 
              lwd = 3, 
              lty = 3)
      }
      
      if (input$normal) {
        legend('topright', inset = c(0, -0.3), 
               col = c('black', 'red', 'grey50'), 
               lty = c(1, 1, 3), lwd = 3,
               legend = c(sprintf('Binomial(%d, %g)', n, p), 
                          sprintf('Poisson(%g)', lambda),
                          sprintf('N(%g, %g', lambda, sqrt(lambda * (1 - p)))
                          ))
      } else {
        legend('topright', inset = c(0, -0.3), 
               col = c('black', 'red'), 
               lty = 1, lwd = 3,
               legend = c(sprintf('Binomial(%d, %g)', n, p), sprintf('Poisson(%g)', lambda)))
      }
      
      axis(1)
      axis(2)
    }
    
  })
  
 
})
