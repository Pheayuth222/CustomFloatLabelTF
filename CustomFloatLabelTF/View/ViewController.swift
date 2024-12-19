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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        hideKeyboardOnTapAround()
        
        configureBGView()
        configureBGView2()
        
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

    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}


@IBDesignable
@objc open class CustomFloatTF: UITextField {

    fileprivate var labelPlaceholder : UILabel?
    
    fileprivate var placeholderLabelHeight : NSLayoutConstraint?

     private var _isRightViewVisible: Bool = true
    
    var isRightViewVisible: Bool {
        get {
            return _isRightViewVisible
        }
        set {
            _isRightViewVisible = newValue
        }
    }
    
     /// Disable Floating Label when true.
     @IBInspectable open var disableFloatingLabel : Bool = false
    
     /// Shake Bottom line when Showing Error ?
     @IBInspectable open var shakeLineWithError : Bool = true
    
     /// Change Bottom Line Color.
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            self.floatTheLabel()
        }
    }
    
     /// Change line color when Editing in textfield
    @IBInspectable open var selectedLineColor : UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0){
        didSet{
            self.floatTheLabel()
        }
    }
    
     /// Change placeholder color.
    @IBInspectable open var placeHolderColor : UIColor = UIColor.lightGray {
        didSet{
            self.floatTheLabel()
        }
    }
    
     /// Change placeholder color while editing.
    @IBInspectable open var selectedPlaceHolderColor : UIColor = UIColor.lightGray {
        didSet{
            self.floatTheLabel()
        }
    }

    //MARK:- Set Text
    override open var text:String?  {
        didSet {
            floatTheLabel()
        }
    }
    
    override open var placeholder: String? {
        willSet {
            if newValue != "" {
                self.labelPlaceholder?.text = newValue
            }
        }
    }
    
    //MARK:- UITtextfield Draw Method Override
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.upadteTextField(frame: CGRect(x:self.frame.minX, y:self.frame.minY, width:rect.width, height:rect.height));
    }

    // MARK:- Loading From NIB
    override open func awakeFromNib() {
        super.awakeFromNib()
         self.initialize()
    }
    
    // MARK:- Intialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }

    // MARK:- Text Rect Management
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:4, y:4, width:bounds.size.width, height:bounds.size.height);
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:4, y:4, width:bounds.size.width, height:bounds.size.height);
    }

    //MARK:- UITextfield Becomes First Responder
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.textFieldDidBeginEditing()
        return result
    }
    
    //MARK:- UITextfield Resigns Responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.textFieldDidEndEditing()
        return result
    }

    public func hideError() {
        floatTheLabel()
    }

}

fileprivate extension CustomFloatTF {
    
    //MARK:- ACFLoating Initialzation.
    func initialize() -> Void {
        
        self.clipsToBounds = true
        /// Adding Bottom Line
//        addBottomLine()
        
        /// Placeholder Label Configuration.
        addFloatingLabel()
        
        /// Checking Floatibility
        if self.text != nil && self.text != "" {
            self.floatTheLabel()
        }
        
    }
    
    @objc func textfieldEditingChanged(){
//        if showingError {
//            hideError()
//        }
    }
        
    //MARK:- ADD Floating Label
    func addFloatingLabel(){
        
        if labelPlaceholder?.superview != nil {
            return
        }
        
        var placeholderText : String? = labelPlaceholder?.text
        if self.placeholder != nil && self.placeholder != "" {
            placeholderText = self.placeholder!
        }
        labelPlaceholder = UILabel()
        labelPlaceholder?.text = placeholderText
        labelPlaceholder?.textAlignment = self.textAlignment
        labelPlaceholder?.textColor = placeHolderColor
        labelPlaceholder?.font = UIFont.init(name: (self.font?.fontName ?? "helvetica")!, size: 12)
        labelPlaceholder?.isHidden = true
        labelPlaceholder?.sizeToFit()
        labelPlaceholder?.translatesAutoresizingMaskIntoConstraints = false
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        if labelPlaceholder != nil {
            self.addSubview(labelPlaceholder!)
        }
        let leadingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 5)
        let trailingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        placeholderLabelHeight = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
        
        self.addConstraints([leadingConstraint,trailingConstraint,topConstraint])
        labelPlaceholder?.addConstraint(placeholderLabelHeight!)
        
    }
   
    //MARK:- Float & Resign
    func floatTheLabel() -> Void {
        DispatchQueue.main.async {
            if self.text == "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }else if self.text == "" && !self.isFirstResponder {
                self.resignPlaceholder()
            }else if self.text != "" && !self.isFirstResponder  {
                self.floatPlaceHolder(selected: false)
            }else if self.text != "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }
        }
    }
    
    //MARK:- Upadate and Manage Subviews
    func upadteTextField(frame:CGRect) -> Void {
        self.frame = frame;
        self.initialize()
    }
    
    //MARK:- Float UITextfield Placeholder Label
    func floatPlaceHolder(selected:Bool) -> Void {
        
        labelPlaceholder?.isHidden = false
        if selected {
            
            labelPlaceholder?.textColor = self.selectedPlaceHolderColor;
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: selectedPlaceHolderColor])
        } else {
            self.labelPlaceholder?.textColor = self.placeHolderColor
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        }

        if disableFloatingLabel == true {
            labelPlaceholder?.isHidden = true
            return
        }
        
        if placeholderLabelHeight?.constant == 15 {
            return
        }

        placeholderLabelHeight?.constant = 15;
        labelPlaceholder?.font = UIFont(name: (self.font?.fontName)!, size: 12)

        UIView.animate(withDuration: 0.2, animations: {
            print("English...")
            self.layoutIfNeeded()
        })
        
    }
    
    //MARK:- Resign the Placeholder
    func resignPlaceholder() -> Void {
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])

        if disableFloatingLabel {
            
            labelPlaceholder?.isHidden = true
            self.labelPlaceholder?.textColor = self.placeHolderColor;
            UIView.animate(withDuration: 0.2, animations: {
                print("disableFloatingLabel...")
                self.layoutIfNeeded()
            })
            return
        }
        
        placeholderLabelHeight?.constant = self.frame.height

        UIView.animate(withDuration: 0.3, animations: {
            self.labelPlaceholder?.font = self.font
            self.labelPlaceholder?.textColor = self.placeHolderColor
            self.layoutIfNeeded()
        }) { (finished) in
            print("Fishished...")
            self.labelPlaceholder?.isHidden = true
            self.placeholder = self.labelPlaceholder?.text
        }
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidBeginEditing() -> Void {
        
        if !self.disableFloatingLabel {
            self.placeholder = ""
        }
        self.floatTheLabel()
        self.layoutSubviews()
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidEndEditing() -> Void {
        self.floatTheLabel()
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
