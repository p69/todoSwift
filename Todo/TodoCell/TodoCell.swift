import Foundation
import UIKit

class TodoCell: UITableViewCell {

  @IBOutlet weak var todoItemView: TodoItemView!

  var task: String? {
    didSet {
      todoItemView.titleView.text = task
    }
  }

  var note: String? {
    didSet {
      todoItemView.subtitleView.text = note
    }
  }

  var complete: Bool? {
    didSet {
      todoItemView.checkboxView.setIsChecked(complete ?? false)
    }
  }
}
