// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/mime;

map petData;

public function addPet(http:Request req) returns http:Response {

    // Initialize the http response message
    http:Response resp;
    // Retrieve the data about pets from the json payload of the request
    var reqesetPayloadData = req.getJsonPayload();
    // Match the json payload with json and errors
    match reqesetPayloadData {
        // If the req.getJsonPayload() returns JSON
        json petDataJson => {
            // Transform into Pet data structure
            Pet petDetails = check <Pet>petDataJson;
            if (petDetails.id == "") {
                // Send bad request message to the client if request doesn't contain valid pet id
                resp.setTextPayload("Error : Please provide the json payload with `id`,`catogery` and `name`");
                // set the response code as 400 to indicate a bad request
                resp.statusCode = 400;
            }
            else {
                // Add the pet details into the in memory map
                petData[petDetails.id] = petDetails;
                // Send back the status message back to the client
                string payload = "Pet added successfully : Pet ID = " + petDetails.id;
                resp.setTextPayload(untaint payload);
            }
        }
        error => {
            // Send bad request message to the client if request doesn't contain valid pet data
            resp.setTextPayload("Error : Please provide the json payload with `id`,`catogery` and `name`");
            // set the response code as 400 to indicate a bad request
            resp.statusCode = 400;
        }
    }
    return resp;
}

public function updatePet(http:Request req) returns http:Response {

    // Initialize the http response message
    http:Response resp;
    // Retrieve the data about pets from the json payload of the request
    var reqesetPayloadData = req.getJsonPayload();
    // Match the json payload with json and errors
    match reqesetPayloadData {
        // If the req.getJsonPayload() returns JSON
        json petDataJson => {
            // Transform into Pet data structure
            Pet petDetails = check <Pet>petDataJson;
            if (petDetails.id == "" || !petData.hasKey(petDetails.id)) {
                // Send bad request message to the client if request doesn't contain valid pet id
                resp.setTextPayload("Error : Please provide the json payload with valid `id``");
                // set the response code as 400 to indicate a bad request
                resp.statusCode = 400;
            }
            else {
                // Update the pet details in the map
                petData[petDetails.id] = petDetails;
                // Send back the status message back to the client
                string payload = "Pet updated successfully : Pet ID = " + petDetails.id;
                resp.setTextPayload(untaint payload);
            }
        }

        error => {
            // Send bad request message to the client if request doesn't contain valid pet data
            resp.setTextPayload("Error : Please provide the json payload with `id`,`catogery` and `name`");
            // set the response code as 400 to indicate a bad request
            resp.statusCode = 400;
        }
    }
    return resp;

}

public function getPetById(http:Request req, int petId) returns http:Response {
    // Initialize http response message to send back to the client
    http:Response resp;
    // Send bad request message to client if pet ID cannot found in petData map
    if (!petData.hasKey(<string>petId)) {
        resp.setTextPayload("Error : Invalid Pet ID");
        // set the response code as 400 to indicate a bad request
        resp.statusCode = 400;
    }
    else {
        // Set the pet data as the payload and send back the response
        var payload = <string>petData[<string>petId];
        resp.setTextPayload(untaint payload);
    }
    return resp;
}

public function deletePet(http:Request req, int petId) returns http:Response {
    // Initialize http response message
    http:Response resp;
    // Send bad request message to client if pet ID cannot found in petData map
    if (!petData.hasKey(<string>petId)) {
        resp.setTextPayload("Error : Invalid Pet ID");
        // set the response code as 400 to indicate a bad request
        resp.statusCode = 400;
    }
    else {
        // Remove the pet data from the petData map
        _ = petData.remove(<string>petId);
        // Send the status back to the client
        string payload = "Deleted pet data successfully : Pet ID = " + petId;
        resp.setTextPayload(payload);
    }
    return resp;
}
