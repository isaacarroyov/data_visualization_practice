library(dplyr)
library(sf)
library(geojsonsf)
library(ggplot2)
#library(ggforce)
library(cartogram)
#library(cowplot)
#library(patchwork)
#library(MetBrewer)


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
theme_set(theme_light(base_family = "Georgia"))
theme_update(
    panel.background = element_rect(fill = "#ffffff"),
    plot.background = element_rect(fill='#ffffff'),
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
        labs(title="Total hectares", caption = "viz by me")
)


(map_NumWildfires <- carto_NumWildfires %>%
        ggplot(aes(fill=NumWildfires)) + 
        geom_sf(color='transparent') + 
        labs(title="Num Wildfires", caption = "viz by me")
)


(map_PercentageANPHectares <- carto_PercentageANPHectares %>%
        ggplot(aes(fill=PercentageANPHectares)) +
        geom_sf(color="transparent") +
        labs(title="Percentage ANP ha", caption = "viz by me")
)


