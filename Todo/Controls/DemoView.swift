import UIKit

class DemoView: UIView {
    var path: UIBezierPath!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        //createRectangle()

        path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width/2 - self.frame.size.height/2,
                                    y: 0.0,
                                    width: self.frame.size.height,
                                    height: self.frame.size.height))


        UIColor.orange.setFill()
        path.fill()

        UIColor.purple.setStroke()
        path.stroke()
    }

    func createRectangle() {
        // Initialize the path.
        path = UIBezierPath(roundedRect: bounds, cornerRadius: 10.0)
    }


}
