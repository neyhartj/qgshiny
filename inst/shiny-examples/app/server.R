# server.R

library(shiny)

# Source the code
source("source.R")


shinyServer(function(input, output) {
  
  # Run the simulation using inputs
  hwe_datasetInput <- eventReactive(eventExpr = input$hwe_action, valueExpr = {
  
    # Run a simulation given the inputs
    p <- input$hwe_p
    t <- input$hwe_gen
    N <- input$hwe_pop_size
    r <- input$hwe_reps
    
    # Return a list a results
    list(
      p = p,
      t = t,
      N = N,
      r = r,
      results = simpop(p = p, N = N, t = t, reps = r)
    )
    
  })
    
  # Plot the simulation
  output$hwe_plot <- renderPlot({
    
    ## Color scheme from which to draw
    col.scheme <- rainbow(n = 5)
    
    data_set <- hwe_datasetInput()
    
    # Plot
    par(xpd = TRUE, mar=c(9,4,4,2) + 0.1)
    
    plot(NA, xlim = c(0,data_set$t), ylim = c(0,1), main = "Allele Frequencies Under Random Mating",
         xlab = "Generation", ylab = expression("Allele Frequency "~(italic(p))))
    
    for (i in seq(data_set$r)) {
      lines(x = data_set$results$gen, y = data_set$results[,i+1], col = col.scheme[i])
    }
    
    # Add legend
    legend(x = 0, y = -0.3, legend = paste("Rep", seq(data_set$r)), col = col.scheme, lwd = 2)

  })
  
  # Add table
  output$hwe_table <- renderTable({
    
    # Read-in the dataset input
    data_set <- hwe_datasetInput()
    
    data.frame(
      Replication = paste("Rep", seq(data_set$r)),
      `Final Allele Frequency` = as.numeric(data_set$results[data_set$t,-1]),
      `Fixation Generation` = apply(X = data_set$results[,-1], MARGIN = 2, FUN = function(gen) 
        ifelse(any(gen == 0, gen == 1), which(gen == 0 | gen == 1)[1], NA)), 
      
      check.names = FALSE, row.names = NULL
    )
    
  }, align = "lcc", rownames = FALSE)
  
  
  ## Genetic variance tab
  # # Show theory if requested
  # observeEvent(input$var_theory, {
  #   insertUI(
  #     selector =  '#placeholder',
  #     ui = tags$div(
  #       tags$p("testtext"),
  #       id = "testid"
  #     )
  #   )
  # })
  
  var_datasetInput <- reactive({
    
    # Extract the variables
    ## Generate a sequence of allele frequencies
    ## Round in order to avoid weird bug in 'seq'
    p <- round(x = seq(0, 1, by = 0.01), digits = 2)
    q <- 1 - p
    
    p_i <- input$var_p
    a <- input$var_a
    d <- input$var_d
    q_i <- 1 - p_i
    
    # Calculate additive variance
    V_A <- 2 * p * q * ( ( a + d * (q - p) )^2 )
    V_D <- 4 * p^2 * q^2 * d^2
    
    ## Calculate genetic variance at the specific gene frequency
    V_A_i <- V_A[p == p_i]
    V_D_i <- V_D[p == p_i]
    
    # Total V_G is V_A + V_D
    V_G_tot <- V_A_i + V_D_i
    V_G_per <- 1
    
    # Calculate proportions of V_A and V_D
    V_G_prop <- matrix(data = c(V_A_i, V_D_i), ncol = 1) / V_G_tot
    
    list(
      p = p,
      p_i = p_i,
      V_A = V_A,
      V_D = V_D,
      V_A_i = V_A_i,
      V_D_i = V_D_i,
      V_G_per = V_G_per,
      V_G_prop = V_G_prop
    )
    
  })
  
  # Plot
  output$var_prop <- renderPlot({
    
    # Get the data
    var_out <- var_datasetInput()
    
    # Plot
    bp <- barplot(height = var_out$V_G_prop, horiz = TRUE, beside = FALSE, 
                  main = "Partition of Genetic Variance",
                  xlab = expression(Proportion~of~V[G]), col = rainbow(n = 2),
                  legend.text = T)
    
    # Position of text
    text_y <- apply(X = var_out$V_G_prop, MARGIN = 2, FUN = cumsum)
    text_y <- text_y - (var_out$V_G_prop/2)
    
    # Add labels
    text(x = t(text_y), y = bp, labels = c(expression(bold(V[A])), expression(bold(V[D]))) )
    
  })
  
  ## Add another plot of V_A and V_D over allele frequencies
  
  output$var_plot <- renderPlot({
    
    # Get the data
    var_out <- var_datasetInput()
    
    ## Colors of the genetic variance
    colors <- rainbow(2)
    
    # Plot
    ## Plot the total variance first
    plot(x = var_out$p, y = var_out$V_A + var_out$V_D, type = "l", lwd = 2, 
         ylab = "Variance", xlab = expression("Allele Frequency"~(italic(p))))
    # Add lines for the dominance variance and additive variance
    lines(x = var_out$p, y = var_out$V_D, type = "l", col = colors[2], lwd = 2)
    lines(x = var_out$p, y = var_out$V_A, type = "l", col = colors[1], lwd = 2)
    # Add a vertical line at the allele frequency
    abline(v = var_out$p_i, lty = 2)
    
    ## Add a legend
    legend(x = "topright", legend = c(expression(bold(V[A])), expression(bold(V[D])), expression(bold(V[G]))),
           col = c(rev(colors), "black"), lwd = 2)
    
  })
  
  # Table
  output$var_table <- renderTable({
    
    # Get the data
    var_out <- var_datasetInput()
    
    # Output data.frame
    data.frame(
      `Source of Variance` = c("Additive", "Dominance"),
      Value = c(var_out$V_A_i, var_out$V_D_i),
      `Proportion of Genetic Variance` = var_out$V_G_prop,
      check.names = FALSE,
      row.names = NULL
    )
    
  }, align = c("lcc"), rownames = FALSE)
  
  
  # Response to selection
  # Wait for input
  # observeEvent(eventExpr = input$resp_action, handlerExpr = {
  
  resp_datasetInput <- eventReactive(eventExpr = input$resp_action, ignoreInit = TRUE, valueExpr = {
    
    # Extract variables
    p <- input$resp_p
    # L <- input$resp_L
    L <- 25
    h <- input$resp_h
    i <- input$resp_i
    N <- input$resp_n
    # t <- input$resp_t
    t <- 25
    
    # Determine the additive effects of QTL
    a <- ((L - 1) / (L + 1)) ^ seq(L)
    
    # If a is 0 (L = 1), set to 1
    a <- ifelse(a == 0, 1, a)
    
    # Launch simulation
    # Return a list a results
    data_list <- list(
      p = p,
      L = L,
      h = h,
      i = i,
      t = t,
      N = N,
      a = a,
      results = simbreed(p = p, N = N, t = t, h = h, L = L, i = i, a = a)
    )
    
    # Does 'resp_sim_results' exist? If so, append to it
    if (!exists("resp_sim_results")) {
      resp_sim_results <<- list(data_list)
      
    } else {
      resp_sim_results <<- list(tail(resp_sim_results, 1)[[1]], data_list)

    }
    
    # Output the data    
    resp_sim_results

  })
  
  
  # Plot
  output$resp_plot <- renderPlot({

    resp_sim_results_plot <- resp_datasetInput()

    # Get the first set of data, if present
    if (length(resp_sim_results_plot) == 1) {
      # Get the data - the newest run is the last in the list
      resp_out <- resp_sim_results_plot[[1]]

    } else {
      resp_out <- resp_sim_results_plot[[2]]
      resp_out_old <- resp_sim_results_plot[[1]]

    }

    # Generations
    gen <- resp_out$results$gen

    # matrix of allele frequencies
    freq <- resp_out$results[,startsWith(x = colnames(resp_out$results), prefix = "p"), drop = FALSE]
    # Vector of allele effects
    a <- resp_out$a

    # bins of allele effects
    a_bin <- .bincode(x = a, breaks = seq(0, 1, by = 0.1))



    # 2 x 2 plots
    par(mfrow = c(2, 2))


    # Plot
    plot(NA, type = "l", main = "Genotypic Value", ylab = "Standardized Genotypic Value",
         xlab = "Generation", ylim = c(-1, 1), xlim = c(1, length(gen)))

    # If resp_out_old is present, add the previous results and a legend
    if (exists("resp_out_old")) {
      lines(x = resp_out_old$results$gen, y = resp_out_old$results$G, lwd = 2.5,
            col = "grey75")
      legend(x = "bottomright", legend = c("Previous Run", "Current Run"), lwd = 2.5,
             col = c("grey75", "blue"))
    }

    ## Add lines
    lines(x = resp_out$results$gen, y = resp_out$results$G, lwd = 2.5, col = "blue")




    # Plot
    plot(NA, type = "l", main = "Genetic Variance", ylab = "Standardized Genetic Variance",
         xlab = "Generation", ylim = c(0, 0.05), xlim = c(1, length(gen)))

    # If resp_out_old is present, add the previous results
    if (exists("resp_out_old")) {
      lines(x = resp_out_old$results$gen, y = resp_out_old$results$varG, lwd = 2.5,
            col = "grey75")
      legend(x = "topright", legend = c("Previous Run", "Current Run"), lwd = 2.5,
             col = c("grey75", "red"))
    }

    ## Add lines
    lines(x = resp_out$results$gen, y = resp_out$results$varG, lwd = 2.5, col = "red")



    # Plot for allele frequencies
    plot(NA, type = "l", main = "Allele Frequencies",
         ylab = "Frequency", xlab = "Generation", ylim = c(0, 1), xlim = c(1, length(gen)))

    # Iterate over allele frequencies
    for (l in seq(resp_out$L)) {

      lines(x = gen, y = freq[,l], lwd = a_bin[l] / 2)

    }
    
    # # Add a legend plot
    # plot(NA, ylim = c(-1, 1), xlim = c(-1, 1))
    # legend(x = 0, y = 0, legend = c("Current Simulation", "Previous Simulation"),
    #        col = "blue", "grey75", lwd = c(1,1))

  })
  
  
  # # Plot other
  # output$resp_supplot <- renderPlot({
  #   
  #   # Get the data
  #   resp_out <- resp_datasetInput()
  #   
  #   # Generations
  #   gen <- resp_out$results$gen
  #   
  #   # Genetic variance over generations
  #   varG <- resp_out$results$varG
  #   # matrix of allele frequencies
  #   freq <- resp_out$results[,startsWith(x = colnames(resp_out$results), prefix = "p"), drop = FALSE]
  #   # Vector of allele effects
  #   a <- resp_out$a
  #   
  #   # bins of allele effects
  #   a_bin <- .bincode(x = a, breaks = seq(0, 1, by = 0.1))
  #   
  #   
  #   # 2 plots
  #   par(mfrow = c(1, 2))
  #   
  #   plot(x = gen, y = varG, type = "l", main = "Genetic Variance Over Generations", 
  #        ylab = "Standardized Genetic Variance", xlab = "Generation", lwd = 2.5,
  #        col = "red", ylim = c(0, 0.05), xlim = c(1, length(gen)))
  #   
  #   # Plot for allele frequencies
  #   plot(NA, type = "l", main = "Allele Frequencies Over Generations",
  #        ylab = "Frequency", xlab = "Generation", ylim = c(0, 1), xlim = c(1, length(gen)))
  #   
  #   # Iterate over allele frequencies
  #   for (l in seq(resp_out$L)) {
  #     
  #     lines(x = gen, y = freq[,l], lwd = a_bin[l] / 2)
  #     
  #   }
  #   
  # })
  
  
  
}) # Close the server
