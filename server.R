library(shiny)
require(rCharts)

shinyServer(
    function(input, output){
        x <- reactive({
            x <- tolower(input$x)
            sp <- unlist(strsplit(as.character(x), ""))
            y <- unlist(strsplit(as.character(x), "\\s"))
            validate(
                need(sp[length(sp)] != 0, "Some phrases must be inputted")
            )
            if(input$AI == FALSE){
                first <- one
                second <- two
                third <- three
            }else{
                first <- c(as.character(one_learn$Token), one)
                second <- c(as.character(two_learn$Token), two)
                third <- c(as.character(three_learn$Token), three)
            }
            if(sp[length(sp)] == " " || sp[length(sp)] == "." || length(sp) == 1){
                if(length(y) == 0){
                    next
                }else if(length(y) == 1){
                    y <- paste(y, collapse = " ")
                    one_learn <<- token(y, 1, one_learn)
                }else if(length(y) == 2){
                    y <- paste(y, collapse = " ")
                    one_learn <<- token(y, 1, one_learn)
                    two_learn <<- token(y, 2, two_learn)
                }else if(length(y) == 3){
                    y <- paste(y, collapse = " ")
                    one_learn <<- token(y, 1, one_learn)
                    two_learn <<- token(y, 2, two_learn)
                    three_learn <<- token(y, 3, three_learn)
                }else{
                    y <- y[-1:-(length(y) - 3)]
                    y <- paste(y, collapse = " ")
                    one_learn <<- token(y, 1, one_learn)
                    two_learn <<- token(y, 2, two_learn)
                    three_learn <<- token(y, 3, three_learn)
                }
                Prediction <<- predict(input$x, first, second, third)
            }
            
            
            Prediction <<- Prediction[!duplicated(Prediction)]
            Prediction <<- as.data.table(Prediction)
            Prediction
        })
        
        x1 <- reactive({
            Prediction <<- x()$Prediction
            Prediction <<- Prediction[1:input$many]
            if(input$ord == "A"){
                Prediction <<- sort(Prediction)
            }
            if(input$case == "U"){
                Prediction <<- toupper(Prediction)
            }else if(input$case == "C"){
                Prediction <<- capwords(Prediction)
            }
            Prediction <<- as.data.table(Prediction)
            Prediction
        })
        
       
        output$myTable <- renderTable({x1()})
        
        wordcloud1 <- eventReactive(input$goButton, {
            num <<- as.numeric(unlist(strsplit(as.character(input$radio_plot), "\\s"))[2])
            learn <<- eval(parse(text = unlist(strsplit(as.character(input$radio_plot), "\\s"))[1]))
            wordcloud(learn$Token, learn$Freq, min.freq = 1, scale = c(abs(num - 5), 1), random.order = FALSE)
        })
        output$wordcloud_plot <- renderPlot({wordcloud1()})
        
        training_plot1 <- eventReactive(input$plotButton, {
            df_plot <<- eval(parse(text = unlist(strsplit(as.character(input$radio_plot_training), "\\s"))[1]))
            temp <- unlist(strsplit(as.character(input$radio_plot_training), "\\s"))[2]
            t1 <- rPlot(list(var = "Token", sort = "Probability"), "Probability", data = df_plot, type = "bar")
            t1$guides(x = list(title = "Token (point to see the detail)"))
            t1$guides(y = list(title = "Probability of each Token"))
            t1$addParams(width = 600, height = 400, dom = "training_plot", title = paste0("Histogram of ", temp, "-gram tokens"))
            return(t1)
        })
        
        output$training_plot <- renderChart({training_plot1()})
        
        training_table1 <- eventReactive(input$plotButton, {
            df_table <<- eval(parse(text = paste0(unlist(strsplit(as.character(input$radio_plot_training), "\\s"))[1], "_table")))
            return(df_table)
        })
        output$training_table <- renderTable({training_table1()})
        
        training_text1 <- eventReactive(input$plotButton, {
            return(paste0(unlist(strsplit(as.character(input$radio_plot_training), "\\s"))[2], "-gram"))
        })
        output$training_text <- renderText({paste0("Statistic of ", training_text1(), " tokens")})
    }
    )
