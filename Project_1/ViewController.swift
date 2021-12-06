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
    var results: Forecast?
    let apiController = ApiController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        let test1 = WeatherDay(temperature: 75, detail: "cool", minTemp: 10, maxTemp: 80, imageName: "image1", date: Date.now)
        let test2 = WeatherDay(temperature: 85, detail: "dry", minTemp: 5, maxTemp: 99, imageName: "image2", date: Date.now)
        weatherArray.append(test1)
        weatherArray.append(test2)
        
        apiController.getData { (result)->() in
            print(result)
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
    
    
    func loadImage(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherImage.image = image
                    }
                }
            }
        }
    }
}
