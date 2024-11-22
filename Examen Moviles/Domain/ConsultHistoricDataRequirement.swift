import Foundation

/// Protocol defining methods for accessing historical data requirements.
protocol HistoricDataRequirementProtocol {
    /// Fetches historical data.
    ///
    /// - Returns: A `HistoricDataList` containing an array of `HistoricalData`.
    /// - Throws: An error if the data fetch fails.
    func getHistoricData() async throws -> HistoricDataList
}

/// Concrete implementation of `HistoricDataRequirementProtocol` for managing historical data requirements.
class HistoricDataRequirement: HistoricDataRequirementProtocol {
    /// Singleton instance for shared use across the app.
    static let shared = HistoricDataRequirement()
    
    /// Repository for accessing historical data.
    let dataRepository: HistoricDataRepository
    
    /// Private initializer to ensure the singleton instance is used.
    ///
    /// - Parameter dataRepository: A `HistoricDataRepository` instance used to interact with the backend (default: shared instance).
    private init(dataRepository: HistoricDataRepository = HistoricDataRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    /// Retrieves historical data by calling the data repository.
    ///
    /// - Returns: A `HistoricDataList` containing an array of `HistoricalData`.
    /// - Throws: An error if the data retrieval fails.
    func getHistoricData() async throws -> HistoricDataList {
        return try await dataRepository.getHistoricData()
    }
}
