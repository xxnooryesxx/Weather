//
//  ViewController.swift
//  WeatherForecastRx
//
//  Created by 愤怒大葱鸭 on 9/11/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbltemp: UILabel!
    
    let bag = DisposeBag()
    let vm = WeatherViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.setupWeather(lat: 37, lon: -110).subscribe(onNext: { (weather) in
            
            var iconURL = "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png"
            
            print(iconURL)
            
            do{
                let imgUrl = URL(string: iconURL)!
                let imgData = try Data(contentsOf: imgUrl)
                
                DispatchQueue.main.async {
                    self.imgIcon.image = UIImage(data: imgData)
                }
                
            } catch {
                print("Error in parse img: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.lbltemp.text = weather.name
            }
            
        }).disposed(by: bag)
        
    }
    
    
    
}

