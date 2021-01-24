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
