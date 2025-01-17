//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    let currencySignArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    var currencySelected = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.delegate = self
        currencyPicker.dataSource = self

        let selectedRow = currencyArray[0]
        currencySelected = currencySignArray[0]
        finalURL = baseURL + selectedRow

        getBitcoinData(url: finalURL)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = currencyArray[row]
        currencySelected = currencySignArray[row]
        finalURL = baseURL + selectedRow

        print(selectedRow)
        print(finalURL)
        getBitcoinData(url: finalURL)
    }

    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Sucess! Got the bitcoin data")
                let bitcoinJSON: JSON = JSON(response.result.value!)

                self.deserializeBitcoinJSON(json: bitcoinJSON)

            } else {
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }

    }

    func deserializeBitcoinJSON(json: JSON) {
        print(json)
        if let askResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySelected) \(askResult)"
        } else {
            bitcoinPriceLabel.text = "$ Unavailable"
        }
    }
}
