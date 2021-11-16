// This to add space between each characters
extension UILabel {

    func addCharacterSpacing(spacing: CGFloat) {
        if let labelText = text, labelText.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern,
                                          value: spacing,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}