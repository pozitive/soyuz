var ready = function() {
function initialize() {
  var myLatlng = new google.maps.LatLng(43.77004,87.643131);
  var mapOptions = {
    zoom: 14,
    center: myLatlng,
    disableDefaultUI: true

  }
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      title: 'Офис в Урумчи!'
  });
  var myLatlngGuangzhou = new google.maps.LatLng(23.126626,113.317233);
  var mapOptions = {
    zoom: 14,
    center: myLatlngGuangzhou,
    disableDefaultUI: true

  }
  var map = new google.maps.Map(document.getElementById('map-guangzhou'), mapOptions);
  var marker = new google.maps.Marker({
      position: myLatlngGuangzhou,
      map: map,
      title: 'Офис в Гуанчжоу!'
  });
}
google.maps.event.addDomListener(window, 'load', initialize);
};
$(document).ready(ready);
$(document).on('page:load', ready);
