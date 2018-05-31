# ui.R

library(shiny)

# To label inputs, the section title is give first, followed by the section parameter
# i.e. hwe_p

# Initialize the layout with a navbar
fluidPage(
  
  ## Test the theme selector
  theme = shinythemes::shinytheme("united"),
  
  navbarPage(title = "Quantitative Genetics Simulations",
             
             #### First tab ####
             tabPanel(title = "Introduction",
                      
                      titlePanel("Introduction"),
                            
                            mainPanel(
                              
                              p("The complexity of quantitative genetics often requires intensive computation tools for analysis. Researchers can also use computers to run simulations of breeding programs. These can be especially informative for hypothesis testing or for decision-making in breeding. We will use simulations to better-understand the concepts of population genetics, genetic variance, and response to selection."),
                              
                              br(),
                              
                              h3("Learning Objectives"),
                              
                              p("After completing this demo, you should be able to:"),
                              
                              tags$li("  Understand how allele frequencies change over time in randomly-mating populations"),
                              tags$li("  Define genetic drift and understand the impact of genetic drift on breeding populations."),
                              tags$li("  Define the relationship between population size and the likelihood that alleles reach fixation"),
                              tags$li("  Understand the relationship between allele frequency and coded genotypic values on the levels of additive variance and dominance variance."),
                              tags$li("  Understand the relationship between response to selection, genetic variance, and allele frequencies."),
                              tags$li("  Define the impact of heritability and selection intensity on response to selection."),
                              
                              br(),
                              
                              h3("Navigation"),
                              
                              p("This demo is very much 'point and click.' Click on the different tabs above to change the topic. Use the sliders to adjust the values of different parameters. Click the 'Simulate' button to run the simulations for topics 1 and 3."),
                              
                              br(),
                              
                              h4("Click on the first tab to begin!")

                            )
                   ),
             
             
             
             
             #### Second tab ####
             tabPanel("Randomly Mating Populations",
                      
                      titlePanel("Randomly Mating Populations"),
                            
                      # Create a sidebar panel
                      sidebarLayout(
                        
                        sidebarPanel(
                          
                          # Help text
                          helpText("This simulation will look at the changes in allele frequency for a single gene in a randomly-mating population."),
                          
                          # Slider for p allele frequency
                          sliderInput(inputId = "hwe_p",
                                      "Starting Allele Frequency (p):",
                                      value = 0.5,
                                      min = 0.01,
                                      max = 0.99 ),
                          
                          # Slider for number of individuals
                          sliderInput(inputId = "hwe_pop_size",
                                      "Breeding Population Size:",
                                      value = 100,
                                      min = 2,
                                      max = 2000 ),
                          
                          
                          # Slider for number of generations
                          sliderInput(inputId = "hwe_gen",
                                      "Number of Generations:",
                                      value = 200,
                                      min = 10,
                                      max = 1000 ),
                          
                          # Input for the number of population replications
                          numericInput(inputId = "hwe_reps",
                                       "Number of Populations",
                                       value = 3,
                                       min = 1,
                                       max = 5 ),
                          
                          # Break
                          br(),
                          
                          # Helptext
                          helpText("Click to run the simulation."),
                          
                          # Action button
                          actionButton(inputId = "hwe_action", label = "Simulate!")
                          
                        ),
                        
                        # main panel
                        mainPanel(
                          
                          # Use a fluid row to center everything
                          fluidRow(
                            column(width = 12, align = "center", 
                                   # Add graph
                                   plotOutput(outputId = "hwe_plot"),
                                   
                                   # Table
                                   tableOutput(outputId = "hwe_table")
                                   
                            )
                            
                          )
                          
                        )
                      ) # End the sidebar layout
                      
              # End the tab        
             ),
             
             
             
             #### Third tab ####
             tabPanel("Genetic Variance",
                      
                      titlePanel("Genetic Variance"),
                      
                      # Create a sidebar panel
                      sidebarLayout(
                        
                        sidebarPanel(
                          
                          # Help text
                          helpText("This simulation will assess the impact of allele 
                                   frequency and coded genotypic values on the level of 
                                   genetic variance at a single gene."),
                          
                          # Slider for p allele frequency
                          sliderInput(inputId = "var_p",
                                      "Starting Allele Frequency (p):",
                                      value = 0.5,
                                      min = 0,
                                      max = 1, 
                                      step = 0.01),
                          
                          # Slider for additive effect
                          sliderInput(inputId = "var_a",
                                      "Additive Effect (a):",
                                      value = 1, 
                                      min = 0, 
                                      max = 10 ),
                          
                          # Slider for dominance effect
                          sliderInput(inputId = "var_d",
                                      "Dominance Effect (d):",
                                      value = 1, 
                                      min = 0, 
                                      max = 10 )
                          
                        ),
                        
                        mainPanel(
                          
                          # Use a fluid row to center everything
                          fluidRow(
                            column(width = 6, align = "center", 
                                   
                                   # Add graph
                                   plotOutput(outputId = "var_prop"),
                            
                                   # Table
                                   tableOutput(outputId = "var_table")),
                            
                            # Second column
                            column(width = 6, align = "center",
                                   
                                   # Add a graph
                                   plotOutput(outputId = "var_plot"))
                            
                          )
                          
                        )
                        
                      )
              
              # Close the tab        
             ),
             
             
             
             #### Fourth tab ####
             tabPanel("Response to Selection",
                      
                      titlePanel("Response to Selection"),
                      
                      # Create a sidebar panel
                      sidebarLayout(
                        
                        sidebarPanel(
                          
                          # Help text
                          helpText("In this simulation, we will explore how different parameters impact the response to selection and other measurements for a trait influenced by many genes."),
                          
                          # Slider for p allele frequency
                          sliderInput(inputId = "resp_p",
                                      "Starting Allele Frequency (p):",
                                      value = 0.5,
                                      min = 0,
                                      max = 1 ),
                          
                          # # Slider for number of genes
                          # sliderInput(inputId = "resp_L",
                          #             "Number of genes:",
                          #             value = 20, 
                          #             min = 1, 
                          #             max = 100 ),
                          
                          # Slider for heritability
                          sliderInput(inputId = "resp_h",
                                      "Heritability:",
                                      value = 0.5, 
                                      min = 0, 
                                      max = 1 ),
                          
                          helpText("The selection intensity is defined as the proportion of individuals selected from one generation to create the next generation. A low proportion of selected individuals is a high selection intensity, and vice versa."),
                          
                          # Slider for selection intensity
                          sliderInput(inputId = "resp_i",
                                      "Selection Intensity:",
                                      value = 0.1, 
                                      min = 0, 
                                      max = 1 ),
                          
                          # Slider for population size
                          sliderInput(inputId = "resp_n",
                                      "Breeding Population Size:",
                                      value = 100,
                                      min = 2,
                                      max = 2000 ),
                          
                          # # Slider for number of generations
                          # sliderInput(inputId = "resp_t",
                          #             "Number of Breeding Generations:",
                          #             value = 10, 
                          #             min = 1, 
                          #             max = 50 ),
                          
                          # Break
                          br(),
                          
                          # Helptext
                          helpText("Click to run the simulation."),
                          
                          # Action button
                          actionButton(inputId = "resp_action", label = "Simulate!")
                          
                          
                          
                        ),
                        
                        mainPanel(
                          
                          # Add graph
                          plotOutput(outputId = "resp_plot", height = 700)
                          
                          # Depricated
                          # # Add another graph
                          # plotOutput(outputId = "resp_supplot"),
                          # 
                          # # Table
                          # tableOutput(outputId = "resp_table")
                          
                        )
                        
                      )
             ),
             
             
             
             
             #### Fifth tab ####
             tabPanel(title = "Theory",
                        
                        withMathJax(
                          includeHTML("theory.html")
                        )
             )
             
   # End the navigation bar
  )
  
) # End the UI
                                      
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
