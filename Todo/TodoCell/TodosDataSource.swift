import Foundation
import UIKit

protocol TodoCellInteractorDelegate {
  func onCompletionSwitched(todo: TodoEntity)
  func onTodoTapped(todo: TodoEntity)
  func onTodoRemoved(todo: TodoEntity)
}

class TodosDataSource: NSObject {
  let interactionDelegate: TodoCellInteractorDelegate
  let provider: TodosProvider

  init(interactionDelegate: TodoCellInteractorDelegate, todosProvider: TodosProvider) {
    self.interactionDelegate = interactionDelegate
    self.provider = todosProvider
  }

  var todos: [TodoEntity] {
    return provider.filtered(by: filter)
  }

  var filter: Filter = .all
}


extension TodosDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodoCell.self)) as! TodoCell
    let todo = todos[indexPath.row]

    cell.task = todo.task
    cell.note = todo.note
    cell.complete = todo.complete
    cell.todoItemView.checkboxView.onValueChanged = { [weak self] _ in
      self?.interactionDelegate.onCompletionSwitched(todo: self!.todos[indexPath.row])
    }
    cell.todoItemView.tappedHandler = { [weak self] in
      self?.interactionDelegate.onTodoTapped(todo: self!.todos[indexPath.row])
    }
    return cell
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      interactionDelegate.onTodoRemoved(todo: todos[indexPath.row])
      tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
      tableView.reloadData()
    }
  }
}
