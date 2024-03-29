// Copyright (c) 2021, Ballerina Dev Kit. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ballerina/io;
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

        io:println("Sending GET Request to Postman Echo");
        var response = clientEndpoint->get("/get?test=123", targetType = http:Response);
        if (response is http:Response) {
            var msg = response.getJsonPayload();
            if (msg is json) {
                io:println("Received Payload for GET Request: " + msg.toJsonString());
            } else {
                io:println("Invalid payload received:", msg.message());
            }
        } else {
            io:println("Error when calling the backend: ", (<error> response).message());
        }

        io:println("Sending POST Request to Postman Echo");
        response = clientEndpoint->post("/post", "POST: Hello World", targetType = http:Response);
        if (response is http:Response) {
            var msg = response.getJsonPayload();
            if (msg is json) {
                io:println("Received Payload for POST Request: " + msg.toJsonString());
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
