import Foundation

public class AiManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Sends an AI request to supported LLMs and returns an answer specifically focused on the user's question given the provided context.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createAiAsk method
    ///   - headers: Headers of createAiAsk method
    /// - Returns: The `AiResponseFull?`.
    /// - Throws: The `GeneralError`.
    public func createAiAsk(requestBody: AiAsk, headers: CreateAiAskHeaders = CreateAiAskHeaders()) async throws -> AiResponseFull? {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai/ask")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        if Utils.Strings.toString(value: response.status) == "204" {
            return nil
        }

        return try AiResponseFull?.deserialize(from: response.data!)
    }

    /// Sends an AI request to supported Large Language Models (LLMs) and returns generated text based on the provided prompt.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createAiTextGen method
    ///   - headers: Headers of createAiTextGen method
    /// - Returns: The `AiResponse`.
    /// - Throws: The `GeneralError`.
    public func createAiTextGen(requestBody: AiTextGen, headers: CreateAiTextGenHeaders = CreateAiTextGenHeaders()) async throws -> AiResponse {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai/text_gen")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiResponse.deserialize(from: response.data!)
    }

    /// Get the AI agent default config
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getAiAgentDefaultConfig method
    ///   - headers: Headers of getAiAgentDefaultConfig method
    /// - Returns: The `AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen`.
    /// - Throws: The `GeneralError`.
    public func getAiAgentDefaultConfig(queryParams: GetAiAgentDefaultConfigQueryParams, headers: GetAiAgentDefaultConfigHeaders = GetAiAgentDefaultConfigHeaders()) async throws -> AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["mode": Utils.Strings.toString(value: queryParams.mode), "language": Utils.Strings.toString(value: queryParams.language), "model": Utils.Strings.toString(value: queryParams.model)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_agent_default")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen.deserialize(from: response.data!)
    }

    /// Sends an AI request to supported Large Language Models (LLMs) and extracts metadata in form of key-value pairs.
    /// In this request, both the prompt and the output can be freeform.
    /// Metadata template setup before sending the request is not required.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createAiExtract method
    ///   - headers: Headers of createAiExtract method
    /// - Returns: The `AiResponse`.
    /// - Throws: The `GeneralError`.
    public func createAiExtract(requestBody: AiExtract, headers: CreateAiExtractHeaders = CreateAiExtractHeaders()) async throws -> AiResponse {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai/extract")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiResponse.deserialize(from: response.data!)
    }

    /// Sends an AI request to supported Large Language Models (LLMs) and returns extracted metadata as a set of key-value pairs.
    /// For this request, you either need a metadata template or a list of fields you want to extract.
    /// Input is **either** a metadata template or a list of fields to ensure the structure.
    /// To learn more about creating templates, see [Creating metadata templates in the Admin Console](https://support.box.com/hc/en-us/articles/360044194033-Customizing-Metadata-Templates)
    /// or use the [metadata template API](g://metadata/templates/create).
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createAiExtractStructured method
    ///   - headers: Headers of createAiExtractStructured method
    /// - Returns: The `AiExtractStructuredResponse`.
    /// - Throws: The `GeneralError`.
    public func createAiExtractStructured(requestBody: AiExtractStructured, headers: CreateAiExtractStructuredHeaders = CreateAiExtractStructuredHeaders()) async throws -> AiExtractStructuredResponse {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai/extract_structured")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiExtractStructuredResponse.deserialize(from: response.data!)
    }

}
