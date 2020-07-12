//
//  Finals Calc.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 12/4/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import Foundation
import UIKit

class FinalsCalcViewController: UIViewController {

    @IBOutlet fileprivate weak var quarter1Field: UITextField!
    @IBOutlet fileprivate weak var quarter2Field: UITextField!
    @IBOutlet fileprivate weak var desiredGradeField: UITextField!
    @IBOutlet fileprivate weak var calcBtn: UIButton!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(FinalsCalcViewController.keyboardWillShow),
                                                         name: NSNotification.Name.UIKeyboardWillShow,
                                                         object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(FinalsCalcViewController.keyboardWillHide),
                                                         name: NSNotification.Name.UIKeyboardWillHide,
                                                         object: nil)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(FinalsCalcViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGR)
    }

    @objc func dismissKeyboard() {
         view.endEditing(true)
    }

    @objc func keyboardWillShow(_ note: Notification) {
        guard let userInfo = note.userInfo else {
            return
        }

        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size

        let keyboardHeight = keyboardSize.height

        let insetHeight = keyboardHeight - 30
        let contentInset = UIEdgeInsetsMake(0, 0, insetHeight, 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide(_ note: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @IBAction func calculateFinalGrade(_ sender: AnyObject) {
        let quarter1 = (quarter1Field.text! as NSString).doubleValue
        let quarter2 = (quarter2Field.text! as NSString).doubleValue
        let desiredGrade = (desiredGradeField.text! as NSString).doubleValue

        let finalGrade = (desiredGrade - (0.40 * (quarter1 + quarter2)))/0.20
        var message = ""

        if (finalGrade >= 90) {
            message = "You have to get at least \(finalGrade)% on your final. You've got this."
        } else if (finalGrade >= 80 && finalGrade < 90) {
            message = "You have to get at least \(finalGrade)% on your final. Don't worry, you'll do fine."
        } else if (finalGrade < 80 && finalGrade > 0) {
            message = "You have to get at least \(finalGrade)% on your final. Why are you even checking?? Relax...."
        } else {
            message = "Invalid input. Please enter valid numbers in all fields to see your required grade."
        }

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
