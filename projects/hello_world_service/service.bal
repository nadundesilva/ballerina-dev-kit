import ballerina/io;
import ballerina/http;
import ballerinax/prometheus as _;
import ballerinax/jaeger as _;
import ballerinax/choreo as _;

# A service representing a network-accessible API
# bound to port `10010`.
service /hello on new http:Listener(10010) {

    # A resource representing an invokable API method
    # accessible at `/hello/sayHello`.
    #
    # + caller - the client invoking this resource
    # + request - the inbound request
    resource function get sayHello(http:Caller caller) {

        // Send a response back to the caller.
        error? result = caller->respond("Hello from Ballerina Dev Kit!");
    }
}

public function main() {
    io:println("Send Get Request to http://localhost:10010/hello/sayHello to call the API");
}
