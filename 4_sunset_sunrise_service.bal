import ballerina/log;
import ballerina/http;
import ballerina/config;

// Reads the OpenWeather API key from an env variable
var appId = <@untainted> config:getAsString("OPEN_WEATHER_API_KEY");

// Create a client endpoint for the OpenWeather API
http:Client openWeatherEp = new("http://api.openweathermap.org/data/2.5");

http:Client sunriseSunsetEp = new("http://api.sunrise-sunset.org");

service city on new http:Listener(9090) {
    @http:ResourceConfig {
        path:"/{city}"
    }
    resource function retrieve(http:Caller caller, http:Request request, string city) returns error?{
        // Do a GET on OpenWeather API resource
        string weatherResPath = <@untainted> string `/weather?q=${city}&appid=${appId}`;
        http:Response weatherResp = check openWeatherEp->get(weatherResPath);
        json weatherPayload = check weatherResp.getJsonPayload(); 

        // The following line fails with the error: invalid literal for type 'tuple binding pattern'
        [float, float] [longitude, latitude] = [<float>weatherPayload.coord.lon, <float>weatherPayload.coord.lat];

        // Do a GET on sunrise sunset API resource
        string sunriseResPath = <@untainted> string `/json?lat=${latitude}&lng=${longitude}`;
        http:Response sunriseResp = check sunriseSunsetEp->get(sunriseResPath);
        json sunrisePayload = check sunriseResp.getJsonPayload();

        // Create the response payload
        json resPayload = {
            city: city,
            sunrise: check sunrisePayload.results.sunrise,
            sunset: check sunrisePayload.results.sunset
        };

        // Send the json payload with logitude and latitude to the caller
        var errOptional = caller->respond(resPayload);
        if (errOptional is error) {
            log:printError("Error sending response", errOptional);
        }
    }
}
