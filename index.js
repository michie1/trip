import { Elm } from './src/Main.elm'
import Map from 'ol/Map.js';
import View from 'ol/View.js';
import TileLayer from 'ol/layer/Tile.js';
import OSM from 'ol/source/OSM.js';

const main = Elm.Main.init({
  node: document.getElementById('main'),
});

/*
var map = new Map({
  layers: [
    new TileLayer({
      source: new OSM()
    })
  ],
  target: 'map',
  view: new View({
    center: [0, 0],
    zoom: 2
  })
});
*/


// https://nominatim.openstreetmap.org/search?q=strasbourg&format=json&limit=11&addressdetails=1&polygon_geojson=1
// filter osm_type relation and type city


main.ports.infoForOutside.subscribe(function (msg) {
  console.log(msg);
});
