#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

server <- function(input, output, session) {
  # ## user information
  # output$user <- renderUser({
  #   dashboardUser(
  #     name = "tiandonglee@163.com", 
  #     image = "tiandonglee.png", 
  #     title = "Tiandong Li (黎天东)",
  #     subtitle = "", 
  #     footer = p("Biostatistics | Bioinformatics | Tumor Immunology | Cancer Epidemiology", class = "text-center"),
  #     fluidRow(
  #       column(12,
  #              tags$div(class = "text-center",
  #                       socialButton(
  #                         href = 'mailto:tiandonglee@163.com',
  #                         icon = icon("envelope")
  #                       ),
  #                       socialButton(
  #                         href = 'https://scholar.google.com/citations?user=WTfwM5gAAAAJ&hl=zh-CN',
  #                         icon = icon("google-plus-square")
  #                       ),
  #                       socialButton(
  #                         href = "https://github.com/tiandongli",
  #                         icon = icon("github",style = "color:white")
  #                       )
  #              )
  #       )
  #     )
  #   )
  # })
  
  ## single sample
  observeEvent(input$action1, {
    data_input <- data.frame(
      CAST = isolate(input$TAAb1),
      HDAC1 = isolate(input$TAAb2),
      HSF1 = isolate(input$TAAb3),
      PTMS = isolate(input$TAAb4),
      ZPR1 = isolate(input$TAAb5)
    )
    # colors <- c("#00468BFF", "#ED0000FF", "#42B540FF", "#0099B4FF", "#925E9FFF", "#FDAF91FF", "#AD002AFF", "#ADB6B6FF",
    #             "#7E6148FF", "#B09C85FF", "#7AA6DCFF", "#8F7700FF")
    print(data_input)
    svm_probs_test <- predict(svm_model, data_input, type = "prob")
    test <- data.frame(Group = c("Healthy","ESCC"), 
                       Probability = c(round(svm_probs_test$Normal,4),round(svm_probs_test$Tumor,4)))
    #test$Group <- factor(test$Group,levels = c("ESCC","Normal"))
    output$plot1 <- renderPlot({
      ggplot(data = test, aes(x = Group, y = Probability, fill = Group)) +
        geom_bar(stat = "identity") + 
        coord_flip() + 
        theme_minimal() +
        geom_text(aes(label=Probability), size=6) +
        guides(fill=guide_legend(reverse = TRUE)) +
        ggtitle(paste0("Probability of diagnosis of esophageal squamous cell carcinoma (ESCC): ", round(svm_probs_test$Tumor,4)*100,"%")) +
        scale_fill_manual(values = c("#AD002AFF","#7AA6DCFF"))+
        theme(plot.title = element_text(size = 25, hjust = 0.5, face = "bold"),
              legend.position = "right",
              text = element_text(size = 20, hjust = 0.5),
              axis.text.x = element_blank(),
              axis.ticks.x = element_blank(),
              axis.text.y=element_blank(),
              axis.title = element_text(face="bold"))})
  })

  ## multiple sampels
  upload_table <- reactive({
    infile <- input$upload_table$datapath
    if (is.null(infile))
      return(NULL)
    df <- readxl::read_xlsx(infile)
    })

  observeEvent(input$action2, {
    df <- upload_table()
    req(!is.null(df))
    
    svm_probs_table <- predict(svm_model, df, type = "prob")
    df$`Probability of ESCC` <- svm_probs_table$Tumor
    df$`Probability of ESCC` <- paste0(round(df$`Probability of ESCC`,4)*100,"%")
    
    output$probs_table <- DT::renderDataTable(
      df,escape = FALSE,
      selection = "none",
      rownames = FALSE,
      options = list(pageLength = 10, scrollX = TRUE,
                     columnDefs = list(list(className = 'dt-center', targets = '_all'))))
    
    output$download_probs_table <- downloadHandler(
      filename = function() {
        paste0("Probability of ESCC from ESCCPred_",Sys.Date(),".csv")
      },
      content = function(file) {
        write.csv(df,file,row.names = FALSE,quote = FALSE, sep = "\n")
      }
    )
    
  })
  
  # ## about
  # load("data/svm_dca.Rdata")
  # output$dca_train <- renderPlotly({
  #   ggplotly(svm_dca_train)
  # })
  # 
  # output$dca_validation <- renderPlotly({
  #   ggplotly(svm_dca_vlidation)
  # })
  

  

}
  
