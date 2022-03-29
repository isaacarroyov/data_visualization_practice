library(dplyr)
library(ggplot2)
library(ggtext)
library(MetBrewer)

# List of Months
months_factors = c("January", "February","March","April","May", "June","July", "August","September", "October","November","December")

# Change to factors
df <- read.csv("./data/environmental_data_2001_2020_yuc.csv")
df <- df %>% 
  mutate(Year = factor(Year), Month = factor(Month, labels = months_factors))


# Create data frame with monthly avg for each environmental variable
df_monthly_avg <- df %>%
  group_by(Month) %>%
  summarise(
    temperature_monthly_avg = mean(temperature),
    soil_moisture_monthly_avg = mean(soil_moisture),
    pdsi_monthly_avg = mean(pdsi)
  )


# Set theme
theme_set(theme_light(base_family = "Georgia"))
theme_update(
  legend.position = "none",
  plot.title.position = "plot",
  plot.title = element_markdown(size=15, margin = margin(0,0,10,0)),
  plot.subtitle = element_textbox_simple(size=11.5, margin = margin(0,0,10,0), width = unit(440,'pt'), halign = 0, hjust = 0),
  plot.caption = element_textbox_simple(size=9, colour = "gray70", margin = margin(10,0,0,0), halign = 1),
  axis.title.x = element_markdown(size=11, margin = margin(10,0,0,0), hjust=0),
  axis.text.x = element_text(size=10),
  axis.text.y = element_text(size=11.5, face='bold'),
  panel.background = element_rect(fill = "white"),
  plot.background = element_rect(fill='white'),
  panel.grid = element_blank(),
  panel.grid.major.x = element_line(color='black', linetype = 'dotted', size=0.1),
  panel.grid.minor.x = element_line(color='black', linetype = 'dotted', size=0.1),
  panel.border = element_blank(),
  axis.title.y = element_blank(),
  axis.ticks.y = element_blank()
)

# JITTER PLOTS

# Temperature -> Palette Demuth 
(chart_temperature_jitter_individual = df %>% 
    ggplot(aes(x=temperature, y=Month, color=temperature)) +
    geom_jitter(height = 0.13, size=3, alpha=0.7) +
    scale_x_continuous(breaks = seq(20,40,3)) +
    scale_color_gradientn(colors = met.brewer("Demuth"), trans='reverse') +
    geom_segment(data=df_monthly_avg, aes(y=Month, yend=Month, x=temperature_monthly_avg, xend=mean(df$temperature)),
                 color = 'black', size=1) +
    stat_summary(fun=mean, geom = "point", size=7, color='black') +
    geom_vline(aes(xintercept= historic_mean_temperature), color='black', size=1) +
    scale_y_discrete(limits=rev) +
    coord_cartesian(clip="off") +
    annotate(geom = "text", family="Georgia", x= 33, y= 11.5, size=3.5, hjust=0,
             label=glue::glue("Historical average\ntemperature: {round(mean(df$temperature),1)} ºC")) +
    annotate(geom = "text", family="Georgia", x= 21.5, y= 9, size=3.5, hjust=0,
             label=glue::glue("January has the lowest\ntemperature with {round(df$temperature[which.min(df$temperature)],1)} ºC\nrecorded in 2020, even\nthough historically the coldest\nmonth is December with {round(df_monthly_avg$temperature_monthly_avg[12],1)} ºC.")) +
    annotate(geom = "text", family="Georgia", x= 30.75, y= 4.5, size=3.5, hjust=0,
             label = glue::glue("April is historically the hottest month\nwith {round(df_monthly_avg$temperature_monthly_avg[4],1)} ºC, and has the highest\ntemperature with {round(df$temperature[which.max(df$temperature)],1)} ºC recorded\nin 2020")) +
    labs( title= "**20 years of environmental data in Yucatan, Mexico:<br>Temperature**",
          subtitle="Distribution of monthly land surface temperature from 2001 to 2020. The <span style='font-size:9pt'><b>smaller dots</b></span> are monthly land surface temperature averages, the <span style='font-size:13pt'><b>larger ones</b></span> are the historical land surface temperature averages for the month, and the vertical line is the overall historical land surface temperature average.",
          caption="**Data**: MOD11A1.006 Terra Land Surface Temperature and Emissivity Daily Global 1km<br>**Visualization by Isaac Arroyo (@unisaacarroyov)**") +
    xlab("Temperature data in **Celsius (ºC)**") +
    geom_curve(
      data = tribble(
        ~x1,~x2,~y1,~y2,
        32.7, 28.7, 11.5, 12.3,
        24, 23.7, 10.5, 11.85, 
        24, 24.9, 7.5, 1.4,
        32, 33.6, 5.75, 8.55,
        37, 37.7, 5.75, 8.55,
        
      ),
      aes(x=x1, xend=x2, y=y1, yend=y2),
      arrow=arrow(length = unit(10,'points')),
      size = 0.6, color='gray20', curvature = 0.4)
)

