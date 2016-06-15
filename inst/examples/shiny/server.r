library(shiny)
library(spplit)

Sys.setenv(BHL_KEY = 'ea5bbfda-e6ad-4fce-b288-70fa9410a9b3')

shinyServer(function(input, output){

  species2 <- reactive({
    strsplit(input$spec, ",")[[1]]
  })

  occur_data <- reactive({
    sp_occ_gbif(
      query = input$spec,
      limit = input$numocc,
      cas_coll = "botany")
      # cas_coll = c("entomology", "herpetology", "ichthyology",
      #              "invertebrate zoology & geology", "ornithology",
      #              "mammalogy", "botany"))$data[[1]]
  })

  sppp_list <- reactive({
    sp_list(occur_data())
  })

  sppp_bhl_meta <- reactive({
    tmp <- sp_bhl_meta(sppp_list()[1:input$numsp])
    df <- data.frame(name = NA, no_bhl_items = NA, total_bhl_pages = NA)
    for (i in seq_along(tmp)) {
      df[i,] <-
        c(names(tmp[i]),
          length(tmp[[i]]),
          sum(vapply(tmp[[i]], NROW, 1)))
    }
    return(df)
  })

  # sppp_bhl_ocr <- reactive({
  #   sp_bhl_ocr(sppp_bhl_meta())
  # })

  output$occ_dat <- renderDataTable(occur_data()$data[[1]])

  output$species_list <- renderDataTable(data.frame(taxa = sppp_list()[1:input$numsp], stringsAsFactors = FALSE))

  output$bhl_dat <- renderDataTable(sppp_bhl_meta())

  #output$ocr <- renderDataTable(sppp_bhl_ocr())
})
