library(dplyr)
library(sf)
library(geojsonsf)
library(ggplot2)
library(ggtext)
library(cartogram)
library(MetBrewer)
library(scales)


# Load data
sf_mex_states = geojson_sf("data/R_vector_conafor_wildfires_2017_states_clean_en_2022-03-04.geojson")

sf_mex_states <- sf_mex_states %>%
    mutate(PercentageANPHectares_carto= replace(PercentageANPHectares, PercentageANPHectares==0, 0.1))


# Create cartograms
carto_TotalHectares <- sf_mex_states %>%
    st_transform(crs="+proj=robin") %>%
    cartogram_cont("TotalHectares", itermax=5) %>%
    select(State, TotalHectares)

carto_NumWildfires <- sf_mex_states %>%
    st_transform(crs="+proj=robin") %>%
    cartogram_cont("NumWildfires", itermax=5) %>%
    select(State, NumWildfires)

carto_PercentageANPHectares <- sf_mex_states %>%
    st_transform(crs="+proj=robin") %>%
    cartogram_cont("PercentageANPHectares_carto", itermax=35) %>%
    select(State, PercentageANPHectares)




# General theme
theme_set(theme_light())
theme_update(
    plot.title = element_markdown(family = "Palatino", face="bold", margin = margin(0,0,15,0), size = 38, hjust = 0.5),
    plot.caption = element_markdown(family='Palatino', size=10, color = "gray60"),
    legend.title = element_markdown(family = "Georgia", face="bold", size = 15),
    legend.text = element_text(family="Georgia", size = 9, face="bold"),
    legend.background = element_blank(),
    panel.background = element_blank(),
    #plot.background = element_rect(fill='transparent'), # To edit on Vectornator
    plot.background = element_rect(fill = "#FFF6EE"), # To publish individual maps on social media
    plot.title.position = "plot",
    plot.caption.position = "plot",
    legend.position = "top",
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    
)




# Create individual plots
(map_TotalHectares <- carto_TotalHectares %>%
        ggplot(aes(fill=TotalHectares)) +
        geom_sf(color='transparent') +
        labs(title="Affected area",
             caption = "**Data**: Comisión Nacional Forestal<br>(CONAFOR), 2017<br><br>**Visualization by Isaac Arroyo<br>(@unisaacarroyov)**"
             ) +
        scale_fill_gradientn(colours = met.brewer("Greek"), labels = scales::comma, breaks=seq(0,190000,25000)) +
        guides(fill = guide_colorbar(title = "Hectares", title.position = "top",
                                     title.hjust = 0.5, barwidth = unit(400,"points"),
                                     barheight = unit(10,"points"), ticks=F))
)
#ggsave('./../map_affected_area_total.png', width = 756, height = 756, units = "px", dpi = 300, scale = 3)
#ggsave('./../map_affected_area_total_social_media.png', width = 756, height = 756, units = "px", dpi = 300, scale = 3)


(map_NumWildfires <- carto_NumWildfires %>%
        ggplot(aes(fill=NumWildfires)) + 
        geom_sf(color='transparent') + 
        labs(title="Number of wildfires",
             caption = "**Data**: Comisión Nacional Forestal<br>(CONAFOR), 2017<br><br>**Visualization by Isaac Arroyo<br>(@unisaacarroyov)**"
        ) +
        scale_fill_gradientn(colours = met.brewer("Greek"), labels = scales::comma, breaks=seq(0,1500,150)) +
        guides(fill = guide_colorbar(title = "Count", title.position = "top",
                                     title.hjust = 0.5, barwidth = unit(400,"points"),
                                     barheight = unit(10,"points"), ticks=F))
        
)
#ggsave('./../map_number_of_wildfires.png', width = 756, height = 756, units = "px", dpi = 300, scale = 3)
#ggsave('./../map_number_of_wildfires_social_media.png', width = 756, height = 756, units = "px", dpi = 300, scale = 3)


(map_PercentageANPHectares <- carto_PercentageANPHectares %>%
        ggplot(aes(fill=PercentageANPHectares)) +
        geom_sf(color="transparent") +
        labs(title=" Affected area that was an NPA",
             caption = "**Data**: Comisión Nacional Forestal<br>(CONAFOR), 2017<br><br>**Visualization by Isaac Arroyo<br>(@unisaacarroyov)**"
        ) +
        scale_fill_gradientn(colours = met.brewer("Greek"), labels = scales::comma, breaks=seq(0,100,10)) +
        guides(fill = guide_colorbar(title = "Percentage (%)", title.position = "top",
                                     title.hjust = 0.5, barwidth = unit(400,"points"),
                                     barheight = unit(10,"points"), ticks=F))
)


#ggsave('./../map_affected_area_anp.png', width = 756, height = 756, units = "px", dpi = 300, scale = 3)
#ggsave('./../map_affected_area_anp_social_media.png', width = 756, height = 756, units = "px", dpi = 300, scale = 3)
