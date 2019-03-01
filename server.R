
#-------------------------------------------server.R -----------------------------------------#
# Ce fichier contient lest le coeur de l'application. il est le backend de l'application. Il  #
# reçoit les requetes de l'interface, les traitent, et les renvoie à l'interface pour les     #
# afficher.Les variables de cet fichier sont locales et non globales.                         #
#---------------------------------------------------------------------------------------------#


#--------------------- Appel du contenu ou des variables du fichier global.R -----------------#
source("./global.r", local = TRUE)

#--------------------------- Debut de des instruction server (backend) -----------------------#
shinyServer(function(input, output) {
  
#-------------------- Raccoucircement de certaines chaine de caractères pour faciliter l'affichage ----------------
  Type_Cara$CARACT_NOM_FR[which(Type_Cara$CARACT_NOM_FR == "Services automobile et stationnement")] <- rep("Auto_Parking")
  Type_Cara$CARACT_NOM_FR[which(Type_Cara$CARACT_NOM_FR == "Modes de paiement")] <- rep("Paiement")
  Adr_Cara$CARACT_NOM_FR[which(Adr_Cara$CARACT_NOM_FR == "Services automobile et stationnement")] <- rep("Auto_Parking")
  Adr_Cara$CARACT_NOM_FR[which(Adr_Cara$CARACT_NOM_FR == "Modes de paiement")] <- rep("Paiement")
  
#---------------------KPI: nombre total d'établissement de la province --------------
  output$total_hotel_box <- renderValueBox({
    nbr_hbrg <- length((unique(ETBL_Adr$ETBL_ID)))  # calcul du nombre d'établissement au total
    valueBox(h3(nbr_hbrg),"Total Établissement",icon = icon("home"),color = "aqua") # injecter le nombre d'etablissement dans infobox
  })
  
#---------------------KPI: nombre total de municipalité ------------------------------
  output$total_City_box <- renderValueBox({
    nbr_muni <- length(unique(ETBL_Adr$ADR_MUNICIPALITE))
    valueBox(h3(nbr_muni),"Total Municipalité", icon = icon("map"), color = "blue")
  })
  
#---------------------KPI: nombre total de type d'établissements----------------------
  output$total_type_box <- renderValueBox({
    nbr_type_hbrg <- length(unique(Type_Cara$ETBL_TYPE_FR))
    valueBox(h3(nbr_type_hbrg),"Total Type", icon = icon("th"), color = "aqua")
  })

  #------------------------ Barchart des type d'établissement ------------------------
  #Création du graphique
  output$bar_chart_type <- renderPlot({
    
    if (input$choix_ville == "Tous") {
      tampon <- data.frame(table(unique(Type_Cara[,c(2,3)])$ETBL_TYPE_FR)) #On determine les frequences des differents types
    } else {
      tmp <- unique(Adr_Cara[which(Adr_Cara$ADR_MUNICIPALITE == input$choix_ville),2])
      tampon <- unique(Type_Cara[which(Type_Cara$ETBL_ID %in% tmp),c(2,3)])$ETBL_TYPE_FR
      tampon <- data.frame(table(tampon))
    }

    names(tampon) <- c("Type","Frequence") # Changement des noms des colonnes
    tampon$Type <- as.character(tampon$Type) #Convertir en class caractère afin de remplcer les caractères longs
    tampon$Type[which(tampon$Type == "Chalet / appartement / résidence de tourisme")] <- rep("Chalet/App/Residence")#Raccourcir la chaine
    tamp_graph_static <- tampon
    #rm(tampon)
    graph <- ggplot(tamp_graph_static, aes(x = Type, y = Frequence)) +
      geom_bar(stat = "identity", aes(fill = Type)) +
      geom_text(aes(label = Frequence), vjust = 1, size = 4.0) +
      theme(axis.text.x = element_blank()) +
      
      #Condition sur l'affichage du titre du graphique
      if (input$choix_ville == "Tous") {
        ggtitle(paste("Repartition par type d'établissement au Québec"))      
      } else {ggtitle(paste("Repartition par type d'établissement à",input$choix_ville))}
    
    graph
  })
  
#---------------------- Barchart des caractéristiques ---------------------------
  output$bar_chart <- renderPlot({
  
    if (input$choix_ville == "Tous") {
      tmp_interactif <- data.frame(table(Type_Cara[which(Type_Cara$CARACT_NOM_FR == input$filtre),6]))
      names(tmp_interactif) <- c("Caracteristique","Frequence") #Changement des noms de colonnes
      graph <- ggplot(tmp_interactif, aes(x = Caracteristique, y = Frequence)) +
        geom_bar(stat = "identity", aes(fill = Caracteristique)) +
        geom_text(aes(label = Frequence), vjust = 1, size = 3.0) +
        theme(axis.text.x = element_blank()) +
        ggtitle(paste("Repartition des établissements par",input$filtre))
      
      graph #on affiche le graphique
      
    } else {
      
      tmp_interactif <- Adr_Cara[which(Adr_Cara$ADR_MUNICIPALITE == input$choix_ville),c(4,5)]
      tmp_interactif <- data.frame(table(tmp_interactif[which(tmp_interactif$CARACT_NOM_FR == input$filtre),2]))
      names(tmp_interactif) <- c("Caracteristique","Frequence")
      graph <- ggplot(tmp_interactif, aes(x = Caracteristique, y = Frequence)) +
        geom_bar(stat = "identity", aes(fill = Caracteristique)) +
        geom_text(aes(label = Frequence), vjust = 1, size = 3.0) +
        theme(axis.text.x = element_blank()) +
        ggtitle(paste("Repartition par",input$filtre,"pour la ville de",input$choix_ville))
      
      graph #On affiche le graphique
    }
  })
  
#---------------------- Tableau des liste des Établissements----------------------------  
  #Tire du tableau de lliste des établissements
  output$titre_tab <- renderText({
    if (input$choix_ville == "Tous") {
      titre <- "Liste des établissements au Québec"
      titre
    } else {
      titre <- paste("Liste des établissements à",input$choix_ville)
      titre
    }
  })
  #Visualisation du tableau des établissements
  output$list_hbgr <- DT::renderDT({
    if (input$choix_ville == "Tous") { #liste des établissements de toutes les municipalités
      tp <- ETBL_Adr[,c(3,4)]
      tp
    } else {# On affiche la liste des établissement de la manucipalité choisie
      tp <- ETBL_Adr[which(ETBL_Adr$ADR_MUNICIPALITE == input$choix_ville),c(3,4)]
      tp
    }
  }, options = list(pageLength = 5))
  
  
#----------------------- Map de la repartition des établissements -------------------------
  #titre du mao
  output$titre_map <- renderText({
    if (input$choix_ville == "Tous") {
      titre <- "Regroupement des établissements au Québec"
      titre
    } else {
      titre <- paste("Map des établissement à",input$choix_ville)
      titre
    }
  })
  
  # CONSTRUCTION DE LA MAP
  output$map <- renderLeaflet({
    
    #Filtre des positions à afficher selon la municipalité
    if (input$choix_ville == "Tous") { # Lorsque le choix est pour toutes les municipalités
      # Debut de la construction de la map
      map_graph <- leaflet()
      map_graph <- addTiles(map_graph)
      map_graph <- addCircleMarkers(map_graph, lat = ETBL_Adr$ADR_LATITUDE,lng = ETBL_Adr$ADR_LONGITUDE, radius = 4, color = "#0073B7",
                                    clusterOptions = markerClusterOptions(),label = as.character(ETBL_Adr$ETBL_NOM_FR))
      map_graph <- setView(map_graph, 
                           lat = mean(ETBL_Adr$ADR_LATITUDE, na.rm = TRUE), 
                           lng = mean(ETBL_Adr$ADR_LONGITUDE, na.rm = TRUE), zoom = 7)
      #affichage de la map
      map_graph 
      
    } else {#Lorsque le choix est porté sur une municipalité spécifique
      
      # Debut de la construction de la map
      map_graph <- leaflet()
      map_graph <- addTiles(map_graph)
      
      #Obtenit Lat et Long selon la municipalité selectionnée comme filtre
      tampon_choix <- ETBL_Adr[which(ETBL_Adr$ADR_MUNICIPALITE == input$choix_ville),c(2,3,5,7,8)]
      
      #map_graph <- addCircleMarkers(map_graph, lat = tampon_choix$ADR_LATITUDE,lng = tampon_choix$ADR_LONGITUDE, radius = 4, color = "#0073B7",
                                    #clusterOptions = markerClusterOptions(),label = as.character(tampon_choix$ETBL_NOM_FR))
      
      map_graph <- addMarkers(map_graph,lat = tampon_choix$ADR_LATITUDE,lng = tampon_choix$ADR_LONGITUDE, label = as.character(tampon_choix$ETBL_NOM_FR))
      map_graph <- setView(map_graph, 
                           lat = mean(tampon_choix$ADR_LATITUDE, na.rm = TRUE), 
                           lng = mean(tampon_choix$ADR_LONGITUDE, na.rm = TRUE), zoom = 10)
      #affichage de la map
      map_graph
    }
    
  })

#------------------------Visualisation des tableaux dans la 2ieme tab "Data" ----------------
  output$data_viz_out <- DT::renderDT({
    #recuperation de la valeur selectionner en input
    tab <- input$data_viz_in
    
    # Condition sur l'affichage selon la tab selectionné
    if (tab == "JOINTURE ETBL & ADRESSES") {
      tab_out <- ETBL_Adr[,c(-1)]
      colnames(tab_out) <- c("ID","NOM","ADRESS CIVIQUE","MUNICIPALITÉ","CODE POSTAL","LATITUDE","LONGITUDE") #Renommer les colonnes
    } else {
        tab_out <- Type_Cara[,c(-1)]
    }
    #affichage de la tab selectionnée
    tab_out
  }, filter = "top")
})


#-------------------------------------- THE END -------------------------------------------