# Define UI for application that draws a histogram

# Entete de l'application
header <- dashboardHeader(title = "Hebergement Quebec")

# Barre lateral de l'application
sidebar <- dashboardSidebar(
  titlePanel("HEC Montréal"),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Data", tabName = "data_table", icon = icon("th")),
    menuItem("Team", tabName = "team", icon = icon("user"))
  )
)

# Corps de l'application
body <- dashboardBody(
  fluidPage(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                valueBoxOutput("total_hotel_box"), # sorie de la boite a info pour totatl accomodation
                valueBoxOutput("total_City_box"),
                valueBoxOutput("total_type_box")
                #gradientBox(title = "Filter", status = "success", solidHeader = TRUE,
                #selectInput(inputId = "filtre2", label = "Choose:", choices = c("All","Type")))
              ),
              fluidRow(
                box(width = 8,height = "300px", plotlyOutput("bar_chart",height = "280px"),status = "primary"),
                box(title = "Filtre", width = 4, height = "300px", solidHeader = TRUE, status = "primary",
                    radioButtons("filter", label = "Filter Par :", choices = filtre_list))
              ),
              fluidRow(
                box(width = 8,height = "300px" ,leafletOutput("map",height = "280px"), status = "primary"),
                box(title = "Filtre", width = 4, height = "300px", solidHeader = TRUE, status = "primary",
                    selectInput("filter", label = "Filter By  :", choices = filtre_list, multiple = FALSE))
              )
      ),
      tabItem(tabName = "data_table",
              fluidRow(
                box(title = "Choose dataset to visualize",
                    selectInput("data_viz_in", "Choose Table", choices = c("Data 1", "Data 2", "Data 3")))
              ),
              fluidRow(
                box(title = "Dataset", width = 12, dataTableOutput("data_viz_out", width = "100%", height = "auto"))
              )
      )
    )
  )
)

ui <- dashboardPage(header, sidebar, body)

shinyUI(ui)