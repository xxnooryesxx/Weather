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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    let bag = DisposeBag()
    let vm = WeatherViewModel()
    
    var lat: Double = 0
    var lon: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.hidesWhenStopped = true
        setupCurrentWeather(lat: lat, lon: lon)
        setupForecast(lat: lat, lon: lon)
        setGesture()
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
                self.lblHLTemp.text = "\(String(format: "%.1f", weather.main.temp_max))°\n ——— \n\(String(format: "%.1f", weather.main.temp_min))°"
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
    }
    
    func setGesture() {
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        clctionView.addGestureRecognizer(tapGes)
        
        let slideGes = UIPanGestureRecognizer(target: self, action: #selector(slide(sender: )))
        self.view.addGestureRecognizer(slideGes)
        
        let swipeGes = UISwipeGestureRecognizer(target: self, action: #selector(slide(sender:)))
        swipeGes.direction = .up
        
        
    }
    
    @objc func tapAction() {
        
        if bottomConstraint.constant == -150{
            bottomConstraint.constant = 20
        } else {
            bottomConstraint.constant = -150
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func slide(sender: UIPanGestureRecognizer) {
        
        if sender.state == .began{
            
        } else if sender.state == .ended{
            print(sender.location(in: view))
            
            bottomConstraint.constant = bottomConstraint.constant < 20 ? 20 : -350
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            
        }
    }
    
    
}

