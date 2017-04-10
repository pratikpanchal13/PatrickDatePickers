# PatrickDatePickers

[![CI Status](http://img.shields.io/travis/pratikpanchal131/PatrickDatePickers.svg?style=flat)](https://travis-ci.org/pratikpanchal131/PatrickDatePickers)
[![Version](https://img.shields.io/cocoapods/v/PatrickDatePickers.svg?style=flat)](http://cocoapods.org/pods/PatrickDatePickers)
[![License](https://img.shields.io/cocoapods/l/PatrickDatePickers.svg?style=flat)](http://cocoapods.org/pods/PatrickDatePickers)
[![Platform](https://img.shields.io/cocoapods/p/PatrickDatePickers.svg?style=flat)](http://cocoapods.org/pods/PatrickDatePickers)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* Swift 3.0
* Xcode 8
* iOS 9.0+

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

MST1 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile

````ruby
use_frameworks!

pod 'PatrickDatePickers', :git => 'https://github.com/pratikpanchal13/PatrickDatePickers.git'
````


## USAGE

import PatrickDatePickers in ViewController.swift

````ruby   
import PatrickDatePickers
````

create datePicker object & dateFormatter
````ruby

  var datePicker = PKDatePickers.getFromNib()
  var dateFormatter = DateFormatter()
````

create  function setupDatePicker() and call in ViewDidLoad
````ruby

fileprivate func setupDatePicker() {
        
    datePicker.delegate = self

    datePicker.config.startDate = Date()

    datePicker.config.animationDuration = 0.25

    datePicker.config.cancelButtonTitle = "Cancel"
    datePicker.config.confirmButtonTitle = "Confirm"

    datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
    datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
    datePicker.config.confirmButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
    datePicker.config.cancelButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)

 }
    
  ````


Add PKDatePickersDelegate Delegate Method
````ruby
extension SettingVC: PKDatePickersDelegate {
    
    func pkDatePickers(_ pkDatePickers: PKDatePickers, didSelect date: Date) {
    }
    func pkDatePickersDidCancelSelection(_ pkDatePickers: PKDatePickers) {
    }
    
}

  ````


## Author

pratikpanchal131, pratik.pancha13@gmail.com

## License

PatrickDatePickers is available under the MIT license. See the LICENSE file for more info.
