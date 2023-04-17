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

# add a title and subtitle to the map
title_html = '<h3 align="center" style="font-size:16px"><b>Water Site Locations Heatmap</b></h3>'
subtitle_html = '<h4 align="center" style="font-size:14px"><i>Showing the distribution of water sites across the United States</i></h4>'
mapObj.get_root().html.add_child(folium.Element(title_html + subtitle_html))

# add a continuous color legend to the map
colormap = folium.LinearColormap(colors=['blue', 'cyan', 'lime', 'yellow', 'red'], index=[0.0, 1.0], caption='Water Site Density', width=300, no_wrap=True)
mapObj.add_child(colormap)

# save map object as html
mapObj.save("index.html")