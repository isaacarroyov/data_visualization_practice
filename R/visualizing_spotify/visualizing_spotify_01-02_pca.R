library(dplyr)
library(ggplot2)
library(ggtext)
library(ggforce)
library(MetBrewer)
library(patchwork)

# Data preparation
df = read.csv("data/spotify_songs_01_pca.csv")
df$artist_top_ten = factor(df$artist_top_ten,
                           levels = c("Alessia Cara","Dua Lipa",
                                      "5 Seconds of Summer","Residente/Calle 13",
                                      "Fifth Harmony","Ed Sheeran",
                                      "Taylor Swift","Galantis",
                                      "The Chainsmokers","One Direction","Other"))

# Set width and height
width = 1350
height = 1080
w = width * 0.7
h = height * 0.7

# Theme
theme_set(theme_light(base_family = "Georgia"))
theme_update(
  panel.background = element_rect(fill = "#ffffff"),
  plot.background = element_rect(fill='#ffffff'),
  legend.position = "none",
  plot.title = element_markdown(size=40),
  plot.subtitle = element_markdown(family = "Georgia"),
  plot.caption = element_markdown(family = "Georgia", size=10, colour='gray50'),
  axis.title.x = element_blank(),
  axis.title.y = element_blank(),
  axis.text.x = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.border = element_blank(),
)


# Annotations
df_annotations = tribble(
  ~x, ~y, ~label,
  5,-0.6,"**Falling by Harry Styles (Album: Fine Line).**<br>The second saddest song in the dataset. It has a positivity of 0.0592",
  8,0.706898436,"**Burning Love by Elvis Presley.**<br>The second happiest of the data set with a positivity of 0.972.",
  10, -0.1, '**Out Of Love by Alessia Cara (Album: Growing Pains)**<br>I love the perspective the song gives. It is not about _"come back"_, it is about _"I know you are not coming back, but let me ask you... when did you fall out of love?"_',
  -5, 0.9, "**Levitating by Dua Lipa (Album: Future Nostalgia)**<br>It is my go-to song to uplift my mood."
)

# Arrows from annotations to points
df_annotations_arrows = tribble(
  ~x1,~x2,~y1,~y2,
  5, 1.1, -0.75, -0.8,
  8, 5.2, 0.7, 0.72,
  10, 3.5, -0.45, -0.55,
  -5, -4.2, 0.7, 0.1
)

# Scatter chart
(p2 = df %>% 
  ggplot(aes(x=z1, y=z2,colour=artist_top_ten, size=acousticness, alpha=valence)) +
  geom_textbox(data = df_annotations, aes(x=x,y=y,label=label, hjust=0,vjust=1),
               color='black', alpha=1, family = 'Georgia',
               box.colour='white', size=3, maxwidth = 0.3) +
  geom_curve(data = df_annotations_arrows,
             aes(x=x1,xend=x2,y=y1,yend=y2, alpha=1),
             arrow = arrow(length = unit(10,'points')),
             size = 0.6,
             color='gray20',
             curvature = 0.3) +
  geom_point() +
  scale_colour_manual(values = met.brewer(name="Hiroshige", n=11)) +
  scale_size(range=c(0.5,8)) +
  scale_alpha(range=c(0.05,1)) +
  labs(caption = "<b>Data:</b> Spotify personal data.<br><br> <b>Visualization by Isaac Arroyo<br>(@unisaacarroyov)</b>") +
  coord_cartesian(clip = "off")
)

  
# Create separate plot for legends and text

# Legend for artists
df_top_10_artists <- as.data.frame(table(df$artist_top_ten))
df_top_10_artists$x = c(0,0.25,0.5,0.75,0,0.25,0.5,0.75,0,0.25,0.5) + 0.1
df_top_10_artists$y = c(-1,-1,-1,-1,-6.25,-6.25,-6.25,-6.25,-11,-11,-11) + 1.3
df_top_10_artists$label_freq_artist = paste0(df_top_10_artists$Var1," with ",df_top_10_artists$Freq, " songs")
# Legend for size -> acousticness
df_legend_size_acousticness = tibble(x=c(0.0,0.16,0.33) + 0.05,
                                     y=c(-15,-15,-15),
                                     size=c(1,4,8),
                                     label=c("Not acoustic", "Kind of acoustic", "Definitely acoustic"))
