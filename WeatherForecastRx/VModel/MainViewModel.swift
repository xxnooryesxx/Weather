//
//  MainViewModel.swift
//  WeatherForecastRx
//
//  Created by 愤怒大葱鸭 on 9/12/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    var cities: [String] = []
    
    func parseCities(lat: Double, lon: Double) -> Observable<[Cities]> {
        
        return Observable<[Cities]>.create({ (obs) -> Disposable in
            
            WeatherViewModel().setupWeather(lat: lat , lon: lon).subscribe(onNext: { (weathers) in
                weathers.name
                
            }).disposed(by: DisposeBag())
            
            return Disposables.create {
                print("disposed city")
            }
        })
    }
}


