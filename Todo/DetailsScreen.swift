import Foundation
import UIKit

class DetailsScreen : UIViewController {
  
  @IBOutlet weak var removeButton: UIBarButtonItem!
  @IBOutlet weak var todoItemView: TodoItemView!
  @IBOutlet weak var editButton: UIBarButtonItem!
  var todosController: TodosController!
  var todoId: String!
  var todo: TodoEntity {
    return todosController.todos.first(where: {$0.id==todoId})!
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    todoItemView.checkboxView.onValueChanged = { [weak self] _ in
      self?.todosController.onCompletionSwitched(todo: self!.todo)
    }
    removeButton.target = self
    removeButton.action = #selector(onRemoveTapped)
    editButton.target = self
    editButton.action = #selector(onEditTapped)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    todoItemView.titleView.text = todo.task
    todoItemView.subtitleView.text = todo.note
    todoItemView.checkboxView.setIsChecked(todo.complete)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == AppSegue.edit.rawValue,
      let editVC = segue.destination as? CreateOrEditScreen {
      editVC.todo = todo
      editVC.todosController = todosController
    }
  }
  
  @objc private func onRemoveTapped() {
    todosController.remove(todo: todo)
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func onEditTapped() {
    performSegue(withIdentifier: AppSegue.edit.rawValue, sender: nil)
  }
}
