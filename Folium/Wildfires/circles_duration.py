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

def colour_duration(string):
    if string == '1 Día':
        return '#003049'
    elif string == '2 a 3 Días':
        return '#FCBF49'
    elif string == '4 a 7 Días':
        return '#F77F00'
    else:
        return '#D62828'

def translate_days(string):
    if string == '1 Día':
        return '1 day'
    elif string == '2 a 3 Días':
        return '2 to 3 days'
    elif string == '4 a 7 Días':
        return '4 to 7 days'
    else:
        return 'More than 7 days'

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

# ------------- Creating circle map
loc = df[ ['Latitude', 'Longitude'] ].to_numpy()

df['Duration time (colours)'] = df['Duration time (days)'].values
df['Duration time (colours)'] = df['Duration time (colours)'].apply(colour_duration)
df['Duration time (days)'] = df['Duration time (days)'].apply(translate_days)

map_circles = folium.Map( location= ( df.Latitude.mean(), df.Longitude.mean() ), zoom_start= 6 )

for i in range(loc.shape[0]):
    folium.Circle(
    location = loc[i].tolist(),
    radius = 7e3, # 7000 m = 7 km
    popup = df['Duration time (days)'].values[i],
    color = df['Duration time (colours)'].values[i],
    fill = True,
    fill_color = df['Duration time (colours)'].values[i]
    ).add_to(map_circles)

map_circles.save('maps/circles_duration.html')
print('Saved map as circles_duration.html')
