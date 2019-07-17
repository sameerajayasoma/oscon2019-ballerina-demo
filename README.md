# oscon2019-ballerina-demo
This repository contains Ballerina code samples that I've used in my talk at OSCON 2019. 

https://conferences.oreilly.com/oscon/oscon-or/public/schedule/detail/75822

- 1_hello_world.bal - A function that prints to the console
- 2_hello_service.bal - An HTTP service that returns a string when invoked
- 3_coords_service.bal - An HTTP service that gives you the coordinates of a given city
- 4_sunset_sunrise_service.bal - An HTTP service that gives you the sunrise, sunset times for a given city
- 5_coordinates - Introduce strands with asynchronous function invocation
- 6_workers.bal - Introduce workers in Ballerina

## Running samples
- Subscribe and get your free API key from https://openweathermap.org/current. 
- Then set the API key as an environment variable

```
ballerina build 3_coords_service.bal
ballerina run 3_coords_service.jar
```