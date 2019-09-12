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

class MainViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    let vm = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setTblWeather(lat: Double, lon: Double) {

        let data = Observable<[String]>.just(["HEHEHEHE", "eeee"])
        
        data.bind(to: tblView.rx.items(cellIdentifier: "cell", cellType: MainTableViewCell.self)){ index, model, cell in
            
        }
        
        vm.setupForecast().bind(to: tblView.rx.items(cellIdentifier: "cell", cellType: MainTableViewCell.self)){ index, model, cell in
            
        }
        
//        vm.setupForecast().bind(to: tblView.rx.items(cellIdentifier: "cell")) {
//
//        }
    }
    
    
}
