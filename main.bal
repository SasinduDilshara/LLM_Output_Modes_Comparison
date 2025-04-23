import ballerina/http;
import ballerinax/openai.chat;
import ballerina/io;

boolean verbose = true;

function process() returns error? {
    foreach string model in MODELS {
        foreach string prompt in PROMPTS {
            foreach string mode in MODES {
                int iter = 0;
                while iter < ITERATIONS {
                    do {
                        check processPrompt(prompt, mode, model);
                    } on fail error e {
                        string errMessage = e.message();
                        if errMessage.includes(ERROR_MESSAGE) {
                            if DEBUG_MODE || verbose {
                                io:println(string `Error occurred in processing PROMPT_${getPromptId(prompt)}_${model}_${mode}: 
                                        ${errMessage}. Retrying...`, e);
                            }
                            continue;
                        }

                        if errMessage.includes("Idle timeout triggered") ||
                                errMessage.includes("Remote host closed the connection") {
                            if DEBUG_MODE || verbose {
                                io:println(string `Idle timeout triggered`, e);
                            }
                            continue;
                        }
                        return error(string `Error occured in processing PROMPT_${getPromptId(prompt)}_${model}_${mode}: 
                                ${errMessage}`, e);
                    }
                    iter += 1;
                }
            }
        }
    }
}

function processPrompt(string prompt, string mode, string model) returns error? {
    anydata responseResult = null;
    chat:Client|http:Client cl = check getClient(mode, model);
    map<json> expectedSchema = getExpectedSchema(prompt, mode);
    typedesc<anydata> expectedType = getExpectedType(prompt);

    chat:CreateChatCompletionRequest|AzureOpenAICreateChatCompletionRequest request = 
        check getRequest(prompt, mode, model, expectedSchema);

    if cl is http:Client {
        string resourcePath = string `/deployments/${check getEncodedUri(check getAzureDeployementId(model))}/chat/completions`;
        resourcePath = string `${resourcePath}?${check getEncodedUri("api-version")}=${azureApiVersion}`;

        AzureOpenAICreateChatCompletionResponse response = check cl->post(resourcePath, request, {
            "api-key": azureOpenapiApiKey
        });

        responseResult = check getResponse(response, prompt, mode, expectedSchema, expectedType);
    } else if cl is chat:Client {
        OpenAICreateChatCompletionResponse response = 
            check cl->/chat/completions.post(<chat:CreateChatCompletionRequest>request);
        responseResult = check getResponse(response, prompt, mode, expectedSchema, expectedType);
    }
    
    string csvPath = getCsvPath(prompt, model, mode);
    check io:fileWriteCsv(csvPath, [[responseResult.toString()]]);
}


public function main() {
    error? result = process();
    if (result is error) {
        io:println("Error occurred: ", result);
    } else {
        io:println("All prompts processed successfully.");
    }
}
