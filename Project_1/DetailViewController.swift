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
    
    //vars here to hold data passed in with the prepare method
    var temperature: Double = 0.0
    var wdescription: String = ""
    var weatherimage: String = ""
    var datelabel: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign vars above to appropriate labels/image views.
        temperatureLabel.text = "\(temperature)"
        descriptionLabel.text = wdescription
        dateLabel.text = datelabel
        weatherImage.image = UIImage(named: weatherimage)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
