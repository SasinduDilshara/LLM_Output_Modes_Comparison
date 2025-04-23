import ballerinax/openai.chat;

const TOOL_NAME = "get_results";

function getRequest(string prompt, string mode, string model, map<json> schema) 
        returns chat:CreateChatCompletionRequest|AzureOpenAICreateChatCompletionRequest|error {
    match model {
        OPENAI_4O_MINI_MODEL => {
            match mode {
                JSON_MODE => {
                    return openAi4OMiniJsonModeRequest(prompt, model, schema);
                }
                SO_MODE => {
                    return openAi4OMiniSOModeRequest(prompt, mode, model, schema);
                }
                TOOL_CALL_WITH_FORCE_MODE => {
                    return openAi4OMiniToolCallForceModeRequest(prompt, model, schema);
                }
                TOOL_CALL_WITH_AUTO_MODE => {
                    return openAi4OMiniToolCallAutoModeRequest(prompt, model, schema);
                }
            }
        }
        OPENAI_4O_MODEL => {
            match mode {
                JSON_MODE => {
                    return openAi4OJsonModeRequest(prompt, model, schema);
                }
                SO_MODE => {
                    return openAi4OSOModeRequest(prompt, mode, model, schema);
                }
                TOOL_CALL_WITH_FORCE_MODE => {
                    return openAi4OToolCallForceModeRequest(prompt, model, schema);
                }
                TOOL_CALL_WITH_AUTO_MODE => {
                    return openAi4OToolCallAutoModeRequest(prompt, model, schema);
                }
            }
        }
        AZURE_OPENAI_4O_MINI_MODEL => {
            match mode {
                JSON_MODE => {
                    return azureOpenAi4OMiniJsonModeRequest(prompt, model, schema);
                }
                SO_MODE => {
                    return azureOpenAi4OMiniSOModeRequest(prompt, mode, model, schema);
                }
                TOOL_CALL_WITH_FORCE_MODE => {
                    return azureOpenAi4OMiniToolCallForceModeRequest(prompt, model, schema);
                }
                TOOL_CALL_WITH_AUTO_MODE => {
                    return azureOpenAi4OMiniToolCallAutoModeRequest(prompt, model, schema);
                }
            }
        }
        AZURE_OPENAI_4O_MODEL => {
            match mode {
                JSON_MODE => {
                    return azureOpenAi4OJsonModeRequest(prompt, model, schema);
                }
                SO_MODE => {
                    return azureOpenAi4OSOModeRequest(prompt, mode, model, schema);
                }
                TOOL_CALL_WITH_FORCE_MODE => {
                    return azureOpenAi4OToolCallForceModeRequest(prompt, model, schema);
                }
                TOOL_CALL_WITH_AUTO_MODE => {
                    return azureOpenAi4OToolCallAutoModeRequest(prompt, model, schema);
                }
            }
        }
    }

    return error("Unsupported model: " + model);
}

function openAi4OMiniJsonModeRequest(string prompt, string model, map<json> schema) 
        returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchema(prompt, schema)}],
        model: model
    };
}

function openAi4OMiniSOModeRequest(string prompt, string mode, string model, map<json> schema) returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchemaForSOMode(prompt, mode, schema)}],
        response_format: getResponseFormatType(prompt, schema),
        model: model
    };
}

function openAi4OMiniToolCallForceModeRequest(string prompt, string model, map<json> schema) returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        model: model,
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ],
        tool_choice: {
            'type: "function",
            'function: {
                name: TOOL_NAME
            }
        }
    };
}

function openAi4OMiniToolCallAutoModeRequest(string prompt, string model, map<json> schema) returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        model: model,
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ]
    };
}

function openAi4OJsonModeRequest(string prompt, string model, map<json> schema) 
        returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchema(prompt, schema)}],
        model: model
    };
}

function openAi4OSOModeRequest(string prompt, string mode, string model, map<json> schema) returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchemaForSOMode(prompt, mode, schema)}],
        response_format: getResponseFormatType(prompt, schema),
        model: model
    };
}

function openAi4OToolCallForceModeRequest(string prompt, string model, map<json> schema) returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        model: model,
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ],
        tool_choice: {
            'type: "function",
            'function: {
                name: TOOL_NAME
            }
        }
    };
}

function openAi4OToolCallAutoModeRequest(string prompt, string model, map<json> schema) returns chat:CreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        model: model,
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ]
    };
}

function azureOpenAi4OMiniJsonModeRequest(string prompt, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchema(prompt, schema)}]
    };
}

function azureOpenAi4OMiniSOModeRequest(string prompt, string mode, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchemaForSOMode(prompt, mode, schema)}],
        response_format: getResponseFormatType(prompt, schema)
    };
}

function azureOpenAi4OMiniToolCallForceModeRequest(string prompt, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ],
        tool_choice: {
            'type: "function",
            'function: {
                name: TOOL_NAME
            }
        }
    };
}

function azureOpenAi4OMiniToolCallAutoModeRequest(string prompt, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ]
    };
}

function azureOpenAi4OJsonModeRequest(string prompt, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchema(prompt, schema)}]
    };
}

function azureOpenAi4OSOModeRequest(string prompt, string mode, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: getPromptWithExpectedResponseSchemaForSOMode(prompt, mode, schema)}],
        response_format: getResponseFormatType(prompt, schema)
    };
}

function azureOpenAi4OToolCallForceModeRequest(string prompt, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ],
        tool_choice: {
            'type: "function",
            'function: {
                name: TOOL_NAME
            }
        }
    };
}

function azureOpenAi4OToolCallAutoModeRequest(string prompt, string model, map<json> schema) 
        returns AzureOpenAICreateChatCompletionRequest|error {
    return {
        messages: [{role: "user", content: prompt}],
        tools: [
            {
                'type: "function",
                'function: {
                    name: TOOL_NAME,
                    parameters: schema
                }
            }
        ]
    };
}


function getResponseFormatType(string prompt, map<json> schema) returns ResponseFormatText|ResponseFormatJsonObject|ResponseFormatJsonSchema {
    return getSoConfigsForPropmt(prompt, schema);
}
