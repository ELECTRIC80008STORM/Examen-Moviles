import Foundation

struct HistoricalResponse: Decodable {
    let result: HistoricalResult
}

struct HistoricalResult: Decodable {
    let code: Int
    let count: Int
    let page: Int
    let data: [HistoricalData]
    let error: String?
}

struct HistoricalData: Decodable {
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
    /// Maps the JSON keys to the property names in the `HistoricalData` struct.
    /// This is used when the JSON key names do not match the Swift property names.
        case date, description, lang, category1, category2, granularity, createdAt, updatedAt, objectId
        case type = "__type"
        case className
    }
}

struct HistoricDataList: Decodable {
    let data: [HistoricalData]
    
    init(data: [HistoricalData]) {
        self.data = data
    }
}
