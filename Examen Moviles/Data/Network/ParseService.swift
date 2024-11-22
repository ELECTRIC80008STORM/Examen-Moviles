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
            
            // Attempt to convert response to array of PFObjects if possible
            guard let responseDict = response as? [String: Any],
                  let dataArray = responseDict["data"] as? [PFObject] else {
                throw NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])
            }
            
            // Manually deserialize PFObjects to create HistoricalData objects
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
            
            // Create HistoricDataList from the array of HistoricalData objects
            return HistoricDataList(data: historicalDataArray)
        } catch {
            throw error
        }
    }




}