ggsave("./R/visualizing_environmental_data/images/visualizing_environmental_data_pt1_jitter_temperature.png", width = 1080, height = 1080, dpi=300, scale=1.8, units = "px" )



# Soil moisture -> palette Ingres
(chart_soil_moisture_jitter_individual = df %>% 
    ggplot(aes(x=soil_moisture, y=Month, color=soil_moisture)) +
    geom_jitter(height = 0.13, size=3, alpha=0.7) +
    scale_x_continuous(breaks = seq(10,200, 35)) +
    scale_color_gradientn(colors = met.brewer("Ingres"), trans='reverse') +
    geom_segment(data=df_monthly_avg, aes(y=Month, yend=Month, x=soil_moisture_monthly_avg, xend=mean(df$soil_moisture)),
                 color = 'black', size=1) +
    stat_summary(fun=mean, geom = "point", size=6, color='black') +
    geom_vline(aes(xintercept= historic_mean_soil_moisture), color='black', size=1) +
    scale_y_discrete(limits=rev) +
    coord_cartesian(clip="off") +
    annotate(geom = "text", family="Georgia", x= 130, y= 11.5, size=3.5, hjust=0,
             label=glue::glue("Historical average\nsoil moisture: {round(mean(df$soil_moisture),1)} mm")) +
    annotate(geom = "text", family="Georgia", x= 103, y= 9, size=3.5, hjust=0,
             label=glue::glue("March, April and May are the months with\nthe lowest values of soil mositure\ncompared with the historical average")) +
    labs( title= "**20 years of environmental data in Yucatan, Mexico:<br>Soil Moisture**",
          subtitle="Distribution of monthly soil moisture from 2001 to 2020. The <span style='font-size:9pt'><b>smaller dots</b></span> are monthly soil moisture average, the <span style='font-size:13pt'><b>larger ones</b></span> are the historical soil moisture average for the month, and the vertical line is the overall historical soil moisture average.",
          caption="**Data**: TerraClimate: Monthly Climate and Climatic Water Balance for Global Terrestrial Surfaces, University of Idaho<br>**Visualization by Isaac Arroyo (@unisaacarroyov)**") +
    xlab("Soil moisture data in **milimeters (mm)**") +
    geom_curve(
      data = tribble(
        ~x1,~x2,~y1,~y2,
        130, 77, 12, 12.5,
        105, 77, 10, 10,
        100, 77, 9, 9
      ),
      aes(x=x1, xend=x2, y=y1, yend=y2),
      arrow=arrow(length = unit(10,'points')),
      size = 0.6, color='gray20', curvature = 0.3) +
    geom_curve(
      data = tribble(
        ~x1,~x2,~y1,~y2,
        100, 77, 8, 8,
      ),
      aes(x=x1, xend=x2, y=y1, yend=y2),
      arrow=arrow(length = unit(10,'points')),
      size = 0.6, color='gray20', curvature = -0.3)
    
)
ggsave("./R/visualizing_environmental_data/images/visualizing_environmental_data_pt1_jitter_soil_moisture.png", width = 1080, height = 1080, dpi=300, scale=1.8, units = "px" )



