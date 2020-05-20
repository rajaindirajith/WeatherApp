//
//  CurrentLocationWeatherScreen.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import UIKit

class CurrentLocationWeatherScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
 
    var viewModel:CurrentLocationScreenModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        viewModel = CurrentLocationScreenModel(withScreenDelegate: self)
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
    }
    
}

extension CurrentLocationWeatherScreen: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dataSource[section].items.count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cellID = "WeatherCell"
       guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? WeatherCell else {
           return UITableViewCell()
       }
        
        if let oneDayModel = viewModel?.dataSource[indexPath.section]{
            cell.setData(oneDayModel.items[indexPath.row])
        }
       
       return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.dataSource[section].sectionTitle ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
       
}


extension CurrentLocationWeatherScreen: WeatherSearchDelegate {
   
    func didFinishSearch(_ error:String?) {
        self.title = ""
        if let errorStr = error {
            let alert = UIAlertController(title: "Error", message: errorStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            tableView.reloadData()
            self.title = viewModel?.locationTitle
        }
    }
    
    func showSearchLoader(_ shouldShow:Bool) {
        if shouldShow {
            loader.startAnimating()
        }else {
            loader.stopAnimating()
        }
    }
    
}
