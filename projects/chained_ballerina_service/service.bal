import ballerina/io;
import ballerina/http;
import ballerina/observe;
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;
import ballerinax/choreo as _;

# A service representing a network-accessible API
# bound to port `10012`.
service /chainedBallerinaService on new http:Listener(10012) {

    # A resource representing an invokable API method
    # accessible at `/chainedBallerinaService/firstResourceCall`.
    #
    # + caller - the client invoking this resource
    # + request - the inbound request
    resource function get firstResourceCall(http:Caller caller, http:Request request) {
        http:Client clientEndpoint = checkpanic new ("http://localhost:10011");

        var response = clientEndpoint->get("/simplePassThrough/passThroughToPostman");
        handleResponseFromBackend(response);

        // Send a response back to the caller.
        error? result = caller->respond("Hello Ballerina!");
        if (result is error) {
            io:println("Error in responding: ", result);
        }
    }
}

@observe:Observable
function handleResponseFromBackend(http:Response|http:PayloadType|http:ClientError response) {
    if (response is http:Response) {
        var msg = response.getTextPayload();
        if (msg is json) {
            io:println(msg);
        } else {
            io:println("Invalid payload received:", msg.message());
        }
    } else {
        io:println("Error when calling the backend: ", (<error> response).message());
    }
}

public function main() {
    io:println("Send Get Request to http://localhost:10012/chainedBallerinaService/firstResourceCall to call the API");
}
