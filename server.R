#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate) # for working with dates
library(ggplot2)  # for creating graphs
library(scales)   # to access breaks/formatting functions
library(zoo)
library(data.table)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$ui <- renderUI({
      if (is.null(input$input_type))
        return()
      
      # Depending on input$input_type, we'll generate a different
      # UI component and send it to the client.
      switch(input$input_type,
             "slider" = sliderInput("dynamic", "Dynamic",
                                    min = 1, max = 20, value = 10),
             "text" = textInput("dynamic", "Dynamic",
                                value = "starting value"),
             "numeric" =  numericInput("dynamic", "Dynamic",
                                       value = 12),
             "checkbox" = checkboxInput("dynamic", "Dynamic",
                                        value = TRUE),
             "checkboxGroup" = checkboxGroupInput("dynamic", "Dynamic",
                                                  choices = c("Option 1" = "option1",
                                                              "Option 2" = "option2"),
                                                  selected = "option2"
             ),
             "radioButtons" = radioButtons("dynamic", "Dynamic",
                                           choices = c("Option 1" = "option1",
                                                       "Option 2" = "option2"),
                                           selected = "option2"
             ),
             "selectInput" = selectInput("dynamic", "Dynamic",
                                         choices = c("Option 1" = "option1",
                                                     "Option 2" = "option2"),
                                         selected = "option2"
             ),
             "selectInput (multi)" = selectInput("dynamic", "Dynamic",
                                                 choices = c("Option 1" = "option1",
                                                             "Option 2" = "option2"),
                                                 selected = c("option1", "option2"),
                                                 multiple = TRUE
             ),
             "date" = dateInput("dynamic", "Dynamic"),
             "daterange" = dateRangeInput("dynamic", "Dynamic")
      )
    })
    
    output$uiplot <- renderUI({
      if (is.null(input$input_type))
        return()
      
      # Depending on input$input_type, we'll generate a different
      # UI component and send it to the client.
      switch(input$time_type,
             "month" = renderPlot({ 
                      qplot(x=date, y=value,
                     data=data, na.rm=TRUE,
                     main="patients per month",
                     xlab="Date", ylab="patient")+
                 geom_bar(stat="identity", na.rm = TRUE) +
                 scale_x_date( limits=start.end,
                               #breaks=date_breaks("1 month"),
                               labels=date_format("%b %y"))
             }),
             "quarter" = textInput("dynamic", "Dynamic",
                                value = "starting value")
      )
    })
    
    
    output$input_type_time <- renderText({
      input$time_type
    })
    
    output$input_type_text <- renderText({
      input$input_type
    })
    
    output$dynamic_value <- renderPrint({
      str(input$dynamic)
    })
    
    output$dynamic_plot <- renderPlot({
      data <- data.frame("date"=  seq(as.Date("2000/1/1"), by = "month", length.out = 12),"value" = sample(1:100, 12))
      
      data$quarter <- as.yearqtr(data$date, format = "%Y-%m-%d")
      
      
      # Define Start and end times for the subset as R objects that are the time class
      startTime <- min(data$date)
      endTime <- max(data$date)
      
      # create a start and end time R object
      start.end <- c(startTime,endTime)
      start.end
      
      if (input$time_type=='quarter'){

        DT <- data.table(data)
        DT <-DT[, .(PAC = sum(value)) ,by = list(quarter)]
      
        qplot(x=quarter, y=PAC,
            data=DT, na.rm=TRUE,
            main="Inpatients",
            xlab="Date",
            ylab="patients")+
        geom_bar(stat="identity", na.rm = TRUE)+
        scale_x_yearqtr(#limits = c(min(DT$quarter), max(DT$quarter)),
                      format = "%YQ%q")
      }        
      else  {
        
        qplot(x=date, y=value,
              data=data, na.rm=TRUE,
              main="patients per month",
              xlab="Date", ylab="patient")+
          geom_bar(stat="identity", na.rm = TRUE) +
          scale_x_date( limits=start.end,
                        #breaks=date_breaks("1 month"),
                        labels=date_format("%b %y"))
      }
        
    })

    
    output$month <- renderPlot({ 
      qplot(x=date, y=value,
            data=data, na.rm=TRUE,
            main="patients per month",
            xlab="Date", ylab="patient")+
        geom_bar(stat="identity", na.rm = TRUE) +
        scale_x_date( limits=start.end,
                      #breaks=date_breaks("1 month"),
                      labels=date_format("%b %y"))
    })
})
