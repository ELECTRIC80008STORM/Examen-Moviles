import SwiftUI

/// `HistoricalDataContentView` is a detailed view that displays the content of a specific historical data entry.
/// It shows the historical fact title, categories, date, and description.
struct HistoricalDataContentView: View {
    /// The historical data to be displayed in this view.
    let data: HistoricalData

    var body: some View {
        ZStack() {
            // Background color view for the main content.
            BackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Title for the historical fact section.
                    Text("Historical Fact")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding(.bottom, 8)
                    
                    // Categories of the historical data.
                    HStack(spacing: 8) {
                        Text(data.category1)
                            .font(.title3)
                            .foregroundColor(Color(hex: "FFC329"))
                        Text(data.category2)
                            .font(.title3)
                            .foregroundColor(Color(hex: "FFC329"))
                    }
                    
                    // Date of the historical event.
                    Text(data.date)
                        .font(.headline)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding(.bottom, 8)
                    
                    // Description of the historical event.
                    Text(data.description)
                        .font(.body)
                        .foregroundColor(Color(hex: "FFFFFF"))
                    
                    Spacer()
                }
                .padding()
                .background(Color(hex: "0B2A22").opacity(0.8))
                .cornerRadius(10)
                .padding()
            }
        }
    }
}
