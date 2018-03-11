<%@ Page Language="C#" Inherits="SDHackathon.Default" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Crazy Park</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      .pac-card {
        margin: 10px 10px 0 0;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        background-color: #fff;
        font-family: Roboto;
      }
      #pac-container {
        padding-bottom: 12px;
        margin-right: 12px;
      }

      .pac-controls {
        display: inline-block;
        padding: 5px 11px;
      }

      .pac-controls label {
        font-family: Roboto;
        font-size: 13px;
        font-weight: 300;
      }

      #pac-input {
        background-color: #fff;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        margin-left: 12px;
        padding: 0 11px 0 13px;
        text-overflow: ellipsis;
        width: 400px;
      }
            
      #pac-input:focus {
        border-color: #4d90fe;
      }

      #title {
        color: #fff;
        background-color: #4d90fe;
        font-size: 25px;
        font-weight: 500;
        padding: 6px 12px;
      }

    </style>
    <!-- Font Awesome Icon Library -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
    .checked {
        color: orange;
    }
    </style>
  </head>
  <body>
    <div class="pac-card" id="pac-card">
        <div id="title">
            Crazy Park
        </div>
        <div id="pac-container">
            <input id="pac-input" type="text"
                placeholder="Enter a location">
      </div>
    </div>
    <div id="map"></div>
    <script>
      var map;
      var infowindow;
      function initMap() {
        var myLatlng = {lat: 32.7157, lng: 117.1611};

        infowindow = new google.maps.InfoWindow();
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 17,
          center: myLatlng
        });

        var card = document.getElementById('pac-card');
        var input = document.getElementById('pac-input');
        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(card);

        var autocomplete = new google.maps.places.Autocomplete(input);

        // Bind the map's bounds (viewport) property to the autocomplete object,
        // so that the autocomplete requests use the current map bounds for the
        // bounds option in the request.
        autocomplete.bindTo('bounds', map);

          var infowindow2 = new google.maps.InfoWindow();
          var infowindowContent = document.getElementById('infowindow-content');
        infowindow2.setContent(infowindowContent);
          autocomplete.addListener('place_changed', function() {
          infowindow2.close();
          marker.setVisible(false);
          var place = autocomplete.getPlace();
          if (!place.geometry) {
            // User entered the name of a Place that was not suggested and
            // pressed the Enter key, or the Place Details request failed.
            window.alert("No details available for input: '" + place.name + "'");
            return;
          }

          // If the place has a geometry, then present it on a map.
          if (place.geometry.viewport) {
            map.fitBounds(place.geometry.viewport);
          } else {
            map.setCenter(place.geometry.location);
            map.setZoom(17);  // Why 17? Because it looks good.
          }
          marker.setPosition(place.geometry.location);
          marker.setVisible(true);

          var address = '';
          if (place.address_components) {
            address = [
              (place.address_components[0] && place.address_components[0].short_name || ''),
              (place.address_components[1] && place.address_components[1].short_name || ''),
              (place.address_components[2] && place.address_components[2].short_name || '')
            ].join(' ');
          }

          infowindowContent.children['place-icon'].src = place.icon;
          infowindowContent.children['place-name'].textContent = place.name;
          infowindowContent.children['place-address'].textContent = address;
          infowindow2.open(map, marker);
        });

        var address = "San Diego, CA";         geocoder = new google.maps.Geocoder();         if (geocoder) {         geocoder.geocode({           'address': address         }, function(results, status) {           if (status == google.maps.GeocoderStatus.OK) {             if (status != google.maps.GeocoderStatus.ZERO_RESULTS) {               map.setCenter(results[0].geometry.location);

              var request = {
                location: map.getCenter(),
                radius: '1000',
                type: ['parking']
              };
              service = new google.maps.places.PlacesService(map);
              service.nearbySearch(request, callback);

                         } else {               alert("No results found");             }           } else {             alert("Geocode was not successful for the following reason: " + status);           }         });
      }        
    }

    function stars(number) {
        if (!number) return '';
        var ret = '</p>Google rating:';
        var roundedNumber = Math.round(number);
        for (i = 0; i < roundedNumber; ++i) {
            ret += '<span class="fa fa-star checked"></span>';
        }
        ret += '</p>';
        return ret;
    }

    var car = {
        path: 'M12 0c-5.523 0-10 4.394-10 9.815 0 5.505 4.375 9.268 10 14.185 5.625-4.917 10-8.68 10-14.185 0-5.421-4.478-9.815-10-9.815zm0 18c-4.419 0-8-3.582-8-8s3.581-8 8-8c4.419 0 8 3.582 8 8s-3.581 8-8 8zm1.08-9.204c0 .745-.549 1.008-1.293 1.008h-.463v-1.979h.64c.705 0 1.116.256 1.116.971zm3.92-1.713v5.833c0 1.151-.933 2.084-2.083 2.084h-5.834c-1.15 0-2.083-.933-2.083-2.083v-5.834c0-1.15.933-2.083 2.083-2.083h5.833c1.151 0 2.084.933 2.084 2.083zm-2.5 1.663c0-.69-.21-1.209-.628-1.557-.42-.348-1.031-.522-1.836-.522h-2.119v6.667h1.407v-2.371h.604c.823 0 1.457-.19 1.903-.57.446-.381.669-.93.669-1.647z',
        scale: 1.8,
        fillColor: 'green',
        fillOpacity: 0.5
    };

    function getData(id) {
        var savedData = localStorage.getItem(id);
        if (!savedData)
            return "";
        return '<p>People have paid: ' + savedData + ' to park here</p>';
    }
            
    function createMarker(place) {
        var marker = new google.maps.Marker({
          map: map,
          icon: car,
          position: place.geometry.location
        });

        google.maps.event.addListener(marker, 'click', function() {
          infowindow.setContent('<p>' + place.name + '</p>' +
            getData(place.place_id) +    
            stars(place.rating) + 
            '<button onclick="myFunction(\'' + place.place_id + '\')">I\'ve parked here!</button>');
          infowindow.open(map, this);
        });
    }

    function callback(results, status) {
      if (status == google.maps.places.PlacesServiceStatus.OK) {         for (var i = 0; i < results.length; i++) {           var place = results[i];           createMarker(results[i]);         }       }
    }

    function myFunction(id) {
      var name=prompt("How much did you pay?", "");
            if (name != null)
            {
            var prevData = localStorage.getItem(id)
            if (prevData) {
                            name += "</br>";
                localStorage.setItem(id, [prevData, name])
            }else {
                name += "</br>";
                localStorage.setItem(id, name);
            }
            }
    }
            
    </script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjz57gMI7K5c6YSEutrxCPGO2WJ5V3PjA&callback=initMap&libraries=places">
    </script>
  </body>
</html>