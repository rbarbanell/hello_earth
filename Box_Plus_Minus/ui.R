library(shiny)
library(shinyWidgets)
library(tidyverse)



index_goat$gameplayer <- paste(index_goat$gametype,index_goat$player, sep= " ")

bullsred = "#CE1141"
  lakeryellow = "#FDB927"
    cavswine = "#6f263d"
      
    team_colors <- c("#CE1141", "#FDB927", "#6f263d")
    
    ui <- fluidPage( titlePanel("Michael Jordan v. Kobe Bryant v. Lebron James"),
                     sidebarPanel("Players", 
                                  checkboxGroupInput(
                                    "players", label = "Please choose Player. ",
                                    choices = list("Michael Jordan" = 'Michael Jordan',
                                                   "Kobe Bryant" = 'Kobe Bryant',
                                                   "Lebron James" = 'Lebron James'),
                                    selected = 'Michael Jordan'),
                                  pickerInput("gametype","Choose which game type. ", choices=c("Regular Season", "Playoffs"),selected = 'Regular Season', options = list(`actions-box` = FALSE),multiple = T),width=12),
                     mainPanel('Box Plus/Minus (Playoffs BPM) - how do they compare?',
                               plotOutput('goatplot'),
                               position = 'center',
                               width = 12))
    
    server <- function(input, output){
      output$goatplot <-renderPlot(
        {
          index_goat%>%
            
            filter(gametype %in% input$gametype & player %in% input$players)%>%
            
            # filter(gametype == "Regular Season" & (player == "Michael Jordan" | player == "Kobe Bryant"))%>%
            ggplot(aes(x=num_year, y=overallbpm,color=player, groups = gameplayer))+
            geom_line( alpha = .8)+
            geom_point()+
            facet_wrap(~gameplayer)+
            facet_grid(~gametype)+
            scale_colour_manual(values = team_colors,
                                breaks=c('Michael Jordan', 'Kobe Bryant', 'Lebron James'),
                                labels=c('Michael Jordan', 'Kobe Bryant', 'LeBron James'))+
            ylim(-6, 20)+
            xlim(0,20)+
            theme_minimal()+
            theme(
              plot.caption=element_text(size=8,hjust = 0))+
            labs(
              caption="Box Plus/Minus (Playoffs BPM) is a basketball box score-based metric that estimates a basketball player's contribution
to the team when that player is on the court for the playoffs",
              color="Player",
              y="Playoffs BPM",
              x="years played"
            )
          
        }
      )
    }
    
    shinyApp(ui = ui, server = server)
