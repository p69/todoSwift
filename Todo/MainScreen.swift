import Foundation
import UIKit

class MainScreen: UITabBarController {
  lazy var todosController = TodosController()
  lazy var removeUndoManager = UndoManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
