#setwd("C:/Users/yameo/OneDrive - HEC Montréal/COURS/Cours HEC Montréal/Logiciel Statistique/R/Devoir R/Dashboard/dashboard")

## activation des librairies
library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(ggplot2)
library(tables)
library(dplyr)
library(rsconnect)
library(stringr)
library(pander)
library(DT)
library(parallel)

## Lecture des donnees
etablissements <- read.csv("./data/etablissements.csv", header = TRUE, sep = ";")
type_etbl <- read.csv("./data/type.csv", header = TRUE, sep = ";")
territoires <- read.csv("./data/territoires.csv", header = TRUE, sep = ";")
adresses <- read.csv("./data/adresses.csv", header = TRUE, sep = ";")
caracteristiques <- read.csv("./data/caracteristiques.csv", header = TRUE, sep = ";")

## Cacul des kpi


#brt total de type de residence
type_etbl$ETBL_TYPE_EN <- as.character(type_etbl$ETBL_TYPE_EN)
list_type_etbl <- unique(type_etbl$ETBL_TYPE_EN[which(type_etbl$ETBL_TYPE_EN !="")])

# Tableau de coordonnée géographique
coord <- adresses[which(!is.na(adresses$ADR_LATITUDE) & !is.na(adresses$ADR_LONGITUDE)),c(7,15,16)]
colnames(coord) <- c("Adresse_Civique", "Latitude", "Longitude")
for (i in 2:3) {
  coord[,i] <- as.numeric(as.character(coord[,i]))
} 
# fusion de tables pour obtenir les etablissements, leur coordonnees et le type d'etablissement
coord_etbl_final <- merge(x=type_etbl, y=territoires, by="ETBL_ID", all = TRUE) # fusion des tableau type et etablissements par ID
coord_etbl_final <- coord_etbl_final[,c(1,5,18)] # Je conserve les colonnes 1, 5 et 18

# Nous remplaçons les NA du de la colones type d'établissements pas Autres
coord_etbl_final$ETBL_TYPE_EN <- as.character(coord_etbl_final$ETBL_TYPE_EN)
coord_etbl_final$ETBL_TYPE_EN[coord_etbl_final$ETBL_TYPE_EN==""] <- "Other"

#creation de 2 nouvelle colonne pour codifier nos variables type et region
coord_etbl_final <- data.frame(coord_etbl_final, code_type="", Code_Region="") # ajout des 2 colonnes
cod_typ <-as.character(unique(coord_etbl_final$ETBL_TYPE_EN)) # Recenser les types
cod_reg <- as.character(unique(coord_etbl_final$TERR_ZONE_GENRE_EN)) # recenser les regions
coord_etbl_final$code_type <- as.numeric(as.character(coord_etbl_final$code_type)) # conversion en numeric


len <- nrow(coord_etbl_final) # nombre de ligne de la dataframe
# Nous utilisons les index des categories dans la table code_region comme code pour la colonne Code_region
for (i in 1:len) {
  coord_etbl_final[i,4] <- which(cod_typ==coord_etbl_final[i,2], arr.ind = TRUE)
}
# Nous utilisons les index des categories dans la table code_region comme code pour la colonne Code_region
coord_etbl_final$Code_Region <- as.numeric(as.character(coord_etbl_final$Code_Region))
for (i in 1:len) {
  coord_etbl_final[i,5] <- which(cod_reg==coord_etbl_final[i,3], arr.ind = TRUE)
}

# Liste de nos filtres
filtre_list <- c("Tous","Classification","Clientèles","Type")