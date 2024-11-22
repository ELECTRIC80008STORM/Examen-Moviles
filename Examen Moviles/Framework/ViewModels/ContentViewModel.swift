import Foundation

/// `ContentViewModel` is a view model that manages the state and data-fetching logic for historical data.
/// It handles loading states, retry attempts, and error handling for fetching data.
class ContentViewModel: ObservableObject {
    /// Historical data fetched from the backend.
    @Published var historicData: HistoricDataList?
    
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
}
