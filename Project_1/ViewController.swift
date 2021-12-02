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
    let url = "https://api.openweathermap.org/data/2.5/onecall?lat=40.354386155103285&lon=-94.88243178493983&units=imperial&appid=e4bbcb36109771706e78bc6514dd98e3"
        
    

    @IBOutlet weak var forecastTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        let test1 = WeatherDay(temperature: 75, detail: "cool", minTemp: 10, maxTemp: 80, imageName: "image1")
        weatherArray.append(test1)
    
    }
    
    enum APIError: Error {
        case error( errorString: String)
    }
    
    private func getData<T: Decodable>(url: String,dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, completion: @escaping (Result<T,APIError>) -> Void){
        guard let url = URL(string: url)else{
            completion(.failure(.error(errorString: NSLocalizedString("Error: Invalid URL", comment: ""))))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if let error = error {
                completion(.failure(.error(errorString: "Error: \(error.localizedDescription)")))
                return
            }
            
            guard let data = data else{
                completion(.failure(.error(errorString: NSLocalizedString("Error: Data is corrupt.", comment: ""))))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do{
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
                return
            }catch let decodingError {
                completion(.failure(APIError.error(errorString: "Error: \(decodingError.localizedDescription)")))
            }
            
        }
        
    }
    
    func getData(url:"https://api.openweathermap.org/data/2.5/onecall?lat=40.354386155103285&lon=-94.88243178493983&units=imperial&appid=e4bbcb36109771706e78bc6514dd98e3") { (Result<Forecast, APIError>)().self
        in
        switch result{
        case .success(let Forecast):
        case .failure(let apiError):
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
        struct current: Codable{
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
            let weather: [Weather]
        }
        struct Minutely: Codable{
            let dt: Int
            let precipitation: Int
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
            