#Legend for alpha -> sadness
df_legend_alpha_valence = tibble(x=c(0.66,0.83,1)-0.05,
                                 y=c(-15,-15,-15),
                                 alpha=c(0.15,0.5,0.85),
                                 label=c("This song is completely sad","Neither sad nor happy","This song is not sad"))
# Legend plot
(p1 = df_top_10_artists %>%
    ggplot(aes(x=x,y=y,colour=Var1)) +
    geom_textbox(aes(label=label_freq_artist),
                 size = 2.3, maxwidth = 0.25, vjust=1,halign = 0.5,
                 nudge_y=-0.6, color = "black", box.colour = 'white',
                 fontface='bold', family = 'Georgia') + 
    geom_textbox(data= tribble(
      ~x, ~y,~label,
      0, 25, "<b style='font-size:18pt'>Visualizing Spotify:<br>The 5, 4, 3, 2 and 1</b><br><br>Thanks to the marketing campaign **Spotify's Wrapped**, many of us share a summary of what we've been listening to throughout the year. Just like every **summary**, there's **data** in the process. Here, I'm presenting you a **visual overview** of some of **my Spotify's Wrapped playlists**:",
      0, 12.3, "<p><b>· 5 years of music</b>: All the songs I listened to during my time in college (2016-2020)</p> <p><b>· 4 Spotify Audio Features</b>: Energy, Loudness, Acousticness and Song's Positivy </p> <p><b>· 3 encodings</b>: <b>Acousticness</b> (<span style='font-size:13pt'>size</span>), <b>Song's Positivy</b> (<span style='color:gray20'>opa</span><span style='color:gray50'>ci</span><span style='color:gray70'>ty</span>) and whether the <b>artist</b> of the song is part of the <b>top 10</b> or not (<b><span style='color:#e76254'>co</span><span style='color:#ef8a47'>lo</span><span style='color:#528fad'>ur</span></b>).</p>",
      0, -20, "<p><b>· 2-dimensional representation</b>: Principal Component Analysis <b>(PCA)</b> was used for <b>Dimensionality Reduction</b></p> <p><b>· 1 user</b>: Me</p>"
      ),
      aes(x=x,y=y,label=label, hjust=0, vjust=1),
      size=3.3,minwidth =0.95,
      colour = "black", box.colour = 'white',
      family='Georgia') +
    geom_textbox(data=df_legend_size_acousticness, aes(x=x,y=y,label=label),
                 size=2.3, maxwidth = 0.13, vjust=1, halign=0.5, nudge_y = -0.6,
                 color='black', box.colour='white',
                 fontface='bold',family='Georgia') +
    geom_textbox(data=df_legend_alpha_valence, aes(x=x,y=y,label=label),
                 size=2.3, maxwidth = 0.14, vjust=1, halign=0.5, nudge_y = -0.6,
                 color='black', box.colour='white',
                 fontface='bold',family='Georgia') +
    geom_point(size=8) +
    geom_point(data=df_legend_size_acousticness, aes(x=x,y=y, size=size), colour='black', alpha=1) +
    geom_point(data=df_legend_alpha_valence, aes(x=x,y=y,alpha=alpha), colour='black', size=8) +
    scale_colour_manual(values = met.brewer(name="Hiroshige", n=11)) + 
    coord_cartesian(clip = "off") +
    ylim(-23,25) +
    xlim(0,1)
)



(p1 | p2) + plot_layout(widths = c(0.645,1))

# Save the plot 
ggsave('R/visualizing_spotify/images/visualizing_spotify_01-02_pca.png',
       width = w, height = h,
       units = "px", dpi = 300, scale = 3)
