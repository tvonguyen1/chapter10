//
//  SettingViewController.swift
//  chapter10
//
//  Created by user217022 on 4/4/22.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!
    
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pckSortField.dataSource = self
        pckSortField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
              //set the UI based on values in UserDefaults
              let settings = UserDefaults.standard
              //sets value of Switch basedon the value in the sortDirectionAscnding
              swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
              //read the sortField value into a constant
              let sortField = settings.string(forKey: Constants.kSortField)
              var i = 0
              //Picker View telling which number row to select
              for field in sortOrderItems {
                    if(field == sortField){
                          pckSortField.selectRow(i, inComponent: 0, animated: false)
                        }
                    i += 1
                  }
            pckSortField.reloadComponent(0)

        }
    @IBAction func sortDirectionChanged(_ sender: Any) {
        //store chosen value
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()    }
    // MARK: UIPickerViewDelegate Methods
        
    // Returns the number of 'columns' to display.
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    // Returns the # of rows in the picker
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
        }
        
        //Sets the value that is shown for each row in the picker
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
            -> String? {
                return sortOrderItems[row]
        }
        
        //If the user chooses from the pickerview, it calls this function;
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print("Chosen item: \(sortOrderItems[row])")
            let sortField = sortOrderItems[row]
            let settings = UserDefaults.standard
            settings.set(sortField, forKey: Constants.kSortField)
            settings.synchronize()        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
