library(dplyr)
library(ggplot2)
library(forcats)
library(MetBrewer)


# LOAD DATA
df <- read.csv("data/platforms_demographic_groups.csv")


df %>%
  mutate(platform = fct_reorder(platform, values)) %>%
  ggplot(aes(y=platform, x=values, color=platform)) +
  geom_segment(aes(y=platform, yend=platform, x=0, xend=values), color='black', size=0.4) +
  geom_point(size=2) + 
  geom_text(aes(label=paste(values, '%'), x=values),
            size=1, color = 'black', family = 'Optima', fontface='bold') +
  geom_text(aes(label=platform, x=0),
            size=1.3, color = 'black', family = 'Optima', fontface='italic') +
  xlim(0,100) +
  scale_color_manual(values = met.brewer(name = 'Archambault', n = 11)) +
  coord_polar(theta = 'x', clip = 'off', start = 0) +
  facet_wrap(~group) +
  theme_minimal(base_family = 'Optima') +
  theme(
    legend.position = "none",
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    strip.text = element_text(face = 'bold')
    

  )
#ggsave("./R/task_bloomberg/base_chart_02.svg", units = "px",
#       width = 1080, height = 1080, scale = 1.8)
