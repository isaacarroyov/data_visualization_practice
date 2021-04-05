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

def get_color(feature):
    value = map_dict.get(feature['id'])
    if value is None:
        return '#8c8c8c' # MISSING -> gray
    elif value ==1 :
        return '#DAF7A6'
    elif value ==2 :
        return '#FFC300'
    elif value ==3 :
        return '#FF5733'
    elif value ==4 :
        return '#C70039'
    elif value ==5 :
        return '#900C3F'
    elif value ==6 :# 
        return '#581845'

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

# ------------- Obtaining relevant data
loc = df[ ['Latitude', 'Longitude'] ].to_numpy()

affected_area_states = df.groupby(by='STATE').sum()[ 'Affected area (ha)' ].reset_index()

#import the states ID information
load_data_states_id = 'data/states_id.csv'
states_id = pd.read_csv(load_data_states_id, encoding='utf-8')

#rename Ciudad de México --> CDMX & México --> Estado de Mexico
affected_area_states.iloc[6,0] = 'CDMX'
affected_area_states.iloc[16,0] = 'Estado de México'

states_geo_json = 'data/states_mx.json'
affected_area_states = pd.merge(affected_area_states, states_id )

affected_area_states['Category']  = pd.cut(affected_area_states['Affected area (ha)'],
                                           bins=[0.,10000, 25000, 50000,75000,125000, np.inf],
                                           labels=[1, 2, 3, 4, 5,6])

#---------------- Creating the map (without legend)
map_dict = affected_area_states.set_index('IDNAME')['Category'].to_dict()

map_affected_area_states = folium.Map (location=[24,-102], zoom_start=5)

folium.GeoJson(
    data=states_geo_json,
    style_function = lambda feature: {
        'fillColor': get_color(feature),
        'fillOpacity': 0.95,
        'color' : 'black',
        'weight' : 1,
    }    
).add_to(map_affected_area_states)

#map_affected_area_states.save('maps/affected_area_states.html')
#print('Saved map as affected_area_states.html')

#------------- Adding legend to the map

from branca.element import Template, MacroElement

template = """
{% macro html(this, kwargs) %}

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>jQuery UI Draggable - Default functionality</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
  <script>
  $( function() {
    $( "#maplegend" ).draggable({
                    start: function (event, ui) {
                        $(this).css({
                            right: "auto",
                            top: "auto",
                            bottom: "auto"
                        });
                    }
                });
});

  </script>
</head>
<body>

 
<div id='maplegend' class='maplegend' 
    style='position: absolute; z-index:9999; border:2px solid grey; background-color:rgba(255, 255, 255, 0.8);
     border-radius:6px; padding: 10px; font-size:14px; right: 20px; bottom: 20px;'>
     
<div class='legend-title'>Affected area by wildfires in Mexico (2017)</div>
<div class='legend-scale'>
  <ul class='legend-labels'>
    <li><span style='background:#DAF7A6;'></span>0 ha to 10,000 ha </li>
    <li><span style='background:#FFC300;'></span>10,001 ha to 25,000 ha </li>
    <li><span style='background:#FF5733;'></span>25,001 ha to 50,000 ha </li>
    <li><span style='background:#C70039;'></span>50,001 ha to 75,000 ha </li>
    <li><span style='background:#900C3F;'></span>75,001 ha to 125,000 ha </li>
    <li><span style='background:#581845;'></span>More than 125,000 ha </li>



  </ul>
</div>
</div>
 
</body>
</html>

<style type='text/css'>
  .maplegend .legend-title {
    text-align: left;
    margin-bottom: 5px;
    font-weight: bold;
    font-size: 90%;
    }
  .maplegend .legend-scale ul {
    margin: 0;
    margin-bottom: 5px;
    padding: 0;
    float: left;
    list-style: none;
    }
  .maplegend .legend-scale ul li {
    font-size: 80%;
    list-style: none;
    margin-left: 0;
    line-height: 18px;
    margin-bottom: 2px;
    }
  .maplegend ul.legend-labels li span {
    display: block;
    float: left;
    height: 16px;
    width: 30px;
    margin-right: 5px;
    margin-left: 0;
    border: 1px solid #999;
    }
  .maplegend .legend-source {
    font-size: 80%;
    color: #777;
    clear: both;
    }
  .maplegend a {
    color: #777;
    }
</style>
{% endmacro %}"""

macro = MacroElement()
macro._template = Template(template)

map_affected_area_states.get_root().add_child(macro)

map_affected_area_states.save('maps/affected_area_states_legend.html')
print('Saved map as affected_area_states_legend.html')