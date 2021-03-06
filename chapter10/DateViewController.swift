//
//  DateViewController.swift
//  chapter10
//
//  Created by user217022 on 4/11/22.
//

import UIKit

//protocol
protocol DateControllerDelegate: class {
    func dateChanged(date: Date)
}
//delegator
class DateViewController: UIViewController {
    @IBOutlet weak var dtpDate: UIDatePicker!
    weak var delegate: DateControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton: UIBarButtonItem =
                    UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save,
                                    target: self,
                                    action: #selector(saveDate))
                self.navigationItem.rightBarButtonItem = saveButton
                self.title = "Pick Birthdate"
            }
            
            @objc func saveDate(){
                self.delegate?.dateChanged(date: dtpDate.date)
                self.navigationController?.popViewController(animated: true)
            }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


