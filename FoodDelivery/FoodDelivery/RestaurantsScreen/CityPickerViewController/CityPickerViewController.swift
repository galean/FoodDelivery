//
//  CityPickerViewController.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 17.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import UIKit

class CityPickerViewController: UIViewController {
    lazy var citiesModel: CitiesModelProtocol = {
        let model = CitiesModel()
        model.delegate = self
        return model
    }()
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    weak var delegate: CityPickerToRestaurantsProtocol?
    
    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.startAnimating()
        requestCities()
    }
    
    //MARK:- Buttons actions
    @IBAction func chooseCityButtonTapped() {
        let index = pickerView.selectedRow(inComponent: 0)
        citiesModel.chosenCity(atIndex: index)
    }
    
    func requestCities() {
        DispatchQueue.global().async {
            self.citiesModel.fetchCities()
        }
    }
    
    func updatePickerView() {
        activityView.stopAnimating()
        self.pickerView.reloadAllComponents()
        
        guard let currCityName = self.citiesModel.currentCityName else {
            return
        }
        
        let index = self.citiesModel.cities.firstIndex(where: { (city) -> Bool in
            city.name == currCityName
        })
        
        guard let currentCityIndex = index else {
            return
        }
        
        self.pickerView.selectRow(currentCityIndex, inComponent: 0, animated: false)
    }
}

//MARK:- UIPickerViewDataSource
extension CityPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citiesModel.cities.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int,
                     forComponent component: Int) -> String? {
        let city = citiesModel.cities[row]
        return city.name
    }
}

//MARK:- UIPickerViewDelegate
extension CityPickerViewController: UIPickerViewDelegate {
    
}

//MARK:- CitiesModelDelegate
extension CityPickerViewController: CitiesModelDelegate {
    func fetchedCities() {
        DispatchQueue.main.async {
            self.updatePickerView()
        }
    }
    
    func profileUpdated() {
        DispatchQueue.main.async {
            self.delegate?.pickedCity()
        }
    }
}

extension CityPickerViewController: RestaurantsToCityPickerProtocol {
    func setCurrentCity(_ currentCity: String) {
        citiesModel.currentCityName = currentCity
    }
}
