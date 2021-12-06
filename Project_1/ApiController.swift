//
//  ApiController.swift
//  Project_1
//
//  Created by student on 12/5/21.
//

import Foundation
import UIKit

class ApiController{
    
    func getData(url: String, completion: @escaping (Forecast)->()){
            let task = URLSession.shared.dataTask(with: URL(string:url)!, completionHandler: { data, response, error in
                
                guard let data = data, error == nil else {
                    print("something went wrong")
                    return
                }
                var result: Forecast?
                do{
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    result = try decoder.decode(Forecast.self, from: data)
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
                let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
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
                let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
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
