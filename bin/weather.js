#!/usr/bin/env node

var http = require('http');

var opts = {
  host: "api.wunderground.com",
  path: "/api/" + key + "/conditions/q/TX/Pflugerville.json",
  method: "GET"
}

var callback = function(response) {
  var str = '';

  response.on('data', function (chunk) {
    str += chunk;
  });

  response.on('end', function () {
    var json = JSON.parse(str);
    console.log(Math.round(json.current_observation.temp_f));
  });
}

http.request(opts, callback).end();
