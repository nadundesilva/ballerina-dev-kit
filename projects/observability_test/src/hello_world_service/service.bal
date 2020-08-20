import ballerina/http;
import ballerina/io;

# A service representing a network-accessible API
# bound to port `10010`.
service hello on new http:Listener(10010) {

    # A resource representing an invokable API method
    # accessible at `/hello/sayHello`.
    #
    # + caller - the client invoking this resource
    # + request - the inbound request
    resource function sayHello(http:Caller caller, http:Request request) {

        // Send a response back to the caller.
        error? result = caller->respond("Hello from Ballerina Dev Kit!");
        if (result is error) {
            io:println("Error in responding: ", result);
        }
    }
}

public function main() {
    io:println("Send Get Request to http://localhost:10010/hello/sayHello to call the API");
}
