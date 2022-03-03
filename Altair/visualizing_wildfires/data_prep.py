import pandas as pd
import geopandas as gpd
from datetime import date

# - - - - - F U N C I O N E S - - - - -
def degres2decimal(a_degree, a_minute, a_seconds, LatOrLong = 'latitude'):
    """
    Transforma Grados, Minutos y Segundos a Grados en sistema decimal

    Esta función tiene como entrada 4 parámetros:
    - a_degree, a_minute y a_seconds son pandas.Series o arreglos de NumPy
      de posición geográfica en grados, minutos y segundos.
    - LatOrLong nos indica si lo que queremos es latitud o longitud
    """
    degree = a_degree.astype(float)
    minute = a_minute.astype(float)
    seconds = a_seconds.astype(float)
    decimal_degree = degree + minute/60 + seconds/3600
    if LatOrLong == 'latitude':
        return decimal_degree
    elif LatOrLong == 'longitude':
        return -1 * decimal_degree

# - - - - - P A R A M E T R O S   I M P O R T A N T E S - - - - -
# Se pueden modificar (agregar o quitar) -> revisar los datos originales en './../../data/conafor_2017_incendios.csv'
list_relevant_variables = ['Estado', 'Municipio', 'Causa', 'Causa especifica', 'Fecha Inicio',
                           'Duración días','Tipo de incendio', 'ANP', 'ANP hectareas',
                           'Tipo Vegetación', 'Tipo impacto', 'Tamaño', 'Total',
                           'Latitude', 'Longitude']

today_date = date.today().strftime("%Y-%m-%d")

# Lectura de datos
df = pd.read_csv('./../../data/conafor_2017_incendios.csv')
gdf_mex_states = gpd.read_file('https://raw.githubusercontent.com/isaacarroyov/crime_analysis_mx2017/master/data/states_mx.json')\
                    .to_crs(4326)

# Preparación de los datos
# -> Eliminar comas y transformar a número
df['Total'] = df['Total'].str.replace(',','').astype(float)
df['Grados.1'] = df['Grados.1'].apply(lambda x : -1 * x if x < 0 else x) # Filtrar grados
# -> Transformar grados
df['Latitude'] = degres2decimal(df['Grados'], df['Minutos'], df['Segundos'], LatOrLong='latitude')
df['Longitude'] = degres2decimal(df['Grados.1'], df['Minutos.1'], df['Segundos.1'], LatOrLong='longitude')
# -> Cambiar a formato de datetime
df['Fecha Inicio'] = pd.to_datetime(df['Fecha Inicio'], dayfirst=True)
# -> Eliminar columnas con datos nulos (son muy pocas y "poco relevantes")
df = df.dropna(axis='columns')

# Crear GeoDataFrame de puntos (incendios)
# -> Al filtrar se pieden casi 60 instancias (de casi poco mas de 8000)
gdf_points = df[df['Latitude'] > 1].reset_index(drop=True)
# -> Usamos solo las variables relevantes
gdf_points = gdf_points[list_relevant_variables]
# -> Transformamos a GeoDataFrame
geometry_gdf_points = gpd.points_from_xy(gdf_points.Longitude, gdf_points.Latitude)
gdf_points = gpd.GeoDataFrame(gdf_points, geometry= geometry_gdf_points, crs=4326)
# -> Guardamos archivo (lo usaremos para futuras visualizaciones)
gdf_points.to_file(f"./../../data/vector_conafor_wildfires_2017_points_clean_{today_date}.geojson", driver='GeoJSON')


# Crear GeoDataFrame de poligonos de los estados de México (+ información de los incendios)
# -> Seleccionar variables de interés
gdf_mex_states = gdf_mex_states[['id', 'name', 'geometry']]
# -> Cambiar el nombre de Distrito Federal a Ciudad de México
gdf_mex_states = gdf_mex_states.set_index('name').rename(index={'Distrito Federal': 'Ciudad de México'})
# -> Agrupar por estado y sumar las hectáreas total afectadas y las de las Áreas Naturales Protegidas (ANP)
df_sums = df.groupby('Estado').sum()[['ANP hectareas','Total']]
# -> Agrupar por estado y contar los registros de incendios forestales
df_counts = df.groupby('Estado').count()[['Grados']].rename(columns={'Grados':'NumIncendios'})
# -> Juntar los dos anteriores dataframes en uno solo
df_states_info = pd.merge(left=df_sums, right=df_counts, left_index=True, right_index=True)
# -> Juntar ese nuevo data frame de información con el dataframe de polígonos del país
gdf_states = pd.merge(left=df_states_info, right=gdf_mex_states, left_index=True, right_index=True)\
             .reset_index(drop=False).rename(columns={'index':'Estado'})
# -> Transformarlo a GeoDataFrame
gdf_states = gpd.GeoDataFrame(data=gdf_states)
# -> Guardarlo para visualizaciones
gdf_states.to_file(f"./../../data/vector_conafor_wildfires_2017_states_clean_{today_date}.geojson", driver='GeoJSON')

