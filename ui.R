
#------------------------------------------- UI.R --------------------------------------------#
# Ce fichier contient les intructions pour la création de l'interface graphique. Il ne traite #
# que de l'affichage des composants. Variables définis ici sont envoyés à la partie server.R  #
# pour traitement des requetes.                                                               #
#---------------------------------------------------------------------------------------------#

#-------------------------- Debut de l'interface graphique ------------------------------------

#-------------------------- Création de l'entete de l'application -----------------------------
header <- dashboardHeader(title = "Hebergement Quebec")


#-------------------------- Création de la Barre lateral de l'application ---------------------
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Data", tabName = "data_table", icon = icon("th")),
    menuItem("Team", tabName = "team", icon = icon("user"))
  ), collapsed = TRUE #Permet de cacher a barre laterale à l'ouverture de l'application
)

#-------------------------- Création du corps de l'application --------------------------------
body <- dashboardBody(
  fluidPage(
    tabItems(
      
      #----------------------------- Section 1: le dashboard ---------------------------------
      tabItem(tabName = "dashboard",
              
              # ---------------------- Ligne 1: Affichage des box pour les kpi ----------------
              fluidRow(
                valueBoxOutput("total_hotel_box"),
                valueBoxOutput("total_City_box"),
                valueBoxOutput("total_type_box")
              ),
              
              # ---------------------- Ligne 2: Filtres et les bars chart ---------------------
              fluidRow(
                box(width = 2, height = "320px",collapsible = TRUE, background = "navy",
                    radioButtons("filtre", label = "Filtrer Par:", choices = choix, selected = "Classification"),
                    br(),
                    selectInput("choix_ville", label = "Choisir Municipalité", choices = list_ville, selected = "Tous")
                    ),
                box(width = 5,height = "320px",plotOutput("bar_chart",height = "300px"), status = "primary"),
                box(width = 5,height = "320px",plotOutput("bar_chart_type",height = "300px"), status = "primary")
              ),
              
              #----------------- Ligne 3: Le tableau de établissements et la map ---------------
              fluidRow(
                box(title = textOutput("titre_tab"),DTOutput("list_hbgr", height = "340px"),width = 6, height = "400px",status = "primary"),
                box(title = textOutput("titre_map"),width = 6,height = "400px", background = "navy" ,leafletOutput("map",height = "340px"), status = "primary")
              )
      ),
      
      #----------------------------------- Section 2: Data -------------------------------------
      tabItem(tabName = "data_table",
              
              #-------------------------------- Ligne 1: Filtre --------------------------------
              fluidRow(
                box(title = "Voir dataset:",background = "navy",
                    selectInput("data_viz_in", "Choose Table", choices = c("JOINTURE ETBL & ADRESSES", "JOINTURE TYPE & CARACTÉRISTIQUES")))
              ),
              
              #-------------------------- Ligne 2: Affichage du tableau ------------------------
              fluidRow(
                box(title = "Dataset", width = 12, DTOutput("data_viz_out"))
              )
      ),
      
      #------------------------------------ Section 3: Team ------------------------------------
      tabItem(tabName = "team",
              
              #---------------------------- Ligne 1: 2 profils ---------------------------------
              fluidRow(
                
                #------------------------------------ Profil 1 ---------------------------------
                box(
                  title = "Profil",
                  status = "primary",
                  boxProfile(
                    src = "",
                    title = "Boukari Yameogo",
                    subtitle = "MSc Intelligence d'affaires",
                    boxProfileItemList(
                      bordered = TRUE,
                      boxProfileItem(
                        title = "Prénom",
                        description = "Boukari"
                      ),
                      boxProfileItem(
                        title = "Nom",
                        description = "Yameogo"
                      ),
                      boxProfileItem(
                        title = "Matricule",
                        description = 11264583
                      ),
                      boxProfileItem(
                        title = "Email",
                        description = "yameogo.boukari@gmail.com"
                      ),
                      boxProfileItem(
                        title = "Université",
                        description = "HEC Montréal"
                      )
                    )
                  )
                ),
                
                #--------------------------------- Profil 2 ------------------------------------
                box(
                  title = "Profil",
                  status = "primary",
                  boxProfile(
                    src = "",
                    title = "Nicolas Girard",
                    subtitle = "MSc Intelligence d'affaires",
                    boxProfileItemList(
                      bordered = TRUE,
                      boxProfileItem(
                        title = "Prénom",
                        description = "Nicolas"
                      ),
                      boxProfileItem(
                        title = "Nom",
                        description = "Girard"
                      ),
                      boxProfileItem(
                        title = "Matricule",
                        description = "11257217"
                      ),
                      boxProfileItem(
                        title = "Email",
                        description = "girard.nicolas7@gmail.com"
                      ),
                      boxProfileItem(
                        title = "Université",
                        description = "HEC Montréal"
                      )
                    )
                  )
                )
              ),
              
              #--------------------------------- Ligne 2: 2 profils -----------------------------
              fluidRow(
                
                #--------------------------------- Profil 3 ------------------------------------
                box(
                  title = "Profil",
                  status = "primary",
                  boxProfile(
                    src = "",
                    title = "Eliette Compaore",
                    subtitle = "MSc Intelligence d'affaires",
                    boxProfileItemList(
                      bordered = TRUE,
                      boxProfileItem(
                        title = "Prénom",
                        description = "Eliette"
                      ),
                      boxProfileItem(
                        title = "Nom",
                        description = "Compaore"
                      ),
                      boxProfileItem(
                        title = "Matricule",
                        description = "11258698"
                      ),
                      boxProfileItem(
                        title = "Email",
                        description = "eliettecomp@gmail.com"
                      ),
                      boxProfileItem(
                        title = "Université",
                        description = "HEC Montréal"
                      )
                    )
                  )
                ),
                
                #--------------------------------- Profil 4 ------------------------------------
                box(
                  title = "Profil",
                  status = "primary",
                  boxProfile(
                    src = "",
                    title = "Imene Abid",
                    subtitle = "Baccalauréat",
                    boxProfileItemList(
                      bordered = TRUE,
                      boxProfileItem(
                        title = "Prénom",
                        description = "Imene"
                      ),
                      boxProfileItem(
                        title = "Nom",
                        description = "Abid"
                      ),
                      boxProfileItem(
                        title = "Matricule",
                        description = "11214221"
                      ),
                      boxProfileItem(
                        title = "Email",
                        description = "Imenabid97@gmail.com"
                      ),
                      boxProfileItem(
                        title = "Université",
                        description = "HEC Montréal"
                      )
                    )
                  )
                )
              )
              )
    )
  )
)


#--------------- Concatenation des differents membres pour former l'application -----------
ui <- dashboardPage(header, sidebar, body)

#----------------------- Affichage du produit fini de l'interface -------------------------
shinyUI(ui)

#-------------------------------------- THE END -------------------------------------------