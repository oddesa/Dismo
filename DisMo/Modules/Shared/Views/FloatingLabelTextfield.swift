//
//  FloatingLabelTextfield.swift
//  DisMo
//
//  Created by Macbook on 27/02/23.
//

import UIKit

@IBDesignable class FloatingLabelTextField: UITextField {
    var floatingLabel: UILabel!
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? UIColor.white : UIColor.lightGray
            self.floatingLabelBackground = isEnabled ? UIColor.white : UIColor.lightGray
        }
    }
    
    var inputType: FloatingTextfieldType? {
        didSet {
            if inputType == .dropdown {
                setRightImage()
                self.tintColor = .clear
            }
            if inputType == .datePicker {
                addRightButton()
            }
        }
    }
    
    @IBInspectable
    var _placeholder: String? {
        didSet {
            self.placeholder = (_placeholder ?? "")
        }
    }
    
    override var text: String? {
        didSet {
            if text != "" {
                self.addFloatingLabel()
            }
        }
    }
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = UIColor.darkGray
    
    @IBInspectable
    var floatingLabelBackground: UIColor = UIColor.white.withAlphaComponent(1) {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingLabelBackground
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .light) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
          setupView()
      }

      func setupView() {
          self.placeholder = (_placeholder ?? "")
          self.floatingLabel.textColor = floatingLabelColor
          self.layer.backgroundColor = _backgroundColor.cgColor
//          self.layer.cornerRadius = cornerRadius
//          self.layer.shadowColor = shadowColor.cgColor
//          self.layer.shadowRadius = shadowRadius
//          self.layer.shadowOpacity = shadowOpacity
//          self.layer.borderWidth = borderWidth
//          self.layer.borderColor = borderColor.cgColor
      }
    
    private func setup() {
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self._placeholder = (self._placeholder != nil) ? (self._placeholder ?? "") : (placeholder ?? "")
        placeholder = self._placeholder
        if self.font == nil {
            self.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        }
        if self.text != "" {
            self.addFloatingLabel()
        }
        self.clearButtonMode = .whileEditing
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 0.1
        self.borderStyle = .roundedRect
        self.addTarget(self, action: #selector(self.beginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    @objc func beginEditing() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.addFloatingLabel()
            }
        }
    }
    
    func addFloatingLabel() {
        self.floatingLabel.textColor = floatingLabelColor
        self.floatingLabel.font = floatingLabelFont
        self.floatingLabel.text = (self._placeholder ?? "")
        self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
        self.floatingLabel.textAlignment = .center
        self.addSubview(self.floatingLabel)
        
        self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.floatingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.placeholder = ""
        
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.floatingLabel.removeFromSuperview()
                //                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func setRightItem() {
        switch inputType {
        case .dropdown:
            setRightImage()
        default:
            addRightButton()
        }
    }
    
    private func addRightButton() {
        self.button.setImage(UIImage(named: inputType!.imageName), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.button.frame = CGRect(x: -16, y: 16, width: 30, height: 16)
        self.button.layer.borderColor = UIColor.darkGray.cgColor
        self.button.layer.borderWidth = 1
        self.button.clipsToBounds = true
        self.rightView = self.button
        self.rightViewMode = .always
        if inputType == .password {
            self.button.addTarget(self, action: #selector(self.enablePasswordVisibilityToggle), for: .touchUpInside)
        }
    }
    
    private func setRightImage() {
        let image = UIImage(named: inputType!.imageName)
        let imageView = UIImageView.init(image: image ?? UIImage())
        //        imageView.backgroundColor = .yellow
        if let size = imageView.image?.size {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width + 10, height: size.height)
        }
        
        imageView.contentMode = .left
        self.rightViewMode = .always
        self.rightView = imageView
        self.clearButtonMode = .never
    }
    
    @objc func enablePasswordVisibilityToggle() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            self.button.setImage(UIImage(named: "ic_show"), for: .normal)
        } else {
            self.button.setImage(UIImage(named: "ic_hide"), for: .normal)
        }
    }
    
    let padding = UIEdgeInsets(top: 20, left: 16, bottom: 8, right: 16)
    let placeholderPadding = UIEdgeInsets(top: 12, left: 16, bottom: 8, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 24, y: 0, width: 20, height: bounds.height)
    }
}

enum FloatingTextfieldType {
    case dropdown
    case datePicker
    case password
    
    var imageName: String {
        switch self {
        case .dropdown:
            return "ic_arrow_down_black"
        case .datePicker:
            return "calendar_gray"
        case .password:
            return "ic_reveal"
        }
    }
}

