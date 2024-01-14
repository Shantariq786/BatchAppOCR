import Localize_Swift

@IBDesignable class LocalizableLabel: UILabel {

    @IBInspectable var table :String? // Table
    @IBInspectable var key:String? // KEY

    @IBInspectable var extraTextToAppend:String? // Some text need to append , if any


    override func awakeFromNib() {
        guard let key = key else {return}
        self.text = key.localized(using: table)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

        if let extraText = self.extraTextToAppend, let text = self.text {
            self.text = text + extraText
        }
    }

    @objc func setText () {
        guard let key = key else {return}
        self.text = key.localized(using: table)

        if let extraText = self.extraTextToAppend, let text = self.text {
            self.text = text + extraText
        }
    }
}

@IBDesignable class LocalizableButton: UIButton {

    @IBInspectable var table :String?
    @IBInspectable var key:String?

    override func awakeFromNib() {
        guard let key = key else {return}
        self.setTitle(key.localized(using: table), for: .normal)

        if let attributedText = self.attributedTitle(for: .normal) {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.replaceCharacters(in: NSMakeRange(0, mutableAttributedText.length), with: key.localized(using: table))
            self.setAttributedTitle(mutableAttributedText, for: .normal)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    }

    @objc func setText () {
        guard let key = key else {return}
        self.setTitle(key.localized(using: table), for: .normal)

        if let attributedText = self.attributedTitle(for: .normal) {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.replaceCharacters(in: NSMakeRange(0, mutableAttributedText.length), with: key.localized(using: table))
            self.setAttributedTitle(mutableAttributedText, for: .normal)
        }
    }
}



@IBDesignable class LocalizeUINavigationItem: UINavigationItem {

    @IBInspectable var table :String?
    @IBInspectable var key:String?

    override func awakeFromNib() {
        guard let key = key else {return}
        self.title = key.localized(using: table)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    }

    @objc func setText () {
        guard let key = key else {return}
        self.title = key.localized(using: table)

    }
}


@IBDesignable class LocalizableUITextField: UITextField {

    @IBInspectable var table_placeholder :String?
    @IBInspectable var key_place_holder:String?

    override func awakeFromNib() {
        guard let key = key_place_holder else {return}
        self.placeholder = key.localized(using: table_placeholder)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    }

    @objc func setText () {
        guard let key = key_place_holder else {return}
        self.placeholder = key.localized(using: table_placeholder)

    }
}
