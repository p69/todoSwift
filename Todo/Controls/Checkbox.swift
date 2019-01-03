import Foundation
import UIKit

@IBDesignable
class Checkbox: UIControl {

    @IBInspectable
    var strokeWidth: CGFloat = 2.0 {
        didSet {
            strokeLayer.lineWidth = strokeWidth
        }
    }

    @IBInspectable
    var strokeColor: UIColor = UIColor.black.withAlphaComponent(0.7) {
        didSet {
            strokeLayer.strokeColor = strokeColor.cgColor
        }
    }

    @IBInspectable
    var edgeRadius: CGFloat = 1.0

    @IBInspectable
    var checkedBackgroundColor: UIColor = UIColor.cyan {
        didSet {
            checkedLayer.fillColor = checkedBackgroundColor.cgColor
        }
    }

    @IBInspectable
    var uncheckedBackgroundColor: UIColor = UIColor.clear {
        didSet {
            uncheckedLayer.fillColor = uncheckedBackgroundColor.cgColor
        }
    }

    @IBInspectable
    var checkmarkColor: UIColor = UIColor.white {
        didSet {
            checkmarkLayer.strokeColor = checkmarkColor.cgColor
        }
    }

    @IBInspectable
    var checkmarkWidth: CGFloat = 2.0 {
        didSet {
            checkmarkLayer.lineWidth = checkmarkWidth
        }
    }

    var onValueChanged: ((Bool)->())?

    private var checkMarkPath: UIBezierPath!
    private var borderPath: UIBezierPath!

    private var strokeLayer = CAShapeLayer()
    private var checkedLayer = CAShapeLayer()
    private var checkmarkLayer = CAShapeLayer()
    private var uncheckedLayer = CAShapeLayer()

    private(set) var isChecked: Bool = false

    func setIsChecked(_ value:Bool, animate:Bool = false) {
        isChecked = value
        checkedLayer.removeAllAnimations()
        checkmarkLayer.removeAllAnimations()

        if animate {
            animateStateChanges(isChecked: value)
        } else {
            updateAllLayers()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    override func prepareForInterfaceBuilder() {
        initialSetup()
    }

    override func awakeFromNib() {
        initialSetup()
    }

    private func initialSetup() {
        backgroundColor = UIColor.clear

        borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: edgeRadius)

        checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: bounds.minX + 0.15 * bounds.width, y: bounds.minY + 0.45 * bounds.height))
        checkMarkPath.addLine(to: CGPoint(x: bounds.minX + 0.4 * bounds.width, y: bounds.minY + 0.7 * bounds.height))
        checkMarkPath.addLine(to: CGPoint(x: bounds.minX + 0.85 * bounds.width, y: bounds.minY + 0.25 * bounds.height))

        layer.addSublayer(strokeLayer)
        layer.addSublayer(checkedLayer)
        layer.addSublayer(checkmarkLayer)
        layer.addSublayer(uncheckedLayer)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(gestureRecognizer)


        strokeLayer.path = borderPath.cgPath
        checkedLayer.path = borderPath.cgPath
        uncheckedLayer.path = borderPath.cgPath
        checkmarkLayer.path = checkMarkPath.cgPath
        checkmarkLayer.fillColor = UIColor.clear.cgColor

        updateAllLayers()
    }


    private func updateAllLayers() {
        CATransaction.begin()

        updateStrokeLayer()
        updateCheckedLayer()
        updateUncheckedLayer()
        updateCheckmarkLayer()

        CATransaction.commit()
    }

    private func updateStrokeLayer() {
        strokeLayer.strokeColor = isChecked ? UIColor.clear.cgColor : strokeColor.cgColor
        strokeLayer.lineWidth = strokeWidth
        strokeLayer.fillColor = UIColor.clear.cgColor
    }

    private func updateCheckedLayer() {
        let color = isChecked ? checkedBackgroundColor : UIColor.clear
        checkedLayer.fillColor = color.cgColor
        checkedLayer.path = borderPath.cgPath
    }

    private func updateUncheckedLayer() {
        uncheckedLayer.fillColor = isChecked ? UIColor.clear.cgColor : uncheckedBackgroundColor.cgColor
    }

    private func updateCheckmarkLayer() {
        checkmarkLayer.strokeColor = isChecked ? checkmarkColor.cgColor : UIColor.clear.cgColor
        checkmarkLayer.lineWidth = checkmarkWidth
        checkmarkLayer.path = checkMarkPath.cgPath
        checkmarkLayer.strokeStart = 0.0
        checkmarkLayer.strokeEnd = 1.0
    }


    private func animateStateChanges(isChecked: Bool) {
        CATransaction.begin()

        updateUncheckedLayer()
        updateStrokeLayer()

        checkedLayer.add(createCheckedFillAnimation(reversed: !isChecked), forKey: "body-animation")

        checkmarkLayer.strokeColor = checkmarkColor.cgColor
        checkmarkLayer.strokeEnd = 0.0
        checkmarkLayer.add(createCheckmarkAnimation(reversed: !isChecked), forKey: "checkmark-animation")

        CATransaction.commit()
    }


    private func createCheckedFillAnimation(reversed:Bool)-> CABasicAnimation {
        let startInnerRectPath = UIBezierPath(roundedRect: bounds, cornerRadius: edgeRadius)

        let endInnerRectOrigin = CGPoint(x: bounds.origin.x + bounds.width/2.0, y: bounds.origin.y + bounds.height/2.0)
        let endInnerRect = CGRect(origin: endInnerRectOrigin, size: CGSize(width: 0.0, height: 0.0))
        let endInnerRectPath = UIBezierPath(roundedRect: endInnerRect, cornerRadius: edgeRadius)

        let startPath = UIBezierPath(roundedRect: bounds, cornerRadius: edgeRadius)
        startPath.append(startInnerRectPath)

        let endPath = UIBezierPath(roundedRect: bounds, cornerRadius: edgeRadius)
        endPath.append(endInnerRectPath)

        checkedLayer.fillColor = checkedBackgroundColor.cgColor
        checkedLayer.fillRule = .evenOdd
        checkedLayer.path = reversed ? endPath.cgPath : startPath.cgPath

        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = reversed ? endPath.cgPath : startPath.cgPath
        animation.toValue = reversed ? startPath.cgPath : endPath.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }

    private func createCheckmarkAnimation(reversed: Bool) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.toValue = reversed ? 0.0 : 1.0
        animation.duration = 0.4
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }

    @objc
    private func handleTap(sender: UIGestureRecognizer) {
        setIsChecked(!isChecked, animate: true)
        onValueChanged?(isChecked)
        sendActions(for: .valueChanged)
    }
}
