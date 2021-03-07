import numpy as np
import pandas as pd
import folium
from folium.plugins import HeatMap
import datetime

# ===================== FUNCTIONS =================================== #
def degres2decimal(a_degree, a_minute, a_seconds):
    """
    This functions has as input numpy-arrays of degrees, minutes and seconds and
    returns a decimal degree array
    """
    degree = a_degree.astype(int)
    minute = a_minute.astype(int)
    seconds = a_seconds.astype(int)
    return degree + minute/60 + seconds/3600

# ========================= CODE ==================================== #
load_data = 'data/Annual_Fire_History_Series_MX_(2017).xlsx'
df = pd.read_excel(load_data)
renamed_columns = {'Grados': 'Degrees', 'Minutos': 'Minutes', 'Segundos':'Seconds',
                  'Grados.1': 'Degrees.1', 'Minutos.1': 'Minutes.1', 'Segundos.1':'Seconds.1',
                  'Duración días': 'Duration time (days)', 'Total':'Affected area (ha)', 'Estado': 'STATE'}
df.rename(columns=renamed_columns, inplace=True)

Degrees_changed = np.where( df['Degrees'].values != '19°', df['Degrees'].values, 19 )
df['Degrees'] = Degrees_changed
df['Latitude'] = degres2decimal(df['Degrees'], df['Minutes'], df['Seconds'])
df['Longitude'] = degres2decimal(df['Degrees.1'], df['Minutes.1'], df['Seconds.1'])
#multiply by -1
df['Longitude'] = df['Longitude'].values * -1

df.drop(columns=['Degrees', 'Minutes', 'Seconds', 'Degrees.1', 'Minutes.1', 'Seconds.1'], inplace = True)

# ---- Creating the HeatMap
loc = df[ ['Latitude', 'Longitude'] ].to_numpy()
map_heatmap = folium.Map( location= (df['Latitude'].mean(), df['Longitude'].mean()), zoom_start= 6 )
HeatMap( data = loc, radius = 10, max_val = 3, min_opacity = 0.5, blur = 8).add_to(map_heatmap)
map_heatmap.save('maps/proximity_heatmap.html')

print('Saved map as proximity_heatmap.html')
