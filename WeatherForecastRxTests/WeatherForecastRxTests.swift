//
//  WeatherForecastRxTests.swift
//  WeatherForecastRxTests
//
//  Created by 愤怒大葱鸭 on 9/13/19.
//  Copyright © 2019 愤怒大葱鸭. All rights reserved.
//

import XCTest


@testable import WeatherForecastRx

class WeatherForecastRxTests: XCTestCase {

    override func setUp() {

        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPIcall() {
        
        let nm = WeatherViewModel()
        
//        nm.setupWeather(lat: 50, lon: 50).subscribe(onNext: { (weather) in
//
//        }).disposed(by: DisposeBag)
        
        
    }

    func testTableViewExisting() {
        
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        _ = vc.view
        
        XCTAssertNotNil(vc.tblView)
        
    }

}
