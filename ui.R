library(shiny)
require(rCharts)

shinyUI(
    navbarPage("Predict Next Word", 
            tabPanel("Main",
                column(3, 
                       wellPanel(
                           strong(h3("Settings")),
                           checkboxInput("AI", "Adaptively learn from input", value = FALSE), 
                           radioButtons('ord', "Order of predicted words", c('Most likely' = "M", 'Alphabetical' = "A")),
                           radioButtons('case', "Case of predicted words", c('Lower case' = "L", 'Upper case' = "U", 'First letter capitalized' = "C")),
                           sliderInput("many", "Number of predicted words", min = 1, max = 5, value = 3, step = 1)), 
                           style = "width:22%;"
                       ),
                column(9,
                tabsetPanel(
                    tabPanel("Prediction", 
                             column(7, 
                                    h3("Write down some phrases"), 
                                    p("(Add space and wait a second after you entered every words)"),
                                    textInput("x", "", NULL),
                                    tags$style(type='text/css', "#x { width: 500px; }"),
                                    h3("Prediction of your next word"), 
                                    div(tableOutput("myTable"), style = "font-size:150%;"),
                                    tags$head(tags$style(type="text/css", "#myTable table td {line-height:200%;}")),
                                    tags$head(tags$style(type="text/css", "#myTable table {width:50%;}"))
                             ), 
                             column(5,
                                    wellPanel(
                                        strong(h3("Wordcloud of your written words")), 
                                        p("Choose which ", strong("N-gram"), " model you want to show"),
                                        radioButtons("radio_plot", "", c("one-gram" = "one_learn 1", "two-gram" = "two_learn 2", "three-gram" = "three_learn 3")), 
                                        actionButton("goButton", "click to plot")
                                    ),
                                    plotOutput("wordcloud_plot")
                             )
                             ),
                    tabPanel("Dictionary",
                             fluidRow(
                                 column(12, 
                                        h4("If you are interested about the build-in dictionary, choose a model"),
                                        selectInput("radio_plot_training", "", c("one-gram" = "one_training one", "two-gram" = "two_training two", "three-gram" = "three_training three")),
                                        h4("and then,"),
                                        actionButton("plotButton", "Press here"), 
                                        fluidRow(
                                            column(6, 
                                                   showOutput("training_plot", "polycharts")
                                                   ), 
                                            column(6,
                                                   div(textOutput("training_text"), style = "font-size:150%"),
                                                   div(tableOutput("training_table"), style = "font-size:110%"),
                                                   tags$head(tags$style(type="text/css", "#training_table table td {line-height:230%;}")),
                                                   tags$head(tags$style(type="text/css", "#training_table table {width:70%;}"))
                                                   )
                                            )
                                        )
                    
                                 )
 
                         )
                    ))
                ),
            tabPanel("Readme", 
                     mainPanel(
                         includeMarkdown("include.md")
                         )
                     )
))
