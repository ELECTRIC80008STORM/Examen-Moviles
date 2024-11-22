// Inspired by the interface design "Art Study Mobile IOS App" by Olga Vorontsova
// Link: https://dribbble.com/shots/21797382-Art-Study-Mobile-IOS-App

import SwiftUI

/// `ContentView` is the main view that displays the historical data fetched by `ContentViewModel`.
/// It includes a title section, a loading indicator, and a list of historical data.
struct ContentView: View {
    /// The view model that manages the state and data-fetching logic.
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color view for the main content.
                BackgroundView()

                VStack(alignment: .leading) {
                    // Title section displaying the main heading of the app.
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

                    // Loading indicator displayed while data is being fetched.
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding()
                            .foregroundColor(.white)
                    }
                    // List of historical data once the data has been fetched.
                    else if let historicDataList = viewModel.historicData?.data {
                        List(historicDataList) { data in
                            NavigationLink(destination: HistoricalDataContentView(data: data)) {
                                HistoricalDataView(data: data)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal, 24)
                    }

                    Spacer()
                }
            }
            // Adds a toast notification to the view.
            .toast()
            // Initiates the data fetching when the view appears.
            .task {
                await viewModel.getHistoricData()
            }
        }
    }
}

/// Extension for creating colors using hex codes.
extension Color {
    /// Initializes a `Color` from a hexadecimal color code string.
    /// - Parameter hex: A string representing the hexadecimal color code.
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
