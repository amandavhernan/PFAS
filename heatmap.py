import pandas as pd
import folium
from folium.plugins import HeatMap

# map object
mapObj = folium.Map([39.50, -98.35], zoom_start=4)

# heatmap data
df = pd.read_csv('data/water_sites/water_sites.csv')
data = df.values.tolist()

# rescale each value between 0 and 1 using (val-minColorVal)/(maxColorVal-minColorVal)
# minColorVal = 1, maxColorVal = 60
mapData = [[x[0], x[1], (x[2]-1)/(60-1)] for x in data]

# custom color gradient
colrGradient = {0.0: 'blue',
                0.6: 'cyan',
                0.7: 'lime',
                0.8: 'yellow',
                1.0: 'red'}

# use data to create heatmap and add it to map object
HeatMap(mapData, gradient=colrGradient).add_to(mapObj)

# save map object as html
mapObj.save("index.html")