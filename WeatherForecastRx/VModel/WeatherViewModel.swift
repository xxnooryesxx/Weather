//
//  WeatherViewModel.swift
//  WeatherForecastRx
//
//  Created by 愤怒大葱鸭 on 9/11/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel {
    
    let bag = DisposeBag()
    let APIKey = "39aabae35289a57382031062adf9f9f0"

    
    
    func setupWeather(lat: Double, lon: Double) -> Observable<WeatherModel> {
        
        return Observable<WeatherModel>.create({ (obs) -> Disposable in
            let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&APPID=\(self.APIKey)"
            
            print(weatherURL)
            let reqObs = Observable.just(weatherURL)
                .map{URL(string: $0)!}
                .map{URLRequest(url: $0)}
            
            reqObs.subscribe(onNext: { (req) in
                URLSession.shared.rx.data(request: req).subscribe(onNext: { (data) in
                    do{
                        let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                        print(weather)
                        obs.onNext(weather)
                        obs.onCompleted()
                    } catch{
                        print("Errors during parse JSON... : \(error.localizedDescription)")
                    }
                    
                }).disposed(by: self.bag)
            }).disposed(by: self.bag)
            
            return Disposables.create {
                print("disposed")
            }
            
        })
    }
    
    
    func setupForecast(lat: Double, lon: Double) -> Observable<[ForecastWeather]> {
        return Observable<[ForecastWeather]>.create({ (obs) -> Disposable in
            
            let forcastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&APPID=\(self.APIKey)"
            
            let obsReq = Observable.just(forcastURL)
                .map{URL(string: $0)!}
                .map{URLRequest(url: $0)}
            
            obsReq.subscribe(onNext: { (req) in
                URLSession.shared.rx.data(request: req)
                    .subscribe(onNext: { (data) in
                        do{
                            let forecast = try JSONDecoder().decode([ForecastWeather].self, from: data)
                            obs.onNext(forecast)
                            obs.onCompleted()
                            
                        } catch {
                            print("Error during parse JSON...: \(error.localizedDescription)")
                        }
                        
                }).disposed(by: self.bag)
            }).disposed(by: self.bag)
            
            return Disposables.create {
                print("Disposed")
            }
        })
    }
    
    
    func setupForecast() -> Observable<[FutureContent]> {
        
        return Observable<[FutureContent]>.create({ (obs) -> Disposable in
            
            let forcastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=10&lon=10&units=metric&APPID=\(self.APIKey)"
            
            let obsReq = Observable.just(forcastURL)
                .map{URL(string: $0)!}
                .map{URLRequest(url: $0)}
            
            obsReq.subscribe(onNext: { (req) in
                URLSession.shared.rx.data(request: req)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (data) in
                        do{
                            let forecast = try JSONDecoder().decode(ForecastWeather.self, from: data)
                            
                            var lists : [FutureContent] = []
                            for (index, list) in forecast.list.enumerated(){
                                if index % 8 == 0 {
                                    lists.append(list)
                                }
                            }
                            obs.onNext(lists)
                            obs.onCompleted()
                        } catch {
                            print("Error during parse JSON...: \(error.localizedDescription)")
                        }
                        
                    }).disposed(by: self.bag)
            }).disposed(by: self.bag)
            
            return Disposables.create {
                print("Disposed")
            }
        })
    }
}
