// Inspired by the interface design "Art Study Mobile IOS App" by Olga Vorontsova
// Link: https://dribbble.com/shots/21797382-Art-Study-Mobile-IOS-App

// Importing the necessary SwiftUI framework
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        ZStack {
            // Background Color
            LinearGradient(gradient: Gradient(colors: [Color(hex: "0B2A22"), Color(hex: "154734"), Color(hex: "333333")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                // Title Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Learn The World")
                        .font(.custom("Times New Roman", size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "FFFFFF"))
                    Text("Before You")
                        .font(.custom("Times New Roman", size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "FFC329"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)

                Spacer().frame(height: 40)

                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .foregroundColor(.white)
                }
                // List of Historical Data
                else if let historicDataList = viewModel.historicData?.data {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(historicDataList) { data in
                                HistoricalDataView(data: data)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .toast()
        .task {
            await viewModel.getHistoricData()
        }
    }
}

// Extension for Hex Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255
        let g = Double((rgbValue & 0xff00) >> 8) / 255
        let b = Double(rgbValue & 0xff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
