//
//  ViewController.swift
//  WeatherForecastRx
//
//  Created by 愤怒大葱鸭 on 9/11/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityViewController: UIViewController {

    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblHLTemp: UILabel!
    @IBOutlet weak var clctionView: UICollectionView!
    
    let bag = DisposeBag()
    let vm = WeatherViewModel()
    
    var lat: Double = 0
    var lon: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.hidesWhenStopped = true
        setupCurrentWeather(lat: lat, lon: lon)
        setupForecast(lat: lat, lon: lon)
        
    }
    
    func setupCurrentWeather(lat: Double, lon: Double) {
        progressView.startAnimating()
        vm.setupWeather(lat: lat, lon: lon).subscribe(onNext: { (weather) in
            
            let iconURL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
            do{
                let imgUrl = URL(string: iconURL)!
                let imgData = try Data(contentsOf: imgUrl)
                
                DispatchQueue.main.async {
                    self.imgIcon.image = UIImage(data: imgData)
                    self.progressView.stopAnimating()
                }
                
            } catch {
                print("Error in parse img: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.lblCity.text   = weather.name
                self.lblTemp.text   =  "\(String(format: "%.1f", weather.main.temp))℃ "
                self.lblHLTemp.text = "\(String(format: "%.1f", weather.main.temp_max))°\n ---- \n\(String(format: "%.1f", weather.main.temp_min))°"
                self.lblDescription.text = weather.weather[0].main
            }
            
        }).disposed(by: bag)
    }
    
    func setupForecast(lat: Double, lon: Double) {
        
        vm.setupForecast().bind(to: clctionView.rx.items(cellIdentifier: "cell", cellType: ForecastCollectionViewCell.self)) { row, weather, cell in
            
            
            cell.lblCity.text = self.lblCity.text
            cell.lblHLTemp.text = "\(String(format: "%.1f", weather.main.temp_max))° / \(String(format: "%.1f", weather.main.temp_min))°"
            
            let iconURL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
            do{
                let imgUrl = URL(string: iconURL)!
                let imgData = try Data(contentsOf: imgUrl)
                
                DispatchQueue.main.async {
                    cell.imgIcon.image = UIImage(data: imgData)
                    self.progressView.stopAnimating()
                }
            } catch {
                print("Error in parse forecast img: \(error.localizedDescription)")
            }

            
        }.disposed(by: bag)
        
//        vm.setupForecast(lat: lat, lon: lon).bind(to: clctionView.rx.items(cellIdentifier: "cell", cellType: ForecastCollectionViewCell.self)) { (row, weathers, cell) in
//
//            DispatchQueue.main.async {
//                cell.lblCity.text = weathers.city.name
//            }
//
//            //looping every 8 elements in the JSON
//            for (index, weather) in weathers.list.enumerated(){
//                if index % 8 == 0{
//
//                    let date = Date(timeIntervalSince1970: TimeInterval(weather.dt))
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "MMM d"
//                    let realDate = dateFormatter.string(from: date)
//                    print(realDate)
//
//                    DispatchQueue.main.async {
//                        cell.lblHLTemp.text = "\(String(format: "%.1f", weather.main.temp_max))°\n ---- \n\(String(format: "%.1f", weather.main.temp_min))°"
//                        cell.lblDate.text = dateFormatter.string(from: date)
//                    }
//
//                    let iconURL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
//                    do{
//                        let imgUrl = URL(string: iconURL)!
//                        let imgData = try Data(contentsOf: imgUrl)
//
//                        DispatchQueue.main.async {
//                            cell.imgIcon.image = UIImage(data: imgData)
//                            self.progressView.stopAnimating()
//                        }
//                    } catch {
//                        print("Error in parse forecast img: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
    }
    
    
    
}

