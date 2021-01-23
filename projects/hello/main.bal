import ballerina/http;


public function main() {
	http:Client clientEndpoint = new ("http://postman-echo.com");

//	log:print("Sending GET Request to Postman Echo");
	var response = clientEndpoint->get("/get?test=123");
//	if (response is http:Response) {
//		var msg = response.getJsonPayload();
//		if (msg is json) {
//			io:println(msg.toJsonString());
//		} else {
//			io:println("Invalid payload received:", msg.message());
//		}
//	} else {
//		io:println("Error when calling the backend: ", (<error> response).message());
//	}

	
	response = clientEndpoint->post("/post", "POST: Hello World");
//	if (response is http:Response) {
//		var msg = response.getJsonPayload();
//		if (msg is json) {
//			io:println(msg.toJsonString());
//		} else {
//			io:println("Invalid payload received:", msg.message());
//		}
//	} else {
//		io:println("Error when calling the backend: ", (<error> response).message());
//	}
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