# Drought -> Palette OKeeffe1
(chart_pdsi_jitter_individual = df %>% 
    ggplot(aes(x=pdsi, y=Month, color=pdsi)) +
    geom_jitter(height = 0.13, size=3, alpha=0.7) +
    scale_x_continuous(breaks = seq(-8,8,2)) +
    scale_color_gradientn(colors = met.brewer("OKeeffe1")) +
    geom_segment(data=df_monthly_avg, aes(y=Month, yend=Month, x=pdsi_monthly_avg, xend=mean(df$pdsi)),
                 color = 'black', size=1) +
    stat_summary(fun=mean, geom = "point", size=6, color='black') +
    geom_vline(aes(xintercept= historic_mean_pdsi), color='black', size=1) +
    scale_y_discrete(limits=rev) +
    coord_cartesian(clip="off") +
    annotate(geom = "text", family="Georgia", x= 5.75, y= 5, size=3.5, hjust=0,
            label=glue::glue("Historical\ndrought\nseverity\naverage: {round(mean(df$pdsi),1)}")) +
    labs( title= "**20 years of environmental data in Yucatan, Mexico:<br>Drought severity**",
          subtitle="Distribution of monthly drought severity from 2001 to 2020. The <span style='font-size:9pt'><b>smaller dots</b></span> are monthly drought severity average, the <span style='font-size:13pt'><b>larger ones</b></span> are the historical drought severity average for the month, and the vertical line is the overall historical drought severity average.",
          caption="**Data**: TerraClimate: Monthly Climate and Climatic Water Balance for Global Terrestrial Surfaces, University of Idaho<br>**Visualization by Isaac Arroyo (@unisaacarroyov)**") +
    xlab("Drought severity given by **Palmer's Drought Severuty Index (PDSI)**.<br><span style='font-size:9pt'>Negatives values mean higher periods of time without rain</span>") +
    geom_curve(
      data = tribble(
        ~x1,~x2,~y1,~y2,
        6.5, 0.5 , 6.2, 12.5,
      ),
      aes(x=x1, xend=x2, y=y1, yend=y2),
      arrow=arrow(length = unit(10,'points')),
      size = 0.6, color='gray20', curvature = 0.5)
)
ggsave("./R/visualizing_environmental_data/images/visualizing_environmental_data_pt1_jitter_pdsi.png", width = 1080, height = 1080, dpi=300, scale=1.8, units = "px" )




# SCATTER PLOTS (heatmaps)
# Temperature
(chart_temperature_scatter_individual <- df %>%
    ggplot(aes(x=Year, y=Month, color=temperature)) +
    geom_point(size=5.5) +
    scale_color_gradientn(colors = met.brewer("Demuth"), trans='reverse', breaks=seq(20,40,2)) +
    scale_y_discrete(limits=rev) +
    scale_x_discrete(breaks= levels(df$Year),
                     labels= c("01","02","03","04","05","06","07","08","09","10","11","12",
                               "13","14","15","16","17","18","19","20")) +
    guides(color=guide_colorbar(title="Temperature data in **Celsius (ºC)**", ticks=F, reverse=T,
                                direction = "horizontal", title.position = "top",
                                barwidth = unit(430,"points"), barheight = unit(5,"points"))) +
    labs(title = "**20 years of environmental data in Yucatan, Mexico:<br>Temperature**",
         subtitle= "Each dot represents a specific month and year, and its colour symbolize the avarege temperature. The chart clearly shows the <b><span style='color:#E0A74A'>hotte</span><span style='color:#C54626'>st mo</span><span style='color:#A82725'>nths</span></b> of the year",
         caption="**Data**: MOD11A1.006 Terra Land Surface Temperature and Emissivity Daily Global 1km<br>**Visualization by Isaac Arroyo (@unisaacarroyov)**") +
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_markdown(face='bold', size = 11),
      axis.text.y = element_markdown(face='bold', size = 11),
      axis.title.x = element_blank(),
      legend.position = "top",
      legend.box.margin = margin(0,0,-5,-60),
      legend.title = element_markdown(size=8),
      legend.text = element_text(size = 8, face="bold")
    )
)
ggsave("./R/visualizing_environmental_data/images/visualizing_environmental_data_pt1_scatter_temperature.png", width = 1080, height = 1080, dpi=300, scale=1.8, units = "px" )



