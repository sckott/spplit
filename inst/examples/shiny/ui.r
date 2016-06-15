library(shiny)
library(spplit)

shinyUI(
  pageWithSidebar(

    headerPanel(title = HTML("spplit explorer"), windowTitle = "spplit data explorer"),

    sidebarPanel(
      HTML('<button style="float: left;" type="submit" class="btn btn-primary">Submit</button><br><br>'),

      HTML('<textarea id="spec" rows="3" cols="50">Asteraceae</textarea>'),

      # Map options
      h5(strong("Options:")),
      # data source
      selectInput(inputId = "datasource", label = "Select data source",
                  choices = c("gbif"), selected = "gbif"),
      # pick collection
      selectInput(inputId = "datacoll", label = "Select collection",
                  choices = c("entomology", "herpetology", "ichthyology",
                              "invertebrate zoology & geology", "ornithology",
                              "mammalogy", "botany"), selected = "botany"),
      # number of occurrences for map
      sliderInput(inputId = "numocc", label = "Select max. number of occurrences",
                  min = 1, max = 500, value = 100),
      # number of occurrences for map
      sliderInput(inputId = "numsp", label = "Select max. number of taxa",
                  min = 1, max = 30, value = 5)
    ),

    mainPanel(
      tabsetPanel(
       tabPanel("Occurrence Data", dataTableOutput('occ_dat')),
       tabPanel("Spp. List", dataTableOutput('species_list')),
       tabPanel("BHL Metadata", dataTableOutput('bhl_dat'))
       #tabPanel("OCR", dataTableOutput('ocr'))
      )
    )
  )
)
