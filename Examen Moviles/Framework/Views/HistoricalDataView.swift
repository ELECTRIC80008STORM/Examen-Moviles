import SwiftUI

struct HistoricalDataView: View {
    let data: HistoricalData

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Historical Fact")
                        .font(.headline)
                        .foregroundColor(Color(hex: "FFFFFF"))
                    Text("\(data.category1): \(data.category2)")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "FFC329"))
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(hex: "FFC329"))
            }
            .padding(.vertical, 8)
            
            Text(data.description)
                .font(.subheadline)
                .foregroundColor(Color(hex: "FFFFFF"))
        }
        .padding()
        .background(Color(hex: "0B2A22").opacity(0.6))
        .cornerRadius(10)
    }
}
