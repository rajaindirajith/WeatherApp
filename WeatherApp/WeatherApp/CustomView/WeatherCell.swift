//
//  WeatherCell.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var MaxMinTempLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
    }

    func setData(_ data: WeatherModel?) {
       
        if let weatherDetail = data?.weather?[0] {
            imageVw.image = UIImage(named: weatherDetail.icon)
            descLbl.text = weatherDetail.desc
        }
        MaxMinTempLbl.text = "Max:\(String(format:"%.2f°C", data?.temperature?.max ?? 0.0))  Min:\(String(format:"%.2f°C", data?.temperature?.min ?? 0.0))"
        windSpeedLbl.text = "Wind speed:\(String(format:"%.2f", data?.wind?.speed ?? 0.0))m/s"
        timeLbl.text = data?.timeStr
         currentTemp.text = "\(String(format:"%.2f°C", data?.temperature?.current ?? 0.0))"
        
    }

}
