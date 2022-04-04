//
//  ContactsViewController.swift
//  chapter10
//
//  Created by user217022 on 4/4/22.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //register that the keyboard has beed ndisplayed
            self.registerKeyboardNotifications()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //a method to stop the keyboard from liststending for notification
        self.unregisterKeyboardNotifications()
    }
    func registerKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector:
                #selector(ContactsViewController.keyboardDidShow(notification:)), name:
                UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector:
                #selector(ContactsViewController.keyboardWillHide(notification:)), name:
                UIResponder.keyboardWillHideNotification, object: nil)
        }
        //remove the listener
        func unregisterKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self)
        }
        
    @objc func keyboardDidShow(notification: NSNotification) {
        //information is collected from notification to get the displaued size
        //move the content the appropriate amount
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSize = keyboardInfo.cgRectValue.size
            
            // Get the existing contentInset for the scrollView and set the bottom property to be the height of the keyboard
            var contentInset = self.scrollView.contentInset
        //ensure the content is above the keyboard
            contentInset.bottom = keyboardSize.height
            //set new content insert values
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
        
    @objc func keyboardWillHide(notification: NSNotification) {
            //distance of Scroll View content from the edge
            
            var contentInset = self.scrollView.contentInset
            
            
            contentInset.bottom = 0
           //set to orginal
            self.scrollView.contentInset = contentInset
            
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
