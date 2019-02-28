#-------------------------- global.R ---------------------------------------------------------#
# Ce fichier contient les instructions telles que l'instalation et l'activation des packages  #
# necessaires pour l'exécution de l'application. En plus la syntax. Et aussi la déclaration   #
# de toutes les variables globales de l'application.                                          #
#---------------------------------------------------------------------------------------------#

#-------------------------- Activation de tous les packages nécessaire ---------------
## Lactivation ainsi est oblgatoire pour l'hebergement de l'appliction sur shinyapps.io
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)
library(leaflet)
library(ggplot2)
library(tables)
library(dplyr)
library(stringr)
library(readr)
library(rsconnect)
library(stringr)
library(DT)

#-------------------------------- Importation des données ---------------------------------------
ETBL_Adr <- read.csv("./data/Join_ETBL_Adr.csv", header = TRUE, encoding = "UTF-8" , stringsAsFactors = FALSE)
Type_Cara <- read.csv("./data/Join_Type_cara.csv", header = TRUE, encoding = "UTF-8", stringsAsFactors = FALSE)
Adr_Cara <- read.csv("./data/Join_Adr_Cara.csv", header = TRUE, encoding = "UTF-8", stringsAsFactors = FALSE)

#------------------------- Définissions des filtres à utiliser dans l'application ---------------
choix <- c("Classification","Paiement","Auto_Parking")
list_ville <- c("Tous",unique(Adr_Cara$ADR_MUNICIPALITE)) #Liste des municipalités

#-------------------------------------- THE END -------------------------------------------