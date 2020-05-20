//
//  SearchByCityScreen.swift
//  Weather
//
//  Created by rajaindirajith on 5/20/20.
//  Copyright © 2020 rajaindirajith. All rights reserved.
//

import UIKit

class SearchByCityScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var viewModel:SearchScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "Search by Cities"
        self.navigationController?.navigationBar.isHidden = false
        viewModel = SearchScreenViewModel(withScreenDelegate: self)
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
    }
    
    @IBAction func onClickingSearchBtn()
    {
        viewModel?.setSearchText(searchTF.text)
    }

}

extension SearchByCityScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension SearchByCityScreen: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "WeatherCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? WeatherCell else {
           return UITableViewCell()
        }

        if let oneDayModel = viewModel?.dataSource[indexPath.section]{
            cell.setData(oneDayModel)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.dataSource[section].cityDetails?.cityCountryName ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
       
}


extension SearchByCityScreen: WeatherSearchDelegate {
   
    func didFinishSearch(_ error:String?) {
        if let errorStr = error {
            let alert = UIAlertController(title: "Error", message: errorStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            tableView.reloadData()
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
