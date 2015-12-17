//
//  SettingsViewController.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/14/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var measurementSwitch: UISwitch!
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var radius = [1.0,2.0,5.0,10.0,15.0,20.0,30.0,40.0,50.0]
    var measurementUnit : Double?
    
    var selectedRadius : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //radius setting
        if let radius = prefs.stringForKey("radius"){
            self.selectedRadius = (radius as NSString).doubleValue
        }else{
            self.selectedRadius = self.radius[2] * 1000
        }
        
        //measurement unit setting
        if let measurementUnit = prefs.stringForKey("measurementUnit"){
            if measurementUnit == "KM" {
                print("its km")
                self.measurementUnit = 1000
                measurementSwitch.setOn(true, animated: false)
            }else{
                print("its miles")
                self.measurementUnit = 1609.34
                measurementSwitch.setOn(false, animated: false)
            }
        }else{
            prefs.setValue("KM", forKey: "measurementUnit")
            self.measurementUnit = 1000
            measurementSwitch.setOn(true, animated: false)
        }
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        prefs.setValue(self.selectedRadius! * measurementUnit!, forKey: "radius")
        
        if measurementSwitch.on {
            prefs.setValue("KM", forKey: "measurementUnit")
            self.measurementUnit = 1000
        }else{
            prefs.setValue("Miles", forKey: "measurementUnit")
            self.measurementUnit = 1609.34
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SettingsViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radius.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(radius[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedRadius = self.radius[row]
    }
    
}
