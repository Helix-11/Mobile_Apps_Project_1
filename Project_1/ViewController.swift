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
        
        
    }
    
    


}

