import ballerina/io;
import ballerina/http;
import ballerina/config;

public function main(string... args) {
    worker coordWorker1 returns Coordinates {
        string city = <@untiant> args[0];
        return getCoordinates(city);
    } 

    worker coordWorker2 returns Coordinates {
        string city = <@untiant> args[1]; 
        return getCoordinates(city);
    }

    worker coordWorker3 returns Coordinates {
        string city = <@untiant> args[2];
        return getCoordinates(city);
    }

    Coordinates coords = wait coordWorker1 | coordWorker2 | coordWorker3;
         
    var output = string `Coordinates of ${coords.city}: longitude ${coords.lng}, latitude ${coords.lat}`;
    io:println(output); 
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
public function getCoordinates(string city) returns @tainted Coordinates {
    io:println(city);
    var appId = config:getAsString("OPEN_WEATHER_API_KEY");
    var path = string `/weather?q=${city}&appid=${appId}`;
    http:Response result = checkpanic openWeatherEp->get(path);
    json payload = checkpanic result.getJsonPayload(); 
    return {city: city, lng: <float>payload.coord.lon, lat: <float>payload.coord.lat};
}