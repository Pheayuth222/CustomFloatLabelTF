//
//  ViewController.swift
//  CustomFloatLabelTF
//
//  Created by Yuth Fight's iMac on 19/12/24.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgView2: UIView!
    
    @IBOutlet weak var bottomConstraintTF2: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintTF: NSLayoutConstraint!
    @IBOutlet weak var userNameTF: CustomFloatTF!
    @IBOutlet weak var passwordTF: CustomFloatTF!
    
    @IBOutlet weak var eyeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        eyeButton.tintColor = .systemTeal
        
        hideKeyboardOnTapAround()
        
        configureBGView()
        configureBGView2()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func hideShowPass(_ sender: UIButton) {
        // Change image of eye button
        passwordTF.isSecureTextEntry.toggle()
        if passwordTF.isSecureTextEntry {
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
}

extension ViewController {
    
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func configureBGView() {
        
        userNameTF.delegate = self
        userNameTF.font = UIFont.init(name: "helvetica", size: 16)
        userNameTF.placeholder = "ID or Phone number"
        userNameTF.borderStyle = .none
        userNameTF.tag = 1
        
        self.bottomConstraintTF.constant = 15
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = .white
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 1
        bgView.layer.masksToBounds = true
    }
    
    private func configureBGView2() {
        
        passwordTF.delegate = self
        passwordTF.font = UIFont.init(name: "helvetica", size: 16)
        passwordTF.placeholder = "Password"
        passwordTF.borderStyle = .none
        passwordTF.isSecureTextEntry = true
        passwordTF.textColor = .blue
        passwordTF.tag = 2
        
        self.bottomConstraintTF2.constant = 15
        bgView2.layer.cornerRadius = 10
        bgView2.backgroundColor = .white
        bgView2.layer.borderColor = UIColor.lightGray.cgColor
        bgView2.layer.borderWidth = 1
        bgView2.layer.masksToBounds = true
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Did begin editing")
        updateBorderColor(for: textField, color: UIColor.blue.cgColor)
        animateBottomConstraint(for: textField, constant: 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Did end editing")
        updateBorderColor(for: textField, color: UIColor.lightGray.cgColor)
        let constant = textField.text?.isEmpty == true ? 15 : 0
        animateBottomConstraint(for: textField, constant: CGFloat(constant))
    }
    
    private func updateBorderColor(for textField: UITextField, color: CGColor) {
        if textField.tag == 1 {
            bgView.layer.borderColor = color
        } else {
            bgView2.layer.borderColor = color
        }
    }
    
    private func animateBottomConstraint(for textField: UITextField, constant: CGFloat) {
        if textField.tag == 1 {
            bottomConstraintTF.constant = constant
        } else {
            bottomConstraintTF2.constant = constant
        }
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
}

struct FloatingLabelPreview: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() as? ViewController
            else {
                fatalError("Cannot load ViewController from Main storyboard.")
            }
            return viewController
        }
    }
}
