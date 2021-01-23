import ballerina/io;
import ballerina/log;
import ballerina/http;
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;
import ballerinax/choreo as _;

# A service representing a network-accessible API
# bound to port `10011`.
service /simplePassThrough on new http:Listener(10011) {

    # A resource representing an invokable API method
    # accessible at `/simplePassThrough/passThroughToPostman`.
    #
    # + caller - the client invoking this resource
    # + request - the inbound request
    resource function get passThroughToPostman(http:Caller caller, http:Request request) {
	    http:Client clientEndpoint = checkpanic new("http://postman-echo.com");

        log:print("Sending GET Request to Postman Echo");
        var response = clientEndpoint->get("/get?test=123");
        if (response is http:Response) {
            var msg = response.getJsonPayload();
            if (msg is json) {
                io:println(msg.toJsonString());
            } else {
                io:println("Invalid payload received:", msg.message());
            }
        } else {
            io:println("Error when calling the backend: ", (<error> response).message());
        }

        log:print("Sending POST Request to Postman Echo");
        response = clientEndpoint->post("/post", "POST: Hello World");
        if (response is http:Response) {
            var msg = response.getJsonPayload();
            if (msg is json) {
                io:println(msg.toJsonString());
            } else {
                io:println("Invalid payload received:", msg.message());
            }
        } else {
            io:println("Error when calling the backend: ", (<error> response).message());
        }

        // Send a response back to the caller.
        error? result = caller->respond("Hello from Ballerina Dev Kit!");
        if (result is error) {
            io:println("Error in responding: ", result);
        }
    }
}

public function main() {
    io:println("Send Get Request to http://localhost:10011/simplePassThrough/passThroughToPostman to call the API");
}

public type Person record {
    string name;
    int age;
    Address address;
};

public type Address record {
    string number;
    string street;
    string city;
};
