//
//  ViewController.swift
//  Currency Converter
//
//  Created by Summer Crow on 05/11/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
   
    

    let listOfCurrencies = ["", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLF", "CLP", "CNY", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK",  "SGD", "SHP", "SLL", "SOS", "SRD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"]
    
    let baseURL = "http://data.fixer.io/api/latest?access_key=52d6d591fb2fdcac8b06a88ca94dd2ec&symbols="
    var completeURL = String()
    var fromCurrency = String()
    var toCurrency = String()
    var conversion = Conversion(currencyFromRate: 0, currencyToRate: 0, value: 0)
    var currencyFromIndex = Int()
    var currencyToIndex = Int()
    let fromCurrencyTextfieldTagNumber = 1
    let toCurrencyTextfieldTagNumber = 2
    
    @IBOutlet weak var amountToConvertTextField: UITextField!
    @IBOutlet weak var convertedLabel: UILabel!
    @IBOutlet weak var currencyPicker1: UIPickerView!
    @IBOutlet weak var currencyPicker2: UIPickerView!
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    
    var amountToConvert: Double? {
        return Double(amountToConvertTextField.text!)
    }
    
   
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker1.delegate = self
        currencyPicker1.dataSource = self
        currencyPicker2.delegate = self
        currencyPicker2.dataSource = self
        fromCurrencyTextField.delegate = self
        toCurrencyTextField.delegate = self
        
        
        // Allows dismissal of keyboard on tap anywhere on screen besides the keyboard itself
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
      //  let currencyName = "cad"
        //let currencyIndex = listOfCurrencies.index(of: currencyName.uppercased()) ?? 0
     //   currencyPicker1.selectRow(currencyIndex, inComponent: 0, animated: true)
    
    }
    
    //MARK: - Setting up the Pickerviews
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    
}
    //MARK: - Setting up pickerView
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listOfCurrencies.count
}

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfCurrencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView.tag == fromCurrencyTextfieldTagNumber){
            fromCurrency = listOfCurrencies[row].uppercased()
            fromCurrencyTextField.text = fromCurrency
            
            print(fromCurrency)
        }
        
            
        else if pickerView.tag == toCurrencyTextfieldTagNumber{
            toCurrency = listOfCurrencies[row].uppercased()
            toCurrencyTextField.text = toCurrency
            print(toCurrency)
        }
        
        completeURL = "\(baseURL)\(fromCurrency),\(toCurrency)"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = listOfCurrencies[row]
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 122.0/255, green: 237.0/255, blue: 71.0/255, alpha: 1.0)])
    }
    
    //MARK: - UItextfield Edits
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateCurrencyFromTextField(textFieldTagNumber: textField.tag)
        
    }

//  //MARK: - Networking
//**********************************************************************//

func getCurrencyValues(url: String){
    
    Alamofire.request(url, method: .get).responseJSON { response in
        if response.result.isSuccess {
            
            print("SUCCESS! GOT CONVERSION VALUES")
            let conversionValue : JSON = JSON(response.result.value!)
            print("CONVERSIONVALUE: \(conversionValue)")
            SVProgressHUD.dismiss()
            self.updateConversionToValue(json: conversionValue)
            
            
        }
        
        else {
            print("Error: \(String(describing: response.result.error))")
            
            self.currencyConverterAlert(title: "No internet connection", message: nil)
            
            SVProgressHUD.dismiss()
            
        }
    }
}
    //MARK: - JSON Parsing
    //*******************************************************************//
    
    func updateConversionToValue(json: JSON) {
        if let fromRates = json["rates"][fromCurrency].double {
            print("THE FROM RATES ARE \(fromRates)")
            conversion.currencyFromRate = fromRates
        }
        else {
            
            currencyConverterAlert(title: "Unavailable information", message: "Current rates for \(fromCurrency) unavailable")
            print("error FROM RATES NOT FOUND")
            
        }
        
        if let toRates = json["rates"][toCurrency].double {
            print("THE TO RATES ARE \(toRates)")
            conversion.currencyToRate = toRates
        }
        else {
            
            currencyConverterAlert(title: "Unavailable information", message: "Current rates for \(toCurrency) unavailable")
        
            print("error TO RATES NOT FOUND")
            
        }
        
        let convertedValue = conversion.convert(value: amountToConvert ?? 0)
        
        
       
        if convertedValue.isNaN || convertedValue.isInfinite  {
            convertedLabel.text = "error"
            
        }
        else {
            convertedLabel.text = String(format: "%.3f", convertedValue)
        }
       
        
    }
    //MARK: - My helper function
    
   func updateCurrencyFromTextField(textFieldTagNumber: Int){
    
        
        if textFieldTagNumber == fromCurrencyTextfieldTagNumber {

            if let currencyName = fromCurrencyTextField.text {
                currencyFromIndex = listOfCurrencies.index(of: currencyName.uppercased()) ?? 0
                currencyPicker1.selectRow(currencyFromIndex, inComponent: 0, animated: true)
                fromCurrency = currencyName.uppercased()
                if currencyFromIndex == 0 {
                    currencyConverterAlert(title: "Invalid Currency", message: "Please enter a valid 3 letter currency in the 'from currency' text field")
                    
                convertedLabel.text = ""


                }
            }

        }
        
        else if textFieldTagNumber == toCurrencyTextfieldTagNumber {
            if let currencyName = toCurrencyTextField.text {
                currencyToIndex = listOfCurrencies.index(of: currencyName.uppercased()) ?? 0
                currencyPicker2.selectRow(currencyToIndex, inComponent: 0, animated: true)
                toCurrency = currencyName.uppercased()

                if currencyToIndex == 0 {
                    currencyConverterAlert(title: "Invalid Currency", message: "Please enter a valid 3 letter currency in the 'to currency' text field")
                    
                    convertedLabel.text = ""

                }
            }
        }

        
    }
    
    //MARK: - Convert Button Action
    @IBAction func convert(_ sender: Any) {
        
        
    self.updateCurrencyFromTextField(textFieldTagNumber: fromCurrencyTextfieldTagNumber)
    self.updateCurrencyFromTextField(textFieldTagNumber: toCurrencyTextfieldTagNumber)
        
        completeURL = "\(baseURL)\(fromCurrency),\(toCurrency)"
        print("**COMPLETE URL**: \(completeURL)")
 
        SVProgressHUD.show()
        
        if amountToConvertTextField.text == "" {
            currencyConverterAlert(title: "Missing Data", message: "Please include amount to convert")
            
        }
        

        getCurrencyValues(url: completeURL)
      
       
        
       
        
        
}
        
    func currencyConverterAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)}
    
        

}

