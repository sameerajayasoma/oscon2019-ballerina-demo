import ballerina/log;
import ballerina/http;
import ballerina/config;

// Reads the OpenWeather API key from an env variable
var appId = <@untainted> config:getAsString("OPEN_WEATHER_API_KEY");

// Creates a client endpoint for the OpenWeather API
http:Client openWeatherEp = new("http://api.openweathermap.org/data/2.5");

service coordinates on new http:Listener(8080) {
    @http:ResourceConfig {
        path:"/{city}"
    }
    resource function retriew(http:Caller caller, http:Request request, string city) returns error?{
        // Creates a request path using string template literals in Ballerina
        string resourcePath = <@untainted> string `/weather?q=${city}&appid=${appId}`;

        // Do a GET on OpenWeather API resource
        http:Response httpResp = check openWeatherEp->get(resourcePath);

        // Extract the json payload from the HTTP response
        json payload = check httpResp.getJsonPayload(); 

        // Creates the response payload
        json resPayload = {
            city: city,
            longitude: check payload.coord.lon, // lax typing for json for flexibility
            latituede: check payload.coord.lat
        };

        // Send the json payload with logitude and latitude to the caller
        var errOptional = caller->respond(resPayload);
        if (errOptional is error) {
            log:printError("Error sending response", errOptional);
        }
    }
}