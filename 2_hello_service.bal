import ballerina/http;
import ballerina/log;

// By default, Ballerina exposes an HTTP service via HTTP/1.1.
service hello on new http:Listener(9090) {

    // Resource functions are invoked with the HTTP caller and the
    // incoming request as arguments.
    resource function sayHello(http:Caller caller, http:Request req) {
        // Sends a response back to the caller.
        var result = caller->respond("Hello, OSS 2019!\n");
        // Logs the `error` in case of a failure.
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}

