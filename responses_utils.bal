import ballerina/io;

const INVALID_RESPONSE = "NULL";
const SCHEMA_OBJECT_KEY = "value";

boolean DEBUG_MODE = false;

function getResponse(AzureOpenAICreateChatCompletionResponse|OpenAICreateChatCompletionResponse response, 
                string prompt, string mode, map<json> schema, typedesc<anydata> expectedTypeDesc) returns anydata|error {
     if mode == JSON_MODE || mode == SO_MODE {
        if response is OpenAICreateChatCompletionResponse {
            OpenAICreateChatCompletionResponse res = check response.cloneWithType(OpenAICreateChatCompletionResponse);
            OpenAICreateChatCompletionResponse_choices[] choices = res.choices;

            OpenAIChatCompletionResponseMessage message = choices[0].message;

            string? content = message?.content;
            return handleResponseContent(content, mode, prompt, schema, expectedTypeDesc);
        }

        if response is AzureOpenAICreateChatCompletionResponse {
            record {|AzureOpenAIChatCompletionResponseMessage message?; anydata...;|}[]? choices = response.choices;
            if choices == () {
                return INVALID_RESPONSE;
            }

            AzureOpenAIChatCompletionResponseMessage? message = choices[0]?.message;
            if message == () {
                return INVALID_RESPONSE;
            }

            string? content = message?.content;
            return handleResponseContent(content, mode, prompt, schema, expectedTypeDesc);
        }
    } 

    if mode == TOOL_CALL_WITH_AUTO_MODE || mode == TOOL_CALL_WITH_FORCE_MODE {
        if response is OpenAICreateChatCompletionResponse {
            OpenAICreateChatCompletionResponse_choices[] choices = response.choices;

            OpenAIChatCompletionResponseMessage message = choices[0].message;
            ChatCompletionMessageToolCall[]? toolCalls = message?.tool_calls;
            if toolCalls == () {
                return INVALID_RESPONSE;
            }

            string? content = toolCalls[0].'function.arguments;
            return handleResponseContent(content, mode, prompt, schema, expectedTypeDesc);
        }

        if response is AzureOpenAICreateChatCompletionResponse {
            record {|AzureOpenAIChatCompletionResponseMessage message?; anydata...;|}[]? choices = response.choices;
            if choices == () {
                return INVALID_RESPONSE;
            }

            AzureOpenAIChatCompletionResponseMessage? message = choices[0].message;
            if message == () {
                return INVALID_RESPONSE;
            }

            ChatCompletionMessageToolCall[]? toolCalls = message?.tool_calls;

            if toolCalls == () {
                return INVALID_RESPONSE;
            }

            string? content = toolCalls[0].'function.arguments;
            return handleResponseContent(content, mode, prompt, schema, expectedTypeDesc);
        }
    }

    return INVALID_RESPONSE;  
}

function handleResponseContent(string? content, string mode, 
            string prompt, map<json> schema, typedesc<anydata> expectedTypeDesc) returns anydata|error {
    if content == () {
        return INVALID_RESPONSE;
    }

    printResponse(content, mode, prompt, schema);
    return parseResponseType(content, expectedTypeDesc, schema, prompt, mode);
}

function parseResponseType(string content, typedesc<anydata> expectedTypeDesc, map<json> schema, 
            string prompt, string mode) returns anydata|error {
    if mode == TOOL_CALL_WITH_AUTO_MODE || mode == TOOL_CALL_WITH_FORCE_MODE || mode == SO_MODE {
        json contentValue = check content.fromJsonStringWithType(); 
        if !isPromptContainsObjectSchemaReturnType(prompt) {
            map<json> v = check contentValue.fromJsonWithType();
            contentValue = v[SCHEMA_OBJECT_KEY];
        }

        return contentValue.fromJsonWithType();
    }

    if mode == JSON_MODE {
        return parseResponseAsType(content, expectedTypeDesc);
    }

    // if mode == SO_MODE {
    //     return parseResponseAsType(content, expectedTypeDesc);
    //     // anydata|error result = trap content.fromJsonStringWithType(expectedTypeDesc);
    //     // if result is error {
    //     //     return handleParseResponseError(result);
    //     // }
    //     // return result;
    // }
}

function printResponse(string content, string mode, string prompt, map<json> schema) {
    int id = getPromptId(prompt);
    if DEBUG_MODE {
        io:println(string `Response in ${mode}, prompt_${id}`, content);
    }
}
