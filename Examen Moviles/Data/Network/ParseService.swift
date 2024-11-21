import Foundation
import ParseCore

class ParseService {
    static let shared = ParseService()
    
    /// Private initializer to restrict instantiation to the `shared` instance only
    private init() {}
    
    func callCloudFunction<T>(
            functionName: String,
            params: [String: Any]
        ) async throws -> T {
            return try await withCheckedThrowingContinuation { continuation in
                PFCloud.callFunction(inBackground: functionName, withParameters: params) { (result, error) in
                    if let error = error {
                        // If an error occurs, resume with the error.
                        continuation.resume(throwing: error)
                    } else if let result = result as? T {
                        // If the result is of the expected type, resume with the result.
                        continuation.resume(returning: result)
                    } else {
                        // If the result type is unexpected, throw an error.
                        let parseError = NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected type of result"])
                        continuation.resume(throwing: parseError)
                    }
                }
            }
        }
    
    func getHistoricData() async throws -> HistoricDataList {
        let params: [String: Any] = [:]
        
        do {
            // Call the cloud function named "hello" with no parameters.
            let response: Any = try await callCloudFunction(functionName: "hello", params: params)

            // Attempt to serialize the response into JSON data.
            guard let jsonData = try? JSONSerialization.data(withJSONObject: response) else {
                // Throw an error if serialization fails.
                throw NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize response"])
            }
            
            // Attempt to decode the JSON data into `HistoricalResponse`.
            let decodedResponse = try JSONDecoder().decode(HistoricalResponse.self, from: jsonData)
            let historicDataList = HistoricDataList(data: decodedResponse.result.data)
            return historicDataList
        } catch let error {
            print("Error when trying to connect to the server or handling the data: \(error.localizedDescription)")
            throw error
        }
    }

}
