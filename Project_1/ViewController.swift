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
    var date: Date?
    
    init(temperature:Double, detail: String, minTemp: Double, maxTemp: Double, imageName: String, date: Date){
        self.temperature = temperature
        self.detail = detail
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.imageName = imageName
        self.date = date
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var forecastTableView: UITableView!
    
    var weatherArray = [WeatherDay]()
    let url = "https://api.openweathermap.org/data/2.5/onecall?lat=40.354386155103285&lon=-94.88243178493983&units=imperial&appid=e4bbcb36109771706e78bc6514dd98e3"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        let test1 = WeatherDay(temperature: 75, detail: "cool", minTemp: 10, maxTemp: 80, imageName: "image1", date: Date.now)
        let test2 = WeatherDay(temperature: 85, detail: "dry", minTemp: 5, maxTemp: 99, imageName: "image2", date: Date.now)
        weatherArray.append(test1)
        weatherArray.append(test2)
        
        getData(){ (result: Result<Forecast,APIError>) in
            switch result{
            case .success(let forecast):
                for day in forecast.daily{
                    print (day)
                }
            case .failure(let apiError):
                switch apiError{
                case .error(let errorString):
                    print(errorString)
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = String(weatherArray[indexPath.row].temperature!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = segue.identifier
        if transition == "showDayWeather"{
            let destination = segue.destination as! DetailViewController
            destination.weather = weatherArray[forecastTableView.indexPathForSelectedRow!.row]
        }
    }
    
    
        
    
    
    
    
    enum APIError: Error {
        case error( errorString: String)
    }
    
    func getData<T: Decodable>(completion: @escaping (Result<T,APIError>) -> Void){
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
            decoder.dateDecodingStrategy = .secondsSince1970
            decoder.keyDecodingStrategy = .useDefaultKeys
            do{
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
                return
            }catch let decodingError {
                completion(.failure(APIError.error(errorString: "Error: \(decodingError.localizedDescription)")))
            }
            
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
            }
            let weather: [Weather]
            let clouds: Int
            let pop: Double
        }
        let daily: [Daily]
    }
}
