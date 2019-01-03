import Foundation
import UIKit

class TodoItemView: UIView {

  @IBOutlet var contentView: UIView!
  @IBOutlet weak var checkboxView: Checkbox!
  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var subtitleView: UILabel!

  var tappedHandler: (()->())?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.doInit()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.doInit()
  }

  private func doInit() {
    let loadedNib = Bundle.main.loadNibNamed("TodoItemView", owner: self, options: nil)?[0]
    guard let view = loadedNib as? UIView else {return}

    view.frame = self.bounds
    self.addSubview(view)
    contentView = view

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapped))
    self.addGestureRecognizer(gestureRecognizer)
  }

  @objc private func onTapped(sender: UIGestureRecognizer) {
    tappedHandler?()
  }
}
