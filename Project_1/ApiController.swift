//
//  ApiController.swift
//  Project_1
//
//  Created by student on 12/5/21.
//

import Foundation
import UIKit

class ApiController{
    private let url = "https://api.openweathermap.org/data/2.5/onecall?lat=40.354386155103285&lon=-94.88243178493983&units=imperial&appid=e4bbcb36109771706e78bc6514dd98e3"
    
    func getData(completion: @escaping (Forecast)->()){
            let task = URLSession.shared.dataTask(with: URL(string:url)!, completionHandler: { data, response, error in
                
                guard let data = data, error == nil else {
                    print("something went wrong")
                    return
                }
                var result: Forecast?
                do{
                    result = try JSONDecoder().decode(Forecast.self, from: data)
                }
                catch{
                    print("failed to convert: \(error)")
                }
                guard result != nil else{
                    return
                }
                // print(result!)
                completion(result!)
            })
            task.resume()
        }
}

struct Forecast: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    struct Current: Codable{
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        struct Weather: Codable{
            let id: Int
            let main: String
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)!
            }
            var desc: String{
                return description
            }
        }
        let weather: [Weather]
    }
    let current: Current
    struct Daily: Codable {
        let dt: Date
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)!
            }
            var desc: String{
                return description
            }
        }
        let weather: [Weather]
        let clouds: Int
        let pop: Double
    }
    let daily: [Daily]
}

enum APIError: Error {
    case error( errorString: String)
}
