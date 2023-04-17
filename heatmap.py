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
# create colormap with only two values
colormap = folium.LinearColormap(colors=['blue', 'red'], vmin=0.0, vmax=1.0)

# create a new legend with only two labels
legend_html = '<div style="position: fixed; bottom: 50px; left: 50px; z-index:9999; width: 100px; background-color: rgba(255, 255, 255, 0.5); border-radius: 5px; padding: 10px;">'
legend_html += '<p style="font-size:14px; margin:0px"><b>Water Site Density</b></p>'
legend_html += '<div style="background-color: ' + colormap.rgb_hex_str(0.0) + '; height: 10px"></div>'
legend_html += '<p style="font-size:12px; margin:0px">0.0</p>'
legend_html += '<div style="background-color: ' + colormap.rgb_hex_str(1.0) + '; height: 10px"></div>'
legend_html += '<p style="font-size:12px; margin:0px">1.0</p>'
legend_html += '</div>'

# add the legend to the map
mapObj.get_root().html.add_child(folium.Element(legend_html))

# save map object as html
mapObj.save("index.html")