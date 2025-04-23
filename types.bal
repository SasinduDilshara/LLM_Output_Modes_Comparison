import ballerina/http;

# Provides settings related to HTTP/1.x protocol.
type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Proxy server configurations to be used with the HTTP client endpoint.
type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# Connection configuration for OpenAI.
type OpenAIConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

type ApiKeysConfig record {|
    # The API key to use. This is the same as your subscription key.
    @display {label: "", kind: "password"}
    string apiKey;
|};

type OpenAIChatCompletionRequestUserMessage record {
    string content;
    "user" role;
    string name?;
};

// type OpenAICreateChatCompletionRequest record {
//     OpenAIChatCompletionRequestUserMessage[] messages;
//     string model;
//     boolean? store = false;
//     decimal? frequency_penalty = 0;
//     boolean? logprobs = false;
//     int? n = 1;
//     decimal? presence_penalty = 0;
//     "auto"|"default"? service_tier = "auto";
//     boolean? 'stream = false;
//     decimal? temperature = 1;
//     decimal? top_p = 1;
//     ResponseFormatText|ResponseFormatJsonObject|ResponseFormatJsonSchema response_format?;
//     # A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for.
//     AzureChatCompletionTool[] tools?;
//     # Controls which (if any) function is called by the model. `none` means the model will not call a function and instead generates a message. `auto` means the model can pick between generating a message or calling a function. Specifying a particular function via `{"type": "function", "function": {"name": "my_function"}}` forces the model to call that function.
//     AzureChatCompletionToolChoiceOption tool_choice?;
// };

type OpenAIChatCompletionResponseMessage record {
    string? content;
    ChatCompletionMessageToolCall[] tool_calls?;
};

type OpenAICreateChatCompletionResponse_choices record {
    OpenAIChatCompletionResponseMessage message;
};

type OpenAICreateChatCompletionResponse record {
    OpenAICreateChatCompletionResponse_choices[] choices;
};

# Connection configuration for Azure OpenAI.
type AzureOpenAIConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|ApiKeysConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

type AzureOpenAIChatCompletionRequestMessageRole "system"|"user"|"assistant"|"tool"|"function";

type AzureOpenAIChatCompletionRequestMessage record {|
    AzureOpenAIChatCompletionRequestMessageRole role;
    string content;
|};

public type AzureChatCompletionTool record {
    # The type of the tool. Currently, only `function` is supported.
    AzureChatCompletionToolType 'type;
    AzureChatCompletionTool_function 'function;
};

public type AzureChatCompletionTool_function record {
    # A description of what the function does, used by the model to choose when and how to call the function.
    string description?;
    # The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
    string name;
    # The parameters the functions accepts, described as a JSON Schema object. See the [guide](/docs/guides/gpt/function-calling) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema/) for documentation about the format.
    AzureChatCompletionFunctionParameters parameters;
};

# The parameters the functions accepts, described as a JSON Schema object. See the [guide](/docs/guides/gpt/function-calling) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema/) for documentation about the format.
public type AzureChatCompletionFunctionParameters record {
};

# The type of the tool. Currently, only `function` is supported.
public type AzureChatCompletionToolType "function";

# Specifies a tool the model should use. Use to force the model to call a specific function.
public type AzureChatCompletionNamedToolChoice record {
    # The type of the tool. Currently, only `function` is supported.
    "function" 'type?;
    # The function that should be called.
    AzureChatCompletionNamedToolChoice_function 'function?;
};

# The function that should be called.
public type AzureChatCompletionNamedToolChoice_function record {
    # The name of the function to call.
    string name;
};

# Controls which (if any) function is called by the model. `none` means the model will not call a function and instead generates a message. `auto` means the model can pick between generating a message or calling a function. Specifying a particular function via `{"type": "function", "function": {"name": "my_function"}}` forces the model to call that function.
public type AzureChatCompletionToolChoiceOption "none"|"auto"|AzureChatCompletionNamedToolChoice;

