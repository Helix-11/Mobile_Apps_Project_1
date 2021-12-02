//
//  ViewController.swift
//  Project_1
//
//  Created by student on 11/9/21.
//

import UIKit

class WeatherDay{
    var temperature: Double?
    var detail: String?
    var minTemp: Double?
    var maxTemp: Double?
    var imageName: String?
    
    init(temperature:Double, detail: String, minTemp: Double, maxTemp: Double, imageName: String){
        self.temperature = temperature
        self.detail = detail
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.imageName = imageName
    }
    
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var weatherArray = [WeatherDay]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = String(weatherArray[indexPath.row].temperature!)
        return cell
    }
    

    @IBOutlet weak var forecastTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        let test1 = WeatherDay(temperature: 75, detail: "cool", minTemp: 10, maxTemp: 80, imageName: "image1")
        weatherArray.append(test1)
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=40.354386155103285&lon=-94.88243178493983&units=imperial&appid=e4bbcb36109771706e78bc6514dd98e3"
        getData(from: url)
    }
    
    private func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string:url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var result: Forecast?
            do{
                result = try JSONDecoder().decode(Forecast.self, from: data)
            }
            catch{
                print("failed to convert \(error.localizedDescription)")
            }
            /*guard let json = result else{
                return
            }*/
            print(result!.lat)
        })
        task.resume()
    }
    
    /*struct Forecast: Codable {
        struct Temp: Codable {
            let temp: Double
        }
        let temp: Temp
        struct Weather: Codable {
            let description: String
        }
        let weather: [Weather]
    }*/
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
            let wind_speed: Int
            let wind_deg: Int
            struct Weather: Codable{
                let id: Int
                let main: String
                let description: String
                let icon: String
            }
        }
        struct Minutely: Codable{
            let dt: Int
            let precipitation: Int
        }
        struct Hourly: Codable{
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
            let wind_speed: Int
            let wind_deg: Int
            struct Weather: Codable{
                let id: Int
                let main: String
                let description: String
                let icon: String
            }
        }
        struct Daily: Codable{
            let dt: Int
            let sunrise: Int
            let sunset: Int
            let moonrise: Int
            let moonset: Int
            let moon_phase: Double
            struct temp: Codable{
                let day: Double
                let min: Double
                let max: Double
                let night: Double
                let eve: Double
                let morn: Double
            }
            struct feels_like: Codable{
                let day: Double
                let night: Double
                let eve: Double
                let morn: Double
            }
            let pressure: Int
            let humidity: Int
            let dew_point: Double
            let wind_speed: Double
            let wind_deg: Int
            let wind_gust: Double
            struct weather{
                let id: Int
                let main: String
                let description: String
                let icon: String
            }
            let clouds: Int
            let pop: Double
            let uvi: Double
        }
    }
}
            



