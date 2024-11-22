import SwiftUI

struct HistoricalDataContentView: View {
    let data: HistoricalData

    var body: some View {
        ZStack() {
            BackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Historical Fact")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding(.bottom, 8)
                    
                    HStack(spacing: 8) {
                        Text(data.category1)
                            .font(.title3)
                            .foregroundColor(Color(hex: "FFC329"))
                        Text(data.category2)
                            .font(.title3)
                            .foregroundColor(Color(hex: "FFC329"))
                    }
                    
                    Text(data.date)
                        .font(.headline)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding(.bottom, 8)
                    
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
