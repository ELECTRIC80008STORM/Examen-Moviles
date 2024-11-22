import Foundation
import ParseCore

/// Service for handling operations related to the Parse backend.
class ParseService {
    /// Singleton instance for shared use across the app.
    static let shared = ParseService()
    
    /// Private initializer to restrict instantiation to the `shared` instance only.
    private init() {}
    
    /// Calls a Parse cloud function and returns a generic type `T`.
    ///
    /// - Parameters:
    ///   - functionName: The name of the cloud function to call.
    ///   - params: A dictionary of parameters to send to the cloud function.
    /// - Returns: The result of the cloud function call, cast to type `T`.
    /// - Throws: An error if the cloud function call fails or the result type is unexpected.
    func callCloudFunction<T>(
        functionName: String,
        params: [String: Any]
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            PFCloud.callFunction(inBackground: functionName, withParameters: params) { (result, error) in
                if let error = error {
                    // Resume with the error if the cloud function call fails.
                    continuation.resume(throwing: error)
                } else if let result = result as? T {
                    // Resume with the result if it is of the expected type.
                    continuation.resume(returning: result)
                } else {
                    // Resume with an error if the result type is unexpected.
                    let parseError = NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected type of result"])
                    continuation.resume(throwing: parseError)
                }
            }
        }
    }
    
    /// Retrieves historical data by calling a cloud function.
    ///
    /// - Returns: A `HistoricDataList` containing an array of `HistoricalData`.
    /// - Throws: An error if the data retrieval fails or if the response format is unexpected.
    func getHistoricData() async throws -> HistoricDataList {
        let params: [String: Any] = [:]
        
        do {
            // Call the cloud function named "hello" with no parameters.
            let response: Any = try await callCloudFunction(functionName: "hello", params: params)
            
            // Attempt to convert response to an array of PFObjects.
            guard let responseDict = response as? [String: Any],
                  let dataArray = responseDict["data"] as? [PFObject] else {
                throw NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])
            }
            
            // Manually deserialize PFObjects to create `HistoricalData` objects.
            let historicalDataArray: [HistoricalData] = dataArray.compactMap { pfObject in
                HistoricalData(
                    date: pfObject["date"] as? String ?? "",
                    description: pfObject["description"] as? String ?? "",
                    lang: pfObject["lang"] as? String ?? "",
                    category1: pfObject["category1"] as? String ?? "",
                    category2: pfObject["category2"] as? String ?? "",
                    granularity: pfObject["granularity"] as? String ?? "",
                    createdAt: pfObject["createdAt"] as? String ?? "",
                    updatedAt: pfObject["updatedAt"] as? String ?? "",
                    objectId: pfObject["objectId"] as? String ?? "",
                    type: pfObject["__type"] as? String ?? "",
                    className: pfObject["className"] as? String ?? ""
                )
            }
            
            // Create `HistoricDataList` from the array of `HistoricalData` objects.
            return HistoricDataList(data: historicalDataArray)
        } catch {
            // Propagate any errors that occurred during the cloud function call.
            throw error
        }
    }
}
