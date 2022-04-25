//
//  ContactsViewController.swift
//  chapter10
//
//  Created by user217022 on 4/4/22.
//

import UIKit
import CoreData
import AVFoundation

//delegate
class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var imgContactPicture: UIImageView!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCellPhone: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func changePicture(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != AVAuthorizationStatus.authorized
        { //Camera not authorized
            let alertController = UIAlertController(title: "Camera Access Denied", message: "In order to take pictures, you need to allow the app to access the camera in the Settings.", preferredStyle: .alert)
            let actionSettings = UIAlertAction(title: "Open Settings", style: .default) {action in self.openSettings()}
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(actionSettings)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }else{ // Alert authorized
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let cameraController = UIImagePickerController()
                cameraController.sourceType = .camera
                cameraController.cameraCaptureMode = .photo
                cameraController.delegate = self
                cameraController.allowsEditing = true
                self.present(cameraController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func openSettings(){
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            } else{
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgContactPicture.contentMode = .scaleAspectFit
            imgContactPicture.image = image
            if currentContact == nil{
                let context = appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }
            currentContact?.image = image.jpegData(compressionQuality: 1.0)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if currentContact != nil {
            txtName.text = currentContact!.contactName
            txtAddress.text = currentContact!.streetAddress
            txtCity.text = currentContact!.city
            txtState.text = currentContact!.state
            txtZip.text = currentContact!.zipCode
            txtPhone.text = currentContact!.phoneNumber
            txtCell.text = currentContact!.cellNumber
            txtEmail.text = currentContact!.email
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentContact!.birthday != nil{
                lblBirthdate.text = formatter.string(from: currentContact!.birthday as! Date)
            }
            if let imageData = currentContact?.image as? Data{
                imgContactPicture.image = UIImage(data: imageData)
            }
        }
        changeEditMode(self)
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip,
                                                 txtPhone, txtCell, txtEmail]
        //add a listener
        for textfield in textFields {
                    textfield.addTarget(self,
                                        action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                        for: UIControl.Event.editingDidEnd)
                }
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(callPhone(gesture:)))
        lblPhone.addGestureRecognizer(longPress)
    }
    
    @objc func callPhone(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began{
            let number = txtPhone.text
            if number!.count > 0 { //Don't call blank numbers
                let url = NSURL(string: "telprompt://\(number!)")
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
                print("Calling Phone Number: \(url!)")
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if currentContact == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }
            currentContact?.contactName = txtName.text
            currentContact?.streetAddress = txtAddress.text
            currentContact?.city = txtCity.text
            currentContact?.state = txtState.text
            currentContact?.zipCode = txtZip.text
            currentContact?.cellNumber = txtCell.text
            currentContact?.phoneNumber = txtPhone.text
            currentContact?.email = txtEmail.text
            return true
    }
    @objc func saveContact() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        //dispose of any resourcs that can be recreated
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName, txtZip, txtCell, txtCity, txtAddress, txtState, txtEmail,txtPhone]
        if sgmtEditMode.selectedSegmentIndex == 0{
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
                
            }
            btnChange.isHidden = true
            navigationItem.rightBarButtonItem = nil        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.save,target: self, action: #selector(self.saveContact))        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //register that the keyboard has beed ndisplayed
            self.registerKeyboardNotifications()
    }
    func dateChanged(date: Date) {
           if currentContact == nil {
               let context = appDelegate.persistentContainer.viewContext
               currentContact = Contact(context: context)
           }
           currentContact?.birthday = date
           let formatter = DateFormatter()
           formatter.dateStyle = .short
           lblBirthdate.text = formatter.string(from: date)
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
            if(segue.identifier == "segueContactDate"){
                let dateController = segue.destination as! DateViewController
                dateController.delegate = self
            }
    

}
}
