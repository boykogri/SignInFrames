//
//  Views.swift
//  SignInFrames
//
//  Created by Григорий Бойко on 14.09.2021.
//

import UIKit

protocol SignUpDelegate: AnyObject {
    func signUp(email: String, password: String, phone: String)
}
class SignUpView: UIView {
    
    weak var delegate: SignUpDelegate?
    
    private var width: CGFloat {
        return self.frame.width
    }
    private var height: CGFloat {
        return self.frame.height
    }
    
    private var imageWidth: CGFloat {
        return width*0.7
    }
    private var imageHeight: CGFloat {
        return imageWidth*loginImage.size.height/loginImage.size.width
    }
    
    private let loginImage = #imageLiteral(resourceName: "login")
    private let mailImage = UIImage(named: "mail")
    private let passwordImage = UIImage(named: "mail")
    private let phoneImage = UIImage(named: "phone")
    private let hidePasswordImage = #imageLiteral(resourceName: "hidePassword")
    
    
    //MARK: UI properties
    lazy var scroll: UIScrollView = {
        let sv = UIScrollView(frame: self.frame)
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel.standardLabel
        let frame = CGRect(x: 0, y: height*0.05, width: width*0.3, height: 40)

        label.frame = frame
        label.center.x = self.center.x
        label.text = "Sign Up"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .darkGray
        label.baselineAdjustment = .alignCenters
        label.textAlignment  = .center
        
        return label
    }()
    private lazy var detailLabel: UILabel = {
        let label = UILabel.standardLabel
        let frame = CGRect(x: 0, y: signUpLabel.frame.maxY+10, width: width*0.7, height: 25)
        label.frame = frame
        label.center.x = self.center.x
        label.text = "Fill the details & create your account"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.textAlignment  = .center
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    private lazy var loginImageView: UIImageView = {
        let frame = CGRect(x: 0, y: detailLabel.frame.maxY+height*0.05, width: imageWidth, height: imageHeight)
        let imageView = UIImageView(frame: frame)
        imageView.image = loginImage
        imageView.contentMode = .scaleAspectFit
        imageView.center.x = self.center.x-10

        return imageView
    }()
    
    private lazy var mailTF: UITextField = {
        let tf = getStandardTextField()
        tf.placeholder = "Type your email"

        return tf
    }()
    private lazy var passwordTF: UITextField = {
        let tf = getStandardTextField()
        tf.placeholder = "Type your password"
        tf.isSecureTextEntry = true
        
        return tf
    }()
    private lazy var phoneTF: UITextField = {
        let tf = getStandardTextField()
        tf.placeholder = "+7 (900) 555-05-05"
        tf.keyboardType = .numberPad

        return tf
    }()
    private lazy var signUpButton: UIButton = {
        let b = UIButton()
        b.setTitle("Sign up", for: .normal)
        b.setTitleColor(.lightGray, for: .disabled)
        b.backgroundColor = #colorLiteral(red: 1, green: 0.2431372549, blue: 0.1843137255, alpha: 1)
        b.layer.cornerRadius = 10
        // Shadow
        b.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        b.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 10
        b.layer.masksToBounds = false
        b.isEnabled = false
        
        b.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        b.frame.size = CGSize(width: width*0.7, height: max(50, height*0.065))
        b.center.x = self.center.x
        b.frame.origin.y = phoneContainer.frame.maxY + 30
        return b
    }()
    
    private lazy var mailContainer: UIView = {
        let view = getTextContainer(icon: mailImage, title: "Mail", textField: mailTF)
        view.frame.origin.y = loginImageView.frame.maxY+15
        view.center.x = self.center.x
        return view
    }()
    private lazy var passwordContainer: UIView = {
        let view = getTextContainer(icon: passwordImage, title: "Password", textField: passwordTF, actionView: hidePasswordImageView)
        view.frame.origin.y = self.mailContainer.frame.maxY+15
        view.center.x = self.center.x
        
        return view
    }()
    private lazy var hidePasswordImageView: UIImageView = {

        let passwordHideIcon = UIImageView(image: hidePasswordImage)
        passwordHideIcon.contentMode = .scaleAspectFit
        passwordHideIcon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideShowPassword))
        passwordHideIcon.addGestureRecognizer(tap)
        return passwordHideIcon
    }()
    
    private lazy var phoneContainer: UIView = {
        let view = getTextContainer(icon: phoneImage, title: "Your phone", textField: phoneTF)
        view.frame.origin.y = self.passwordContainer.frame.maxY+15
        view.center.x = self.center.x
        return view
    }()

    private lazy var dontHaveAccountLabel: UILabel = {
        let label = UILabel.standardLabel
        label.textAlignment  = .center
        label.baselineAdjustment = .alignCenters

        let str = "Don't have an account? "
        let link = "Sign up"
        let attrStr = NSMutableAttributedString(string: str+link)
        attrStr.addAttributes(
            [.font: UIFont.systemFont(ofSize: 18),
             .foregroundColor: UIColor.systemGray
            ], range: NSMakeRange(0, str.count))
        attrStr.addAttributes([
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor : UIColor.link
            ],
            range: NSMakeRange(str.count, link.count))
//        UIColor(red: 45/255, green: 76/255, blue: 169/255, alpha: 1)
        label.attributedText = attrStr
        label.frame.origin.y = self.signUpButton.frame.maxY+30
        label.frame.size = CGSize(width: width*0.65, height: 35)
        label.center.x = self.center.x
        return label
    }()
    
    private var buttonIsEnabled: Bool{
        guard let mail = mailTF.text?.isEmpty, let password = passwordTF.text?.isEmpty, let phoneCount = phoneTF.text?.count else { return false }
        return !mail && !password && phoneCount > 1
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tap)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func createSubviews() {
        addSubview(scroll)
        scroll.addSubview(signUpLabel)
        scroll.addSubview(detailLabel)
        scroll.addSubview(loginImageView)
        scroll.addSubview(mailContainer)
        scroll.addSubview(passwordContainer)
        scroll.addSubview(phoneContainer)
        scroll.addSubview(signUpButton)
        scroll.addSubview(dontHaveAccountLabel)
        phoneTF.delegate = self
        scroll.contentSize = CGSize(width: width, height: max(dontHaveAccountLabel.frame.maxY+30, self.frame.maxY+30))
    }
    //MARK: - Helper
    private func getTextContainer(icon: UIImage?, title: String, textField: UITextField, actionView: UIImageView? = nil) -> UIView {
        let view = UIView()
        view.frame.size = CGSize(width: width*0.9, height: max(45, height*0.06))
//        view.backgroundColor = .red
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        let label = UILabel.standardLabel
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        
        
        view.addSubview(iconView)
        view.addSubview(label)
        view.addSubview(textField)
        
        iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        iconView.center.y = view.center.y
        
        let leftPad = iconView.frame.maxX+10
        let textWidth = view.frame.width - leftPad
        let labelHeight = view.frame.height*0.3
        let tfHeight = view.frame.height*0.7
        
        label.frame = CGRect(x: leftPad, y: 0, width: textWidth, height: labelHeight)
        textField.frame = CGRect(x: leftPad, y: labelHeight, width: textWidth, height: tfHeight)
        if let actionView = actionView {
            view.addSubview(actionView)
            actionView.frame.size = CGSize(width: 30, height: 30)
            actionView.center.y = textField.center.y
            actionView.frame.origin.x = textField.frame.maxX-30
        }
        
        return view
    }
    
    func getStandardTextField() -> UITextField {
        let textField = UITextField()
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.backgroundColor = .systemBackground
        textField.setBottomBorder()
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }
    
    //MARK: Handlers
    @objc func viewTapped(){
        self.endEditing(true)
    }
    @objc func hideShowPassword(){
        passwordTF.isSecureTextEntry.toggle()
    }

    @objc func signUpButtonTapped(){
        guard let phone = phoneTF.text, let email = mailTF.text, let password = passwordTF.text else {
            return
        }
        let newPhone = phone.applyPatternOnNumbers(pattern: "###########", replacementCharacter: "#")
        delegate?.signUp(email: email, password: password, phone: newPhone)
    }
    @objc func textFieldChanged(){
        signUpButton.isEnabled = buttonIsEnabled
    }
}
//MARK: UITextFieldDelegate
extension SignUpView: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return false }
        if range.location > 17 {return false}
        textField.text = text.applyPatternOnNumbers(pattern: "+# (###) ###-##-##", replacementCharacter: "#")
        return true
    }
}
//MARK: Static
private extension UILabel{
    static var standardLabel: UILabel {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
}