type AzureOpenAICreateChatCompletionRequest record {|
    AzureOpenAIChatCompletionRequestMessage[1] messages;
    # An object specifying the format that the model must output. Used to enable JSON mode.
    # An object specifying the format that the model must output. Compatible with [GPT-4o](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4-and-gpt-4-turbo-models), [GPT-4o mini](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4-and-gpt-4-turbo-models), [GPT-4 Turbo](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4-and-gpt-4-turbo-models) and all [GPT-3.5](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-35) Turbo models newer than `gpt-3.5-turbo-1106`.
    # 
    # Setting to `{ "type": "json_schema", "json_schema": {...} }` enables Structured Outputs which guarantees the model will match your supplied JSON schema.
    # 
    # Setting to `{ "type": "json_object" }` enables JSON mode, which guarantees the message the model generates is valid JSON.
    # 
    # **Important:** when using JSON mode, you **must** also instruct the model to produce JSON yourself via a system or user message. Without this, the model may generate an unending stream of whitespace until the generation reaches the token limit, resulting in a long-running and seemingly "stuck" request. Also note that the message content may be partially cut off if `finish_reason="length"`, which indicates the generation exceeded `max_tokens` or the conversation exceeded the max context length.
    ResponseFormatText|ResponseFormatJsonObject|ResponseFormatJsonSchema response_format?;
    # A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for.
    AzureChatCompletionTool[] tools?;
    # Controls which (if any) function is called by the model. `none` means the model will not call a function and instead generates a message. `auto` means the model can pick between generating a message or calling a function. Specifying a particular function via `{"type": "function", "function": {"name": "my_function"}}` forces the model to call that function.
    AzureChatCompletionToolChoiceOption tool_choice?;
|};

public type ResponseFormatJsonSchema record {
    # The type of response format being defined: `json_schema`
    "json_schema" 'type;
    ResponseFormatJsonSchema_json_schema json_schema;
};

public type ResponseFormatJsonSchema_json_schema record {
    # A description of what the response format is for, used by the model to determine how to respond in the format.
    string description?;
    # The name of the response format. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
    string name;
    ResponseFormatJsonSchemaSchema schema?;
    # Whether to enable strict schema adherence when generating the output. If set to true, the model will always follow the exact schema defined in the `schema` field. Only a subset of JSON Schema is supported when `strict` is `true`.
    boolean? strict = false;
};

# The schema for the response format, described as a JSON Schema object.
public type ResponseFormatJsonSchemaSchema record {
};

public type ResponseFormatText record {
    # The type of response format being defined: `text`
    "text" 'type;
};

public type ResponseFormatJsonObject record {
    # The type of response format being defined: `json_object`
    "json_object" 'type;
};

type AzureOpenAIChatCompletionResponseMessage record {
    string? content?;
    ChatCompletionMessageToolCall[] tool_calls?;
};

type AzureOpenAICreateChatCompletionResponse record {
    record {
        AzureOpenAIChatCompletionResponseMessage message?;
    }[] choices?;
};

isolated function buildHttpClientConfig(AzureOpenAIConnectionConfig config) returns http:ClientConfiguration {
    http:ClientConfiguration httpClientConfig = {
        httpVersion: config.httpVersion,
        timeout: config.timeout,
        forwarded: config.forwarded,
        poolConfig: config.poolConfig,
        compression: config.compression,
        circuitBreaker: config.circuitBreaker,
        retryConfig: config.retryConfig,
        validation: config.validation
    };

    ClientHttp1Settings? http1Settings = config.http1Settings;
    if http1Settings is ClientHttp1Settings {
        httpClientConfig.http1Settings = {...http1Settings};
    }
    http:ClientHttp2Settings? http2Settings = config.http2Settings;
    if http2Settings is http:ClientHttp2Settings {
        httpClientConfig.http2Settings = {...http2Settings};
    }
    http:CacheConfig? cache = config.cache;
    if cache is http:CacheConfig {
        httpClientConfig.cache = cache;
    }
    http:ResponseLimitConfigs? responseLimits = config.responseLimits;
    if responseLimits is http:ResponseLimitConfigs {
        httpClientConfig.responseLimits = responseLimits;
    }
    http:ClientSecureSocket? secureSocket = config.secureSocket;
    if secureSocket is http:ClientSecureSocket {
        httpClientConfig.secureSocket = secureSocket;
    }
    http:ProxyConfig? proxy = config.proxy;
    if proxy is http:ProxyConfig {
        httpClientConfig.proxy = proxy;
    }
    return httpClientConfig;
}

public type ChatCompletionMessageToolCall record {
    # The ID of the tool call.
    string id;
    # The type of the tool call, in this case `function`.
    ToolCallType 'type;
    # The function that the model called.
    ChatCompletionMessageToolCall_function 'function;
};

# The type of the tool call, in this case `function`.
public type ToolCallType "function";

# The function that the model called.
public type ChatCompletionMessageToolCall_function record {
    # The name of the function to call.
    string name;
    # The arguments to call the function with, as generated by the model in JSON format. Note that the model does not always generate valid JSON, and may hallucinate parameters not defined by your function schema. Validate the arguments in your code before calling your function.
    string arguments;
};
