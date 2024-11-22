import Foundation

/// Protocol defining methods for accessing historical data.
protocol HistoricDataRepositoryProtocol {
    /// Fetches historical data from the backend system.
    ///
    /// - Returns: A `HistoricDataList` containing an array of `HistoricalData`.
    /// - Throws: An error if the data fetch fails.
    func getHistoricData() async throws -> HistoricDataList
}

/// Concrete implementation of `HistoricDataRepositoryProtocol` for managing historical data.
class HistoricDataRepository: HistoricDataRepositoryProtocol {
    /// Singleton instance for shared use across the app.
    static let shared = HistoricDataRepository()
    
    /// Service for handling backend operations related to historical data.
    let nservice: ParseService
    
    /// Private initializer to ensure the singleton instance is used.
    ///
    /// - Parameter nservice: A `ParseService` instance used to interact with the backend (default: shared instance).
    private init(nservice: ParseService = ParseService.shared) {
        self.nservice = nservice
    }
    
    /// Retrieves historical data by calling the Parse service.
    ///
    /// - Returns: A `HistoricDataList` containing an array of `HistoricalData`.
    /// - Throws: An error if the data retrieval fails.
    func getHistoricData() async throws -> HistoricDataList {
        return try await nservice.getHistoricData()
    }
}
