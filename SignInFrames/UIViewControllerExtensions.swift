//
//  Extensions.swift
//  FireBaseFirstApp
//
//  Created by Григорий Бойко on 09.07.2021.
//

import UIKit

extension UIViewController {
    //Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
       
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: - Automatic keyboard showing/hiding
extension UIViewController{
    
    func addKeyboardLisnteners(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            guard let activeField = self.view.selectedTextField else { return }
            
            if let scrollView = self.view.scrollView  {
                let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
                var aRect : CGRect = self.view.frame
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets

                aRect.size.height -= keyboardSize.height

                if (!aRect.contains(activeField.frame.origin)){
                    scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }

            }else if self.view.frame.origin.y == 0 {

                let globalFrameOfKeyboard = self.view.convert(keyboardSize, to: self.view)
                guard let globalFrameOfTF = activeField.globalFrame else {return}
                
                let dif = globalFrameOfTF.origin.y + globalFrameOfTF.height - globalFrameOfKeyboard.origin.y + 5
                if dif>0 {
                    self.view.frame.origin.y -= dif
                }

            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        //Если есть scrollView, двигаем вниз
        if let scrollView = self.view.scrollView{
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
        //Или просто в исходное положение
        else if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    

}
