
isolated function getPromptWithExpectedResponseSchema(string prompt, map<json> schema) returns string {
    string suffix = string `The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}
        
        Schema:
        ${schema.toJsonString()}`;
    
    if prompt == PROMPT_5 {
        suffix = string `The output strictly should be a 'string', 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}`;
    }

    if prompt == PROMPT_6 {
        suffix = string `The output strictly should be a 'integer'. No additional text or explanation is needed., 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}`;
    }
    
    return string `${prompt}
        ---
        ${suffix}`;
}

// isolated function getPromptWithExpectedResponseSchemaForSOMode(string prompt, string mode, map<json> schema) returns string {
//     if mode != SO_MODE {
//         return prompt;
//     }

//     if !isPromptContainsNonJsonSchemaType(prompt) {
//         return prompt;
//     }

//     return string `${prompt}. The output should satisfies the ${schema.toJsonString()},
//         returned within a markdown snippet enclosed within ${"```json"} and ${"```"}`;
// }

isolated function parseResponseAsJson(string resp) returns json|error {
    int startDelimLength = 7;
    int? startIndex = resp.indexOf("```json");
    if startIndex is () {
        startIndex = resp.indexOf("```");
        startDelimLength = 3;
    }
    int? endIndex = resp.lastIndexOf("```");

    string processedResponse = startIndex is () || endIndex is () ? 
        resp : 
        resp.substring(startIndex + startDelimLength, endIndex).trim();
    json|error result = trap processedResponse.fromJsonString();
    if result is error {
        return handleParseResponseError(result);
    }
    return result;
}

isolated function parseResponseAsType(string resp, typedesc<anydata> expectedResponseTypedesc) returns anydata|error {
    json respJson = check parseResponseAsJson(resp);
    anydata|error result = trap respJson.fromJsonWithType(expectedResponseTypedesc);
    if result is error {
        return handleParseResponseError(result);
    }
    return result;
}

isolated function handleParseResponseError(error chatResponseError) returns error {
    if chatResponseError.message().includes(JSON_CONVERSION_ERROR) 
            || chatResponseError.message().includes(CONVERSION_ERROR) {
        return error(string `${ERROR_MESSAGE}`, detail = chatResponseError);
    }
    return chatResponseError;
}
