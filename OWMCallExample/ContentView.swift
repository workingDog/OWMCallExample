//
//  ContentView.swift
//  OWMCallExample
//
//  Created by Ringo Wathelet on 2022/10/01.
//


import SwiftUI
import OWMCall


struct ContentView: View {
    
    let weatherProvider = OWMProvider(apiKey: "your key") // <-- here use your key
    let lang = "en"         // "ja"
    let frmt = "yyyy-MM-dd" // "yyyy年MM月dd日"
    
    @State var weather = OWMResponse()
    
    var body: some View {
        VStack (spacing: 40) {
            Spacer()
            Text(weather.name)
            Text(formattedDate(utc: weather.dt))
            Text(String(format: "%.1f", weather.main?.temp ?? 0.0) + "°").font(.title)
            Text(weather.weatherInfo())
            
            if let img = weather.weather?.first?.iconSymbolName {
                Image(systemName: img.isEmpty ? "smiley" : img)
                    .resizable()
                    .frame(width: 70, height: 65)
                    .foregroundColor(Color.green)
            }
            Spacer()
        }
        .onAppear {
            loadData()
        }
        //        .task {
        //            if let results = await weatherProvider.getWeather(lat: 35.661991, lon: 139.762735, options: OWOptions(excludeMode: [], units: .metric, lang: "en")) {
        //                weather = results
        //            }
        //        }
    }
    
    func loadData() {
        // lat: -33.861536, lon: 151.215206,    // Sydney
        // lat: 35.661991, lon: 139.762735,     // Tokyo
        
        let myOptions = OWMOptions(units: .metric, lang: "en")
        
        // using a binding
        weatherProvider.getWeather(lat: 35.661991, lon: 139.762735, weather: $weather, options: myOptions)
        
        // closure style callback
        //        weatherProvider.getWeather(lat: 35.661991, lon: 139.762735, options: myOptions) { response in
        //            if let theWeather = response {
        //                self.weather = theWeather
        //            }
        //        }
        
        // for historical data in the past
        //         weatherProvider.getWeather(lat: 35.661991, lon: 139.762735, weather: $weather, options: OWHistOptions.yesterday())
    }
    
    func formattedDate(utc: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = frmt
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(utc)))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
