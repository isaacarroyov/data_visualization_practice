library(dplyr)
library(ggplot2)
theme_set(theme_light(base_family = "Georgia"))

df = read.csv('data/temperature_data_yuc.csv')

# List of Months
months_factors = c("January", "February","March","April","May", "June","July", "August","September", "October","November","December")
df = df %>%
  mutate(Year= factor(Year),
         Month = factor(Month, labels = months_factors))

# Avg temperature from 2001-2019
mid = mean(df$Temperature)

# Set width and height
width = 1350
height = 1080
w = width * 0.6
h = height * 0.6

# Create arrows coordinates
arrows1 = tibble(
  x1 = c(37, 40, 14),
  x2 = c(mid+0.3, 42.43173, 10.25),
  y1 = c(11.85,5.4, 2),
  y2 = c(11.55, 7.8, 1.05)
)
arrows2 = tibble(
  x1 = c(15),
  x2 = c(32),
  y1 = c(9.1),
  y2 = c(9.2)
)
arrows3 = tibble(
  x1 = c(15),
  x2 = c(32),
  y1 = c(7.7),
  y2 = c(7.7)
)


# Set seed
set.seed(2022)
# Base plot
(g = ggplot(df, aes(x=Temperature, y=Month, color=Temperature)) +
  labs(x="Temperature (ºC)", y=NULL,
       title = "19 years of temperature data",
       subtitle = "Yucatan, Mexico. From 2001 to 2019\n",
       caption = "\nData: MOD11A1.006 Terra Land Surface Temperature and\nEmissivity Daily Global 1km via Google Earth Engine\n\nVisualization by Isaac Arroyo (@unisaacarroyov)"
       ) +
  scale_y_discrete(limits=rev) +
  scale_x_continuous(limits = c(8,45)) +
  scale_colour_gradient2(low='#407B28',
                         mid='#FFF599',
                         high='#AE0A25',
                         midpoint = mid) +
  theme(
    legend.position = "none",
    plot.title = element_text(size=0.03 * w),
    plot.subtitle = element_text(size=0.02 * w),
    plot.caption = element_text(size=0.015 * w, color = "gray60"),
    axis.title.x = element_text(size=0.024 * w),
    axis.text.x = element_text(size=0.020 * w),
    axis.text.y = element_text(size=0.023 * w),
    axis.line = element_line(colour = 'gray70'),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    plot.margin = margin(0, 0, 0, 0)
  ))


(g_plot = g + geom_jitter(height = 0.13, size=3, alpha=0.15) +
  geom_segment(aes(y=Month, yend=Month,
                   x=MonthMeanTemp_History, xend=mid),
               colour='black', size=0.6) +
  geom_vline(xintercept = mid, color='black', size=0.6, alpha=0.8) +
  stat_summary(fun=mean, geom = "point", size=5, colour='black'))

(g_plot_text = g_plot + annotate(geom = "text",
                                x=39, y= 12, size=5.25, color = "gray20",
                                family = 'Georgia', hjust=0.5,
                                label = glue::glue("Mean temperature:\n{round(mid,1)} ºC")
) +
    annotate(geom="text",
             x=15,y=8.5, size=5.25, color = "gray20",
             family = 'Georgia', hjust=0.5,
             label = "The hottest months are\nApril and May"
) +
    annotate(geom="text",
             x=40,y=4.5, size=5.25, color = "gray20",
             family = 'Georgia', hjust=0.5,
             label = glue::glue("The highest recorded\ntemperature is {round(max(df$Temperature),1)} ºC\n({as.character(df$Month[which.max(df$Temperature)])}, {as.character(df$Year[which.max(df$Temperature)])})")
) +
    annotate(geom="text",
             x=14,y=3, size=5.25, color = "gray20",
             family = 'Georgia', hjust=0.5,
             label = glue::glue("The lowest recorded\ntemperature is {round(min(df$Temperature),1)} ºC\n({as.character(df$Month[which.min(df$Temperature)])}, {as.character(df$Year[which.min(df$Temperature)])})")
  )
)


# Add arrows to plot
(g_final = g_plot_text + geom_curve(
  data = arrows1,
  aes(x=x1,xend=x2, y=y1, yend=y2),
  arrow = arrow(length = unit(10,'points')),
  size = 0.7,
  color='gray20',
  curvature = -0.2
) +
  geom_curve(
    data = arrows2,
    aes(x=x1,xend=x2, y=y1, yend=y2),
    arrow = arrow(length = unit(10,'points')),
    size = 0.7,
    color='gray20',
    curvature = -0.2
  ) +
  geom_curve(
    data = arrows3,
    aes(x=x1,xend=x2, y=y1, yend=y2),
    arrow = arrow(length = unit(10,'points')),
    size = 0.7,
    color='gray20',
    curvature = 0.2
  ))

