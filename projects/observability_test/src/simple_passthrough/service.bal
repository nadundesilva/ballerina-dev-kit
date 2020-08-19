import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/observe;

http:Client clientEndpoint = new ("http://postman-echo.com");

# A service representing a network-accessible API
# bound to port `9090`.
service hello on new http:Listener(9091) {

    # A resource representing an invokable API method
    # accessible at `/hello/sayHello`.
    #
    # + caller - the client invoking this resource
    # + request - the inbound request
    resource function sayHello(http:Caller caller, http:Request request) {

        log:printInfo("Sending GET Request to Postman Echo");
        var response = clientEndpoint->get("/get?test=123");
        handleResponse(response);

        sendPostRequest();

        // Send a response back to the caller.
        error? result = caller->respond("Hello from Ballerina Dev Kit!");
        if (result is error) {
            io:println("Error in responding: ", result);
        }
    }
}

@observe:Observable
function sendPostRequest() {
    log:printInfo("Sending POST Request to Postman Echo");
    var response = clientEndpoint->post("/post", "POST: Hello World");
    handleResponse(response);
}

@observe:Observable
function handleResponse(http:Response|error response) {
    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg.toJsonString());
        } else {
            io:println("Invalid payload received:", msg.message());
        }
    } else {
        io:println("Error when calling the backend: ", response.message());
    }
}

public function main() {
    io:println("Send Get Request to http://localhost:9091/hello/sayHello to call the API");
}
