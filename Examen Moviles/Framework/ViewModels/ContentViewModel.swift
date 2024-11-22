import Foundation

class ContentViewModel: ObservableObject {
    @Published var historicData: HistoricDataList?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let historicDataRequirement: HistoricDataRequirementProtocol
    
    init(dataRequirement: HistoricDataRequirement = HistoricDataRequirement.shared) {
        self.historicDataRequirement = dataRequirement
    }
    
    @MainActor
    func getHistoricData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            historicData = try await historicDataRequirement.getHistoricData()
        } catch {
            errorMessage = "There was an error when fetching the historical data"
            ToastManager.shared.show(message: errorMessage!, type: .error)
        }
        
        isLoading = false
    }
}
