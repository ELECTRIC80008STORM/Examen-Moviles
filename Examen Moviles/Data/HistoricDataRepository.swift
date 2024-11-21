import Foundation

protocol HistoricDataRepositoryProtocol {
    func getHistoricData() async throws -> HistoricDataList
}

class HistoricDataRepository: HistoricDataRepositoryProtocol {
    static let shared = HistoricDataRepository()
    
    let nservice: ParseService
    
    private init(nservice: ParseService = ParseService.shared) {
        self.nservice = nservice
    }
    
    func getHistoricData() async throws -> HistoricDataList {
        return try await nservice.getHistoricData()
    }
}
