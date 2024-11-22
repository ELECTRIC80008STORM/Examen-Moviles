import SwiftUI

/// `HistoricalDataView` is a summary view that provides a brief overview of a historical data entry.
/// It displays the title, categories, and a short description of the historical data.
struct HistoricalDataView: View {
    /// The historical data to be displayed in this summary view.
    let data: HistoricalData

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    // Title for the historical fact.
                    Text("Historical Fact")
                        .font(.headline)
                        .foregroundColor(Color(hex: "FFFFFF"))
                    
                    // Categories of the historical data, formatted as "Category1: Category2".
                    Text("\(data.category1): \(data.category2)")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "FFC329"))
                }
                Spacer()
                
                // Icon indicating a link to more details.
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(hex: "FFC329"))
            }
            .padding(.vertical, 8)
            
            // Short description of the historical data.
            Text(data.description)
                .font(.subheadline)
                .foregroundColor(Color(hex: "FFFFFF"))
        }
        .padding()
        .background(Color(hex: "0B2A22").opacity(0.6))
        .cornerRadius(10)
    }
}
