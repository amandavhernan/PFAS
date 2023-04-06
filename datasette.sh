rm -f tx_pfas.db
# install sqlite, datasette, datasette-vega
pip install sqlite-utils datasette datasette-vega
# install plugins for codespaces and full-text search
datasette install datasette-codespaces datasette-configure-fts
# add data, build db
sqlite-utils insert tx_pfas.db water_sites "data/texas/tx_water_sites.csv" --csv
# turn on db
datasette serve tx_pfas.db