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
                // Error Message
                else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
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
        .task {
            await viewModel.getHistoricData()
        }
    }
}

// Art Topic View
struct ArtTopicView: View {
    let topic: ArtTopic
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(topic.title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "FFFFFF"))
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(hex: "FFC329"))
            }
            .padding(.vertical, 8)
            Text(topic.description)
                .font(.subheadline)
                .foregroundColor(Color(hex: "FFFFFF"))
        }
        .padding()
        .background(Color(hex: "0B2A22").opacity(0.6))
        .cornerRadius(10)
    }
}

// Art Topic Model
struct ArtTopic: Hashable {
    let title: String
    let description: String
}

// Sample Data for Topics
let artTopics = [
    ArtTopic(title: "World Masterpieces", description: "Learn about the world's greatest artists and the stories behind their paintings"),
    ArtTopic(title: "Expressionism", description: "Get a taste of one of the exciting styles of the 20th century and its artists"),
    ArtTopic(title: "Painting in Cinema", description: "Consider the participation of the greatest pictures in the greatest cinema"),
    ArtTopic(title: "20th Century Art", description: "Let's learn about the creators of the previous century and analyze their styles")
]

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