# soil
(chart_soil_moisture_scatter_individual <- df %>%
    ggplot(aes(x=Year, y=Month, color=soil_moisture)) +
    geom_point(size=5.5) +
    scale_color_gradientn(colors = met.brewer("Ingres"), trans='reverse', breaks=seq(5,200,20)) +
    scale_y_discrete(limits=rev) +
    scale_x_discrete(breaks= levels(df$Year),
                     labels= c("01","02","03","04","05","06","07","08","09","10","11","12",
                               "13","14","15","16","17","18","19","20")) +
    guides(color=guide_colorbar(title="Soil moisture data in **milimeters (mm)**", ticks=F, reverse=T,
                                direction = "horizontal", title.position = "top",
                                barwidth = unit(430,"points"), barheight = unit(5,"points"))) +
    labs(title = "**20 years of environmental data in Yucatan, Mexico:<br>Soil moisture**",
         subtitle= "Each dot represents a specific month and year, and its colour symbolize the average soil moisture. The chart clearly shows the months with relatively <b><span style='color:#005382'>high</span></b> or <b><span style='color:#855313'>low</span></b> values.",
         caption="**Data**: TerraClimate: Monthly Climate and Climatic Water Balance for Global Terrestrial Surfaces, University of Idaho<br>**Visualization by Isaac Arroyo (@unisaacarroyov)**") +
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_markdown(face='bold', size = 11),
      axis.text.y = element_markdown(face='bold', size = 11),
      axis.title.x = element_blank(),
      legend.position = "top",
      legend.box.margin = margin(0,0,-5,-60),
      legend.title = element_markdown(size=8),
      legend.text = element_text(size = 8, face="bold")
    )
)
ggsave("./R/visualizing_environmental_data/images/visualizing_environmental_data_pt1_scatter_soil_moisture.png", width = 1080, height = 1080, dpi=300, scale=1.8, units = "px" )



# drought
(chart_drought_severity_scatter_individual <- df %>%
    ggplot(aes(x=Year, y=Month, color=pdsi)) +
    geom_point(size=5.5) +
    scale_color_gradientn(colors = met.brewer("OKeeffe1"), breaks=seq(-8,8,2)) +
    scale_y_discrete(limits=rev) +
    scale_x_discrete(breaks= levels(df$Year),
                     labels= c("01","02","03","04","05","06","07","08","09","10","11","12",
                               "13","14","15","16","17","18","19","20")) +
    guides(color=guide_colorbar(title="Drought severity given by **Palmer's Drought Severuty Index (PDSI)**.<br><span style='font-size:7pt'>Negatives values mean higher periods of time without rain</span>", ticks=F, reverse=F,
                                direction = "horizontal", title.position = "top",
                                barwidth = unit(430,"points"), barheight = unit(5,"points"))) +
    labs(title = "**20 years of environmental data in Yucatan, Mexico:<br>Drought severity**",
         subtitle= "Each dot represents a specific month and year, and its colour symbolize the average drought severity index. The chart clearly shows the <b><span style='color:#C2553C'>driest</span></b> months.",
         caption="**Data**: TerraClimate: Monthly Climate and Climatic Water Balance for Global Terrestrial Surfaces, University of Idaho<br>**Visualization by Isaac Arroyo (@unisaacarroyov)**") +
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_markdown(face='bold', size = 11),
      axis.text.y = element_markdown(face='bold', size = 11),
      axis.title.x = element_blank(),
      legend.position = "top",
      legend.box.margin = margin(-5,0,-6,-60),
      legend.title = element_markdown(size=8),
      legend.text = element_text(size = 8, face="bold")
    )
)
ggsave("./R/visualizing_environmental_data/images/visualizing_environmental_data_pt1_scatter_pdsi.png", width = 1080, height = 1080, dpi=300, scale=1.8, units = "px" )
