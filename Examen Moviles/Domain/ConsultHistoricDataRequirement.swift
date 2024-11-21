import Foundation

protocol HistoricDataRequirementProtocol {
    func getHistoricData() async throws -> HistoricDataList
}

class HistoricDataRequirement: HistoricDataRequirementProtocol {
    static let shared = HistoricDataRequirement()
    
    let dataRepository: HistoricDataRepository
    
    private init(dataRepository: HistoricDataRepository = HistoricDataRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getHistoricData() async throws -> HistoricDataList {
        return try await dataRepository.getHistoricData()
    }
}
