#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with ESCCPred here: https://github.com/tiandongli/ESCCPred/

header <- dashboardHeader(titleWidth = 250,
                          ### changing logo
                          #tags$img(src = "ltd.png", height = "30px"),
                          title = shinyDashboardLogo(
                            theme = "blue_gradient",
                            boldText = tags$span(style = "font-family: Arial; font-size: 20px;", "ESCCPred"),
                              mainText = " tool",
                            badgeText = "v1.0"),
                          userOutput("user")
)

sidebar <- dashboardSidebar(
  width = 250,
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("house")),
    menuItem("Prediction", tabName = "prediction", icon = icon("chart-column"))
    #menuItem("About", tabName = "about", icon = icon("hire-a-helper"))
  ))

body <- dashboardBody(
  tabItems(
    ## home
    tabItem("home", 
            fluidPage(
              tags$div(style="margin: 0 auto; text-align: center; font-family: Kano; font-weight: bold; font-size: 45px; padding-bottom: 10px;",  
                       p(
                         strong("Welcome to ESCCPred", style="color:#3C8DBC;")
                       )),
              tags$div(style="margin: 0 auto; text-align: center; font-family: Times New Roman; font-size: 26px; padding-bottom: 10px;",
                       "ESCCPred is a prediction tool designed for early diagnosis of esophageal squamous cell carcinoma (ESCC). 
                       It utilizes machine learning algorithms to construct a diagnostic model based on serum autoantibodies. 
                       The model has been validated and shows promising performance with high accuracy, 
                       sensitivity, and specificity. The web-based interface of ESCCPred allows easy access to the diagnostic tool, 
                       providing a novel and serological method for early detection of ESCC."),
              img(src = "ESCCPred.png",width = 1200,style = "display: block; margin: 0 auto;"),
              br(),
              # Add dotted line and footer
              tags$hr(style = "border-top: 0.6px solid lightgray; margin-top: 10px;"),
              tags$div(style = "text-align: center; padding: 5px; font-size: 14px;",
                       "Copyright © 2024 - ",
                       a("GitHub", href = "https://github.com", style = "color: #3C8DBC; text-decoration: none;"), br(),
                       tags$p("Designed by Zhengzhou University | Powered by ",
                              a("Shiny", href = "https://shiny.rstudio.com", style = "color: #3C8DBC; text-decoration: none;")
                              ))
            )),
    ## perdiction
    tabItem("prediction",
            ## single sample
            fluidPage(
              fluidRow(width = 12,
                       HTML("<h3><strong><span style='color: #3C8DBC'>Please enter the titer values of the following five TAAbs</strong></h3>"
                       ),
                       fluidRow(
                         column(width = 1, numericInput("TAAb1", label = h5("anti-CAST"), value = 0.1336)),
                         column(width = 1, numericInput("TAAb2", label = h5("anti-HDAC1"), value = 0.2646)),
                         column(width = 1, numericInput("TAAb3", label = h5("anti-HSF1"), value = 0.318)),
                         column(width = 1, numericInput("TAAb4", label = h5("anti-PTMS"), value = 0.3352)),
                         column(width = 1, numericInput("TAAb5", label = h5("anti-ZPR1"), value = 0.5893))
                       ),
                       fluidRow(
                         column(width = 2, actionButton("action1", label = "Calculator", icon = icon("calculator")))
                       ),
                       br(),
                       fluidRow(
                         box(
                           title = tags$b("Prediction-single sample"),
                           width = 10, collapsible = TRUE, solidHeader = TRUE, status = "primary",
                           plotOutput("plot1", height = "20vh")
                         )
                       )
              )
            ),
            ## multiple sample
            fluidPage(
              fluidRow(width = 12,
                       HTML("<h3><strong><span style='color: #3C8DBC'>Please upload the table with five TAAbs value from multiple individuals</strong></h3>"
                       ),
                       fluidRow(
                         column(width = 12, fileInput("upload_table", label = h5(""), accept = c(".xlsx"))),
                         column(width = 2, actionButton("action2", label = "Calculator", icon = icon("calculator")))
                       ),
                       br(),
                       fluidRow(
                         box(
                           title = tags$b("Prediction-multiple samples"),
                           width = 10, collapsible = TRUE, solidHeader = TRUE, status = "primary",
                           dataTableOutput("probs_table"),
                           downloadButton("download_probs_table", label = "Download", class = "text-primary")
                         )
                       )
              )
            )
            )
    )
  )

ui <- dashboardPage(header=header, 
                    sidebar=sidebar, 
                    body=body, 
                    controlbar = dashboardControlbar(skinSelector()),
                    title = "ESCCPred")

