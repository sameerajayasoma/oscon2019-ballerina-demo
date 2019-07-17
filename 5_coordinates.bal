import ballerina/io;
import ballerina/http;
import ballerina/config;

public function main(string... args) {
    future<Coordinates | error> portlandF = start getCoordinates("Portland,US");
    future<Coordinates | error> seattleF = start getCoordinates("Seattle,US");
    future<Coordinates | error> bostonF = start getCoordinates("Boston,US");

    Coordinates | error coords = wait bostonF | portlandF | seattleF;
    if coords is error {
        io:println(coords);
    } else {      
        var output = string `Coordinates of ${coords.city}: longitude ${coords.lng}, latitude ${coords.lat}`;
        io:println(output);
    }
}

http:Client openWeatherEp = new("http://api.openweathermap.org/data/2.5");

# Represents longitude and latitude of a place in earth.
#
# + city - string Parameter Description 
# + lng - long Parameter Description 
# + lat - lat Parameter Description
public type Coordinates record {
    string city;
    float lng;
    float lat;
};

# Returns longitude and latitude for a given city.
#
# + city - city Parameter Description 
# + return - Return Value Description
public function getCoordinates(string city) returns @tainted Coordinates | error {
    io:println(city);
    var appId = config:getAsString("OPEN_WEATHER_API_KEY");
    var path = string `/weather?q=${city}&appid=${appId}`;
    http:Response result = check openWeatherEp->get(path);
    json payload = check result.getJsonPayload(); 
    return {city: city, lng: <float>payload.coord.lon, lat: <float>payload.coord.lat};
}