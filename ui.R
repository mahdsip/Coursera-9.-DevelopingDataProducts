#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Dynamically generated user interface components"),
  fluidRow(
    
    column(3, wellPanel(
      selectInput("input_type", "Input type",
                  c("slider", "text", "numeric", "checkbox",
                    "checkboxGroup", "radioButtons", "selectInput",
                    "selectInput (multi)", "date", "daterange"
                  )
      )
    )),
    
    column(3, wellPanel(
      # This outputs the dynamic UI component
      uiOutput("ui")
    )),
    
    column(3,
           tags$p("Input type:"),
           verbatimTextOutput("input_type_text"),
           tags$p("Dynamic input value:"),
           verbatimTextOutput("dynamic_value")
    )
  ),
  fluidRow(    
    column(3, wellPanel(
    selectInput("time_type", "Show time series",
                c("month", "quarter")
    )
  )), 
    column(3, wellPanel(
      tags$p("Dynamic plot value:"),
      verbatimTextOutput("input_type_time")
  ))
    
  ),
  fluidRow(plotOutput("dynamic_plot")
           
  )
)
)