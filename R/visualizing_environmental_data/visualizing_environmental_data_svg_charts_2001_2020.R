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
  axis.title = element_blank(),
  axis.text.y = element_blank(),
  axis.text.x = element_markdown(size=11, face = 'bold', margin = margin(5,0,0,0)),
  panel.grid = element_blank(),
  panel.grid.major.x = element_line(color='black', linetype = 'dotted', size=0.2),
  panel.grid.minor.x = element_line(color='black', linetype = 'dotted', size=0.2),
  panel.border = element_blank(),
)

# J I T T E R   C H A R T S
# Temperature 
(chart_temperature_jitter_svg = df %>%
    ggplot(aes(x=temperature, y=Month, color=temperature)) +
    geom_jitter(height = 0.13, size=3, alpha=0.7) +
    scale_x_continuous(breaks = seq(20,40, 3)) +
    scale_color_gradientn(colors = met.brewer("Demuth"), trans='reverse') +
    geom_segment(data=df_monthly_avg, aes(y=Month, yend=Month, x=temperature_monthly_avg, xend=mean(df$temperature)),
                 color = 'black', size=1) +
    stat_summary(fun=mean, geom = "point", size=7, color='black') +
    geom_vline(aes(xintercept= historic_mean_temperature), color='black', size=1) +
    scale_y_discrete(limits=rev) +
    coord_cartesian(clip="off")
)


# Soil moisture
(chart_soil_moisture_jitter_svg = df %>%
    ggplot(aes(x=soil_moisture, y=Month, color=soil_moisture)) +
    geom_jitter(height = 0.13, size=3, alpha=0.7) +
    scale_x_continuous(breaks = seq(10,200, 35)) +
    scale_color_gradientn(colors = met.brewer("Ingres"), trans='reverse') +
    geom_segment(data=df_monthly_avg, aes(y=Month, yend=Month, x=soil_moisture_monthly_avg, xend=mean(df$soil_moisture)),
                 color = 'black', size=1) +
    stat_summary(fun=mean, geom = "point", size=7, color='black') +
    geom_vline(aes(xintercept= historic_mean_soil_moisture), color='black', size=1) +
    scale_y_discrete(limits=rev) +
    coord_cartesian(clip="off")
)


(chart_pdsi_jitter_svg = df %>% 
    ggplot(aes(x=pdsi, y=Month, color=pdsi)) +
    geom_jitter(height = 0.13, size=3, alpha=0.7) +
    scale_x_continuous(breaks = seq(-8,8,2)) +
    scale_color_gradientn(colors = met.brewer("OKeeffe1")) +
    geom_segment(data=df_monthly_avg, aes(y=Month, yend=Month, x=pdsi_monthly_avg, xend=mean(df$pdsi)),
                 color = 'black', size=1) +
    stat_summary(fun=mean, geom = "point", size=6, color='black') +
    geom_vline(aes(xintercept= historic_mean_pdsi), color='black', size=1) +
    scale_y_discrete(limits=rev) +
    coord_cartesian(clip="off")
)


# S C A T T E R  C H A R T S

(chart_temperature_scatter_svg = df %>%
    ggplot(aes(x=Year, y=Month, color=temperature)) +
    geom_point(size=6) +
    scale_color_gradientn(colors = met.brewer("Demuth"), trans='reverse') +
    scale_y_discrete(limits=rev) +
    theme(
      axis.text.x = element_blank(),
    )
)


(chart_soil_moisture_scatter_svg = df %>%
    ggplot(aes(x=Year, y=Month, color=soil_moisture)) +
    geom_point(size=6) +
    scale_color_gradientn(colors = met.brewer("Ingres"), trans='reverse') +
    scale_y_discrete(limits=rev) +
    theme(
      axis.text.x = element_blank(),
    )
)



(chart_soil_moisture_scatter_svg = df %>%
    ggplot(aes(x=Year, y=Month, color=pdsi)) +
    geom_point(size=6) +
    scale_color_gradientn(colors = met.brewer("OKeeffe1")) +
    scale_y_discrete(limits=rev) +
    theme(
      axis.text.x = element_blank(),
    )
)

#ggsave("./../Vector_DataViz_Design/Visualizing Environmental Data/Pt I/charts/chart_scatter_pdsi.svg",
#       width = 1080, height = 1080, scale=1.8, units = "px" )







