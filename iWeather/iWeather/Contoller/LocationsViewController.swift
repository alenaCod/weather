//
//  LocationsViewController.swift
//  iWeather
//
//  Created by Mac on 7/29/18.
//  Copyright © 2018 Alona Moiseyenko. All rights reserved.
//

import Foundation
import UIKit

class LocationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
            searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton! {
        didSet {
            btnDone.isHidden = true
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func onDone(_ sender: Any) {
        guard let _selectedLocation = selectedLocation else {
            return
        }
        
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name("LocationChangeNotification"), object: nil, userInfo: ["location": _selectedLocation])
        })
    }
    
    
    var selectedLocation: JSONLocation?
    var parsedLocations = [JSONLocation]()
    var filteredLocations: [JSONLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredLocations = parsedLocations
        initTable()
    }
    
    func initTable() {
        let nib = UINib(nibName: String(describing: AutoCompleteCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: AutoCompleteCell.self))
    }
    
    func performSearch(term: String = "") {
        if term == "" {
            filteredLocations = parsedLocations
        } else {
            let filtered = parsedLocations.filter({$0.name.lowercased().contains(term.lowercased())})
            filteredLocations = filtered
        }
    }
    
    fileprivate func hideKeyboard() {
        searchField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        performSearch(term: textField.text ?? "")
    }
}

extension LocationsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        btnDone.isHidden = false
        selectedLocation = filteredLocations[indexPath.row]
        hideKeyboard()
    }
}

extension LocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AutoCompleteCell.self)) as! AutoCompleteCell
        
        cell.configureCell(location: filteredLocations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
}

