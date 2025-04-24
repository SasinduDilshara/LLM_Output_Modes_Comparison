import ballerina/http;
import ballerinax/openai.chat;
import ballerina/io;
import ballerina/time;

type CsvRecord record{|
    int prompt_id;
    string mode;
    string model;
    decimal average_time;
    int error_rate;
    decimal[] times = [];
|};

boolean verbose = true;

function process() returns error? {
    anydata res;
    CsvRecord[] recs = [];
    foreach string model in MODELS {
        foreach string prompt in PROMPTS {
            foreach string mode in MODES {
                int errorCount = 0;
                decimal[] timeDiffs = [];
                decimal totalDiff = 0;
                int iter = 0;

                while iter < ITERATIONS {
                    if DEBUG_MODE || verbose {
                        io:println(string `Processing PROMPT_${getPromptId(prompt)}_${model}_${mode}...`, iter);
                    }

                    do {
                        [anydata, decimal] timeConsumed = check processPrompt(prompt, mode, model);
                        res = timeConsumed[0];
                        if res == INVALID_RESPONSE || res == () || res == "" {
                            errorCount += 1;
                            iter += 1;
                            if DEBUG_MODE || verbose {
                                io:println(string `Invalid response for PROMPT_${getPromptId(prompt)}_${model}_${mode}. Retrying...`);
                            }

                            continue;
                        }
                        decimal timeDiff = timeConsumed[1];
                        timeDiffs.push(timeDiff);
                        totalDiff += timeDiff;
                        iter += 1;

                        check io:fileWriteCsv(
                            string `${resourcePath}/${csvFolderName}/values/PROMPT_${getPromptId(prompt)}_${model}_${mode}_responses.csv`,
                            [[iter.toString(), res.toString()]],
                            io:APPEND
                        );
                    } on fail error e {
                        string errMessage = e.message();
                        if errMessage.includes(ERROR_MESSAGE) {
                            errorCount += 1;
                            iter += 1;

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

                        io:println(string `Error occured in processing PROMPT_${getPromptId(prompt)}_${model}_${mode}: 
                                ${errMessage}`, e);
                        continue;
                    }
                }

                CsvRecord csvValue = {
                    prompt_id: getPromptId(prompt),
                    mode: mode,
                    model: model,
                    average_time: totalDiff / ITERATIONS,
                    error_rate: errorCount,
                    times: timeDiffs
                };

                recs.push(csvValue);

                check io:fileWriteCsv(
                    string `${resourcePath}/${csvFolderName}/summary_backup.csv`,
                    [csvValue],
                    io:APPEND
                );

                if DEBUG_MODE || verbose {
                    io:println(csvValue);
                }
            }
        }
    }

    check io:fileWriteCsv(
        string `${resourcePath}/${csvFolderName}/summary.csv`,
        recs,
        io:OVERWRITE
    );
}

function processPrompt(string prompt, string mode, string model) returns [anydata, decimal]|error {
    decimal timeDiff = 0;
    decimal st;
    anydata responseResult = ();
    chat:Client|http:Client cl = check getClient(mode, model);
    map<json> expectedSchema = getExpectedSchema(prompt, mode);
    typedesc<anydata> expectedType = getExpectedType(prompt);

    chat:CreateChatCompletionRequest|AzureOpenAICreateChatCompletionRequest request = 
        check getRequest(prompt, mode, model, expectedSchema);

    if cl is http:Client {
        string resourcePath = string `/deployments/${check getEncodedUri(check getAzureDeployementId(model))}/chat/completions`;
        resourcePath = string `${resourcePath}?${check getEncodedUri("api-version")}=${azureApiVersion}`;
        
        st = time:monotonicNow();
        AzureOpenAICreateChatCompletionResponse response = check cl->post(resourcePath, request, {
            "api-key": azureOpenapiApiKey
        });
        timeDiff = time:monotonicNow() - st;

        responseResult = check getResponse(response, prompt, mode, expectedSchema, expectedType);
    } else if cl is chat:Client {
        
        st = time:monotonicNow();
        OpenAICreateChatCompletionResponse response = 
            check cl->/chat/completions.post(<chat:CreateChatCompletionRequest>request);
        timeDiff = time:monotonicNow() - st;

        responseResult = check getResponse(response, prompt, mode, expectedSchema, expectedType);
    }

    return [responseResult, timeDiff];
}


public function main() {
    error? result = process();
    if (result is error) {
        io:println("Error occurred: ", result);
    } else {
        io:println("All prompts processed successfully.");
    }
}
