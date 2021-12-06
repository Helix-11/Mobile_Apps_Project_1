
import UIKit
import MapKit
//import CoreLocation

class WeatherDay{
    var detail: String?
    var minTemp: Double?
    var maxTemp: Double?
    var imageUrl: URL?
    var date: Date?
    
    init(detail: String, minTemp: Double, maxTemp: Double, imageUrl: URL, date: Date){
        self.detail = detail
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.imageUrl = imageUrl
        self.date = date
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var forecastTableView: UITableView!
    
    var weatherArray = [WeatherDay]()
    var results: Forecast?
    var apiURL =  "https://api.openweathermap.org/data/2.5/onecall?units=imperial&appid=e4bbcb36109771706e78bc6514dd98e3"
    let apiController = ApiController()
    let locationManager = CLLocationManager()
    let geoDecoder = CLGeocoder()
    let dateFormatter = DateFormatter()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the date formatter
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")

        //Setup the location service
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            //Default location of maryville missouri
            apiURL.append("&lat=40.354386155103285&lon=-94.88243178493983")
            locationLabel.text = "Maryville, MO"
            callApi()
        }
    }
    
    
    func callApi(){
        apiController.getData(url: apiURL) { (result)->() in
            //print(result)
            for day in result.daily{
                let weather = day.weather[0]
                
                let weatherDay = WeatherDay(detail: weather.desc, minTemp: day.temp.min, maxTemp: day.temp.max, imageUrl: weather.weatherIconURL, date: day.dt)
                self.weatherArray.append(weatherDay)
            }
            
            DispatchQueue.main.async {
                //Setup the tableview only after we received the data
                self.forecastTableView.delegate = self
                self.forecastTableView.dataSource = self
                
                self.temperatureLabel.text = "\(result.current.temp)°F"
                self.descriptionLabel.text = result.current.weather[0].desc
                self.loadImage(url: result.current.weather[0].weatherIconURL)
            }
        }
    }
    
    
    //Event handler for when the location service receive a location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coords: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //Gets the city and state name and puts it in the label
        geoDecoder.reverseGeocodeLocation(locationManager.location!) { (placemarks, error) in
            var locationString = ""
            locationString.append("\(placemarks![0].locality!), ")
            locationString.append(placemarks![0].administrativeArea!)
            self.locationLabel.text = locationString
        }
        locationManager.stopUpdatingLocation()

        //Calls the api with the found coordinates
        apiURL.append("&lat=\(coords.latitude)&lon=\(coords.longitude)")
        callApi()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var defaultContentConfig = cell.defaultContentConfiguration()
        let currentDay = weatherArray[indexPath.row]
        
        defaultContentConfig.text = "\(dateFormatter.string(from: currentDay.date!))"
        defaultContentConfig.secondaryText = "\(currentDay.maxTemp!)°F | \(currentDay.minTemp!)°F"
        
        let imageData = try? Data(contentsOf: currentDay.imageUrl!)
        defaultContentConfig.image = UIImage(data: imageData!)
        defaultContentConfig.imageProperties.maximumSize = CGSize(width: 50.0, height: 50.0)
        
        cell.contentConfiguration = defaultContentConfig
        
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
