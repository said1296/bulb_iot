# bulb_iot
Flutter frontend and Django backend for controlling IoT circuits through an API.

The app sends level changes every 200ms to a remote server with values from 0 to 10 of type float. Any 
circuit could fetch the level from the server if it has the auth credentials for an existing user.

![]{iot.gif}
