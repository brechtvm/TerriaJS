FROM node:boron

MAINTAINER Rich Signell <rsignell@usgs.gov>
LABEL Description="TerriaJS dockerized for USGS Applications"

# ------------
# Nodejs, Gdal
# ------------

RUN apt-get update && apt-get install -y git gdal-bin
RUN apt-get update && apt-get install -y git nodejs

# ---------------------
# TerriaJS installation
# ---------------------

RUN npm install -g gulp
RUN mkdir -p /usr/local/app/
WORKDIR /usr/local/app/

# ----------------------------------------
# Use the original TerriaMap branch
# ----------------------------------------

RUN git clone https://github.com/TerriaJS/TerriaMap /usr/local/app/TerriaMap

WORKDIR /usr/local/app/TerriaMap
# If installing more than one instance of TerriaMap then replace the lines above with the ones below to clone in a differnt directory
# For example:
#RUN git clone -b USGS https://github.com/zdefne-usgs/TerriaMap /usr/local/app/TerriaUSGS
#WORKDIR /usr/local/app/TerriaUSGS

# ----------------------------------------
# Customization for USGS
# ----------------------------------------
# COPY ./files/feedback.js /usr/local/app/TerriaMap/node_modules/terriajs-server/lib/controllers/feedback.js
# COPY ./files/index.js /usr/local/app/TerriaMap/index.js
# COPY ./files/UserInterface.jsx /usr/local/app/TerriaMap/lib/Views/UserInterface.jsx
# COPY ./images/ /usr/local/app/TerriaMap/wwwroot/build/

# ----------------------------------------
# Customization for Be-Mobile
# ----------------------------------------
COPY ./terria.json /usr/local/app/TerriaMap/wwwroot/init

RUN npm install
RUN npm run gulp
EXPOSE 3001

# --------------------
# Run within container
# --------------------

CMD [ "node", "node_modules/terriajs-server/lib/app.js", "--config-file", "devserverconfig.json" ]

# ----------------------------------------
# Customization for USGS
# ----------------------------------------
# COPY ./files/feedback.js /usr/local/app/TerriaMap/node_modules/terriajs-server/lib/controllers/feedback.js
# COPY ./files/index.js /usr/local/app/TerriaMap/index.js
# COPY ./files/UserInterface.jsx /usr/local/app/TerriaMap/lib/Views/UserInterface.jsx
# COPY ./images/ /usr/local/app/TerriaMap/wwwroot/build/