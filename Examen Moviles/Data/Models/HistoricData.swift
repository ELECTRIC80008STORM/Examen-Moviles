import Foundation

/// Represents historical data with various properties such as date, description, categories, and metadata.
/// Conforms to `Identifiable` to provide a unique identifier.
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
    
    /// Coding keys to map properties to JSON keys when decoding/encoding.
    enum CodingKeys: String, CodingKey {
        case date, description, lang, category1, category2, granularity, createdAt, updatedAt, objectId
        case type = "__type"
        case className
    }
}

/// A wrapper struct that holds a list of `HistoricalData`.
struct HistoricDataList {
    let data: [HistoricalData]
    
    /// Initializes `HistoricDataList` with an array of historical data.
    /// - Parameter data: An array of `HistoricalData` objects.
    init(data: [HistoricalData]) {
        self.data = data
    }
}
