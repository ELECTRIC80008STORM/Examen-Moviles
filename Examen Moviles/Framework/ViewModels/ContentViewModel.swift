import Foundation

class ContentViewModel: ObservableObject {
    @Published var historicData: HistoricDataList?
    @Published var isLoading = false
    @Published var errorMessage: String?

    let historicDataRequirement: HistoricDataRequirementProtocol
    let maxRetryAttempts = 5

    init(dataRequirement: HistoricDataRequirement = HistoricDataRequirement.shared) {
        self.historicDataRequirement = dataRequirement
    }

    @MainActor
    func getHistoricData() async {
        isLoading = true
        errorMessage = nil
        
        var attempt = 0
        var success = false

        while attempt < maxRetryAttempts && !success {
            do {
                historicData = try await historicDataRequirement.getHistoricData()
                success = true
            } catch {
                attempt += 1
                errorMessage = "There was an error when fetching the historical data. Retrying (\(attempt)/\(maxRetryAttempts))..."
                ToastManager.shared.show(message: errorMessage!, type: .error)

                if attempt >= maxRetryAttempts {
                    errorMessage = "Failed to fetch historical data after \(maxRetryAttempts) attempts."
                    ToastManager.shared.show(message: errorMessage!, type: .error)
                } else {
                    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                }
            }
        }
        
        isLoading = false
    }
}
