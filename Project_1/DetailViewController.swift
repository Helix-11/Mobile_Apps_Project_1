//
//  DetailViewController.swift
//  Project_1
//
//  Created by student on 11/10/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxtempLabel: UILabel!
    @IBOutlet weak var mintempLabel: UILabel!
    
    var weather: WeatherDay?
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the date formatter
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")

        
        //assign vars above to appropriate labels/image views.
        mintempLabel.text! += "\(weather!.minTemp!)°F"
        maxtempLabel.text! += "\(weather!.maxTemp!)°F"
        descriptionLabel.text = weather!.detail!
        dateLabel.text = dateFormatter.string(from: weather!.date!)
        loadImage(url: (weather?.imageUrl)!)
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
