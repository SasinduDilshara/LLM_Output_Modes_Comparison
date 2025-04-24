import ballerina/http;
import ballerinax/openai.chat as openaiChat;
import ballerina/url;
import ballerina/io;

const resourcePath = "./resources";
const csvFolderName = "csvs";
const JSON_CONVERSION_ERROR = "FromJsonStringError";
const CONVERSION_ERROR = "ConversionError";
const ERROR_MESSAGE = "Error occurred while attempting to parse the response from the LLM as the expected type. Retrying and/or validating the prompt could fix the response.";

configurable string openapiApiKey = ?;
configurable string openapiApiServiceUrl = ?;
configurable string azureOpenapiApiKey = ?;
configurable string azureOpenapiApiServiceUrl = ?;
configurable string azureApiVersion = ?;

function getClient(string mode, string model) returns openaiChat:Client|http:Client|error {
    match model {
        OPENAI_4O_MODEL | OPENAI_4O_MINI_MODEL => {
            return new openaiChat:Client(
                serviceUrl = openapiApiServiceUrl,
                config = {
                    auth: {
                        token: openapiApiKey
                    }
                }
            );
        }

        AZURE_OPENAI_4O_MODEL | AZURE_OPENAI_4O_MINI_MODEL => {
            return new http:Client(
                url = azureOpenapiApiServiceUrl
            );
        }
    }
    return error("Unsupported model: " + model);
}


function getAzureDeployementId(string model) returns string|error {
    if (model == AZURE_OPENAI_4O_MINI_MODEL) {
        return "gpt-4o-stand";
    }
    
    if (model == AZURE_OPENAI_4O_MODEL) {
        return "gpt4o-mini-stand";
    }

    return error("Unsupported model: " + model);
}

function getCsvPath(string prompt, string model, string mode) returns string {
    return string `${resourcePath}/${csvFolderName}/prompt_${getPromptId(prompt)}_${model}_${mode}.csv`;
}

isolated function getEncodedUri(anydata value) returns string|error => url:encode(value.toString(), "UTF8");

function getJsonSchemaSoConfigs(map<json> schema) returns ResponseFormatJsonSchema {
    return {
      'type: "json_schema",
      json_schema: {
        name: SO_NAME,
        schema: schema
      }
    };  
}

function writeToCsvFile(string prompt, string model, string mode, anydata responseResult) returns error? {
    string csvPath = getCsvPath(prompt, model, mode);
    check io:fileWriteCsv(csvPath, [[responseResult.toString()]]);
}

function getToolCallingDescription(string prompt, map<json> schema) returns string {
    return string `If the expected schema of this tool is relevant/suitable to the expected output of the user prompt, this tool must be called.`;
}
