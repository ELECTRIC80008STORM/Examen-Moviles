import Foundation

/// `ContentViewModel` is a view model that manages the state and data-fetching logic for historical data.
/// It handles loading states, retry attempts, error handling, and data filtering for fetching data.
class ContentViewModel: ObservableObject {
    /// Historical data fetched from the backend.
    @Published var historicData: HistoricDataList?
    
    /// Filtered historical data after applying filter criteria.
    @Published var filteredData: HistoricDataList?
    
    /// Indicates if the data fetching process is ongoing.
    @Published var isLoading = false
    
    /// Stores error messages to display when data fetching fails.
    @Published var errorMessage: String?
    
    /// Dependency to handle historical data requirements.
    let historicDataRequirement: HistoricDataRequirementProtocol
    
    /// Maximum number of retry attempts allowed for data fetching.
    let maxRetryAttempts = 5
    
    /// Initializes a new `ContentViewModel` with a specified `HistoricDataRequirement`.
    /// - Parameter dataRequirement: The requirement used to fetch historical data (default: shared instance).
    init(dataRequirement: HistoricDataRequirement = HistoricDataRequirement.shared) {
        self.historicDataRequirement = dataRequirement
    }
    
    /// Asynchronously fetches historical data with retry logic.
    /// Displays error messages and retries fetching if necessary.
    @MainActor
    func getHistoricData() async {
        isLoading = true
        errorMessage = nil
        
        var attempt = 0
        var success = false

        while attempt < maxRetryAttempts && !success {
            do {
                // Attempt to fetch historical data.
                historicData = try await historicDataRequirement.getHistoricData()
                filteredData = historicData // Initially, filtered data is the same as all data.
                success = true
            } catch {
                attempt += 1
                errorMessage = "There was an error when fetching the historical data. Retrying (\(attempt)/\(maxRetryAttempts))..."
                ToastManager.shared.show(message: errorMessage!, type: .error)

                if attempt >= maxRetryAttempts {
                    // Show error message if all retry attempts fail.
                    errorMessage = "Failed to fetch historical data after \(maxRetryAttempts) attempts."
                    ToastManager.shared.show(message: errorMessage!, type: .error)
                } else {
                    // Wait for 2 seconds before retrying.
                    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                }
            }
        }
        
        isLoading = false
    }
    
    /// Filters historical data based on a given category and criteria.
    /// - Parameters:
    ///   - category: The category to filter by (e.g., "By place" or "By topic").
    func filterData(category: String) {
        guard let historicData = historicData else {
            filteredData = nil
            return
        }
        
        filteredData = HistoricDataList(data: historicData.data.filter { data in
            switch category {
            case "By place":
                return data.category1 == "By place"
            case "By topic":
                return data.category1 == "By topic"
            default:
                return false
            }
        })
    }
}
