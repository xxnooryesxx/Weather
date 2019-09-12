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
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var cities: [Cities] = []
    var ct = BehaviorRelay<[Cities]>(value: [])
    
    let vm = WeatherViewModel()
    let bag = DisposeBag()
    let locationManager = CLLocationManager()
    let listTblviewGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Chicago = Cities(lattitude: 31.917359, lontitude:  -80.265421)
        cities.append(Chicago)
        
        
        requestLocation()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
//
//        for city in self.cities{
//            self.setTblWeather()
//        }
        setTblWeather()
        selectCity()
        
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
            
            cities.append(Cities(lattitude:lct.coordinate.latitude
, lontitude: lct.coordinate.longitude))
            
            ct.accept(ct.value + cities)
            locationManager.stopUpdatingLocation()
            
        }
    }
}
