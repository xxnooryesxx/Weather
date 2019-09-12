//
//  IndexViewController.swift
//  WeatherForecastRx
//
//  Created by 愤怒大葱鸭 on 9/12/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialButtons

import CoreLocation
import GooglePlaces

class MainViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnAdd: MDCButton!
    
    var ct = BehaviorRelay<[Cities]>(value: [])
    
    let vm = WeatherViewModel()
    let bag = DisposeBag()
    let locationManager = CLLocationManager()
    let listTblviewGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        
        requestLocation()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        setTblWeather()
        selectCity()
        deleteCity()
    }
    
    func setTblWeather() {
        
        ct.asObservable().bind(to: tblView.rx.items(cellIdentifier: "cell", cellType: MainTableViewCell.self)) { (row, data, cell) in
            
            self.vm.setupWeather(lat: data.lattitude, lon: data.lontitude).subscribe(onNext: { (weather) in
                
                let iconURL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
                do{
                    let imgUrl = URL(string: iconURL)!
                    let imgData = try Data(contentsOf: imgUrl)
                    
                    DispatchQueue.main.async {
                        cell.lblCity.text = weather.name
                        cell.lblHLTemp.text = "\(String(format: "%.1f", weather.main.temp_max))° / \(String(format: "%.1f", weather.main.temp_min))°"
                        cell.imgIcon.image = UIImage(data: imgData)
                    }
                } catch {
                    print("Error in parse img: \(error.localizedDescription)")
                }
            }).disposed(by: self.bag)
        }.disposed(by: bag)
    }
    
    func selectCity() {
        tblView.rx.itemSelected.subscribe(onNext: { (indexpath) in
            
            let dispatchG = DispatchGroup()
            let main = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = main.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
            
            dispatchG.enter()
            self.ct.subscribe(onNext: { (cities) in
                vc.lat = cities[indexpath.row].lattitude
                vc.lon = cities[indexpath.row].lontitude
                dispatchG.leave()
            }).disposed(by: self.bag)
            
            dispatchG.notify(queue: DispatchQueue.main, execute: {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        })
    }
    
    func deleteCity() {
        tblView.rx.itemDeleted.subscribe(onNext: { (indexpath) in
            var arr = self.ct.value
            arr.remove(at: indexpath.row)
            self.ct.accept(arr)
        }).disposed(by: bag)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        pickLocation()
    }
    
}

extension MainViewController: CLLocationManagerDelegate{
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lct = locations.last{
            
            ct.accept(ct.value + [Cities(lattitude:lct.coordinate.latitude
                , lontitude: lct.coordinate.longitude)])
            locationManager.stopUpdatingLocation()
        }
    }
}


extension MainViewController: GMSAutocompleteViewControllerDelegate{
    
    func pickLocation() {
        let autoComplete = GMSAutocompleteViewController()
        autoComplete.delegate = self
        present(autoComplete, animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        ct.accept(ct.value + [Cities(lattitude: place.coordinate.latitude
            , lontitude: place.coordinate.longitude)])

        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Fail to autocomplete: \(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
    
}
