# appel du fichier global.r pour recuperer les variables dans ce fichier
source("./global.r", local = TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$total_hotel_box <- renderValueBox({
    #nbr total de residences
    nbr_hotel <- length((unique(etablissements$ETBL_ID)))  # calcul du nombre d'établissement au total
    valueBox(h3(nbr_hotel),"Total Hotel",icon = icon("home"),color = "aqua") # injecter le nombre d'etablissement dans infobox
  })
  
  output$total_City_box <- renderValueBox({
    #nbr total localité
    nbr_ville <- length(unique(as.character(territoires$TERR_ZONE_NOM_EN)))
    valueBox(h3(nbr_ville),"Total City", icon = icon("map"), color = "blue")
  })
  
  #Calcul de la variable du nombre total de type qui est Total Type
  output$total_type_box <- renderValueBox({
    #brt total de type de residence
    type_etbl$ETBL_TYPE_EN <- as.character(type_etbl$ETBL_TYPE_EN)
    list_type_etbl <- unique(type_etbl$ETBL_TYPE_EN[which(type_etbl$ETBL_TYPE_EN != "")])
    valueBox(h3(length(list_type_etbl)),"Total Type", icon = icon("th"), color = "aqua")
  })
  
  output$bar_chart <- renderPlotly({
    type_etbl$ETBL_TYPE_EN <- as.character(type_etbl$ETBL_TYPE_EN)
    t <- data.frame(table(type_etbl[which(type_etbl$ETBL_TYPE_EN !=""),5]))
    colnames(t) <- c("Type","Total")
    t <- arrange(t, desc(t$Total))
    p <- ggplot(data = t, aes(x=Type, y=Total, fill=Type)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label=Total), vjust=-0.3, size = 3.0) +
      theme(axis.text.x = element_blank())
    p <- ggplotly(p)
    p
  })
  
  output$map <- renderLeaflet({
    cart_graph <- leaflet()
    cart_graph <- addTiles(cart_graph)
    #cart_graph <- addMarkers(cart_graph, lat = coord$Latitude,lng = coord$Longitude, label = as.character(coord$Adresse_Civique))
    cart_graph <- addCircleMarkers(cart_graph, lat = coord$Latitude,lng = coord$Longitude,radius = 0.05, color = "#368BCD",
                                   clusterOptions = markerClusterOptions(),label = as.character(coord$Adresse_Civique))
    cart_graph <- setView(cart_graph, 
                          lat = mean(adresses$ADR_LATITUDE, na.rm = TRUE), 
                          lng = mean(adresses$ADR_LONGITUDE, na.rm = TRUE), zoom = 5)
    cart_graph 
  })
  
})