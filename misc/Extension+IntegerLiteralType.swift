extension IntegerLiteralType {
    func toRadians() -> CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}