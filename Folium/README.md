# Data Visualization Practice: `folium`

## Importance of geospatial data

When we see a fair amount of data related to our city, country or the whole world, we want to know how it looks on a map. Why? It is the primary mode of showing geospatial data.

If we want to do great work exploring and communicating the geospatial data, we need a fast and easy-to-use tool, at least when you are a beginner, and here is where **`folium`** comes into the field.

## What is folium?

According to the [official webpage](https://python-visualization.github.io/folium/):

"**`folium`** builds on the data wrangling strengths of the Python ecosystem and the mapping strengths of the **`leaflet.js`** library. Manipulate your data in Python, then visualize it in on a **Leaflet map** via **`folium`**."

**`folium`** makes it easy to take data manipulated in Python into an interactive map. You can pass rich vector/raster/HTML visualization as markers on the map.

The library has several built-in tilesets from OpenStreetMap, Mapbox, and Stamen and supports custom tilesets with Mapbox or Cloudmade API keys. Folium supports both Image, Video, GeoJSON and TopoJSON overlays.

## Content (mini-projects)
In the attempted to cover all the possible maps, here's the mini-projects list of this section:
* [Visualizing Mexico's wildfire information](https://github.com/isaacarroyov/data_visualization_practice/tree/master/Folium/Wildfires)
*

## Installation

You can install folium with both **`pip`**:

```
pip install folium
```

or **`conda`**:

```
conda install folium -c conda-forge
```

## Examples
![](https://bn02pap001files.storage.live.com/y4mZPnUdOGBHlo9vLAZMvVPX1jXa7T7-HznkHKQpJ0hsC4xWI4mMqluSjz3csyJjATUCZqpA-dQhF6pVnNaURIhHNrCmixLdqtpu8AEt54q-ILNa0tNr8qANLzWBpOg0Pll90v6HfFE_qVCj1tEy7NxapNF2pt0xnZsL56N8_cNFpxGolprXbaEsgT4DXkNSVEf-r7yBYiYlvPyeqyZgvdTaA/world_choropleth.png?psid=1&width=3073&height=1956)
_Choropleth map_

![](https://bn02pap001files.storage.live.com/y4mja-lecU6AYGotCqe53_4vAQD9JSgp7WMwRv-KieUG_AaTlZEG0z2SjzOrAtTR-JwKfUoavMNo4MnPto491iKJ_2pZdGF7eT1FNpv6cL5f6bgOzFY2DYea4rfjD5I6NEPROxxeT6uYdxpabF8RJKhi-S2ZcfGeyrv5ykIIH9S3geVtYfyCXX9LyLQAeIOOg2a2YfgXuCgZOpRnA9Uxhgqzg/merida_map.png?psid=1&width=2250&height=1610)
_Map of a city_
