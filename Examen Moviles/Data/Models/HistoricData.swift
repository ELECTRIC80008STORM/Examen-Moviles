import Foundation

struct HistoricalData: Identifiable {
    let id = UUID()
    let date: String
    let description: String
    let lang: String
    let category1: String
    let category2: String
    let granularity: String
    let createdAt: String
    let updatedAt: String
    let objectId: String
    let type: String
    let className: String
    
    enum CodingKeys: String, CodingKey {
        case date, description, lang, category1, category2, granularity, createdAt, updatedAt, objectId
        case type = "__type"
        case className
    }
}

struct HistoricDataList {
    let data: [HistoricalData]
    
    init(data: [HistoricalData]) {
        self.data = data
    }
}
