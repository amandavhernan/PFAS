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

# create a div element for the title and subtitle
title_div = folium.Element('<div style="position:fixed;top:10px;left:10px;z-index:1000"><h3 style="font-family: Helvetica Neue, Helvetica, Arial, sans-serif"><b>Known PFAS Water Sites Across the U.S.</b></h3></div>')
subtitle_div = folium.Element('<div style="position:fixed;top:50px;left:10px;z-index:1000"><h4 style="font-family: Helvetica Neue, Helvetica, Arial, sans-serif">This interactive heatmap shows the levels of PFAS contamination at various water sites, including drinking water, surface water, and groundwater. Red indicates areas of highest density, or areas where more PFAS-contaminated water sites were found. When zoomed in, areas are re-calculated into more distinct clusters.</h4></div>')

# add the div elements to the map object
title_div.add_to(mapObj.get_root())
subtitle_div.add_to(mapObj.get_root())

# gradient legend
colormap = folium.LinearColormap(colors=['blue', 'cyan', 'lime', 'yellow', 'red'], vmin=0.0, vmax=1.0, caption='Contamination Level')
colormap.add_to(mapObj)

# save map object as html
mapObj.save("index.html")