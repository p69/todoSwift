import UIKit
import then
import PopMenu

class TodosScreen: UIViewController, TodoCellInteractorDelegate {
  @IBOutlet weak var filterButton: UIBarButtonItem!
  @IBOutlet weak var todosTableView: UITableView!
  @IBOutlet weak var moreButton: UIBarButtonItem!
  @IBOutlet weak var createTodoButton: UIBarButtonItem!
  @IBOutlet weak var undoButton: UIBarButtonItem!

  var todosController: TodosController {
    return (tabBarController as! MainScreen).todosController
  }
  var removeUndoManager: UndoManager {
    return (tabBarController as! MainScreen).removeUndoManager
  }
  lazy var tableDataSource: TodosDataSource = TodosDataSource(interactionDelegate: self, todosProvider: todosController)
  var filterMenu: PopMenuViewController!
  var moreMenu: PopMenuViewController!

  private lazy var filterActions = [
    PopMenuDefaultAction(title: TodosStrings.filterAll.localized, didSelect: { [unowned self] (_) in self.onFilterChanged(filter: Filter.all) }),
    PopMenuDefaultAction(title: TodosStrings.filterActive.localized, didSelect: { [unowned self] (_) in self.onFilterChanged(filter: Filter.active) }),
    PopMenuDefaultAction(title: TodosStrings.filterCompleted.localized, didSelect: { [unowned self] (_) in self.onFilterChanged(filter: Filter.completed) })
  ]

  private lazy var markAllCompleteAction = PopMenuDefaultAction(title: TodosStrings.actionMarkAllComplete.localized, didSelect: { [unowned self] (_) in self.switchAllCompletion(to: true) })

  private lazy var markAllIncompleteAction = PopMenuDefaultAction(title: TodosStrings.actionMarkAllIncomplete.localized, didSelect: { [unowned self] (_) in self.switchAllCompletion(to: false) })

  private lazy var cleareCompletedAction = PopMenuDefaultAction(title: TodosStrings.actionCleareCompleted.localized, didSelect: { [unowned self] (_) in self.cleareCompleted() })

  private var todoForDetails: TodoEntity?

  override func viewDidLoad() {
    super.viewDidLoad()
    prepareTableView()
    preparePopMenus()
    filterButton.target = self
    filterButton.action = #selector(onFilterTapped)
    moreButton.target = self
    moreButton.action = #selector(onMoreTapped)
    createTodoButton.target = self
    createTodoButton.action = #selector(onCreateTodoTapped)
    undoButton.isEnabled = false
    undoButton.target = self
    undoButton.action = #selector(onUndoTapped)

    todosController.reloadTodos()
      .then { [weak self] items in
        self?.todosTableView.reloadData()
        self?.updateMoreActions()
      }
      .onError { err in debugPrint("Error while loading todos", err) }
  }

  private func prepareTableView() {
    todosTableView.estimatedRowHeight = 60
    todosTableView.rowHeight = UITableView.automaticDimension
    todosTableView.dataSource = tableDataSource
  }


  private func preparePopMenus() {
    filterMenu = PopMenuViewController(sourceView: filterButton, actions: filterActions)
    moreMenu = PopMenuViewController(sourceView: moreButton, actions: [cleareCompletedAction])
  }

  private func updateMoreActions() {
    if todosController.todos.count == 0 {
      moreMenu = PopMenuViewController(sourceView: moreButton, actions: [cleareCompletedAction])
    } else if todosController.todos.allSatisfy({ $0.complete }) {
      moreMenu = PopMenuViewController(sourceView: moreButton, actions: [markAllIncompleteAction, cleareCompletedAction])
    } else {
      moreMenu = PopMenuViewController(sourceView: moreButton, actions: [markAllCompleteAction, cleareCompletedAction])
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    todosTableView.reloadData()
    updateMoreActions()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == AppSegue.todoDetails.rawValue, let details = segue.destination as? DetailsScreen, let todo = todoForDetails {
      details.todoId = todo.id
      details.todosController = todosController
    } else if segue.identifier == AppSegue.createNew.rawValue, let createOrEdit = segue.destination as? CreateOrEditScreen {
      createOrEdit.todosController = todosController
    }
  }

  func onTodoTapped(todo: TodoEntity) {
    todoForDetails = todo
    performSegue(withIdentifier: AppSegue.todoDetails.rawValue, sender: nil)
  }

  func onCompletionSwitched(todo: TodoEntity) {
    todosController.onCompletionSwitched(todo: todo)
    updateMoreActions()
  }

  private func onFilterChanged(filter: Filter) {
    tableDataSource.filter = filter
    todosTableView.reloadData()
  }

  func onTodoRemoved(todo: TodoEntity) {
    todosController.remove(todo: todo)
    removeUndoManager.registerUndo(withTarget: self) {this in
      this.todosController.addNew(todo: todo)
      this.todosTableView.reloadData()
      this.updateMoreActions()
    }
    undoButton.isEnabled = removeUndoManager.canUndo
  }

  @objc private func onFilterTapped() {
    present(filterMenu, animated: true)
  }

  @objc private func onMoreTapped() {
    present(moreMenu, animated: true)
  }

  @objc private func onCreateTodoTapped() {
    performSegue(withIdentifier: AppSegue.createNew.rawValue, sender: nil)
  }

  @objc private func onUndoTapped() {
    removeUndoManager.undo()
    undoButton.isEnabled = removeUndoManager.canUndo
  }

  private func switchAllCompletion(to complete: Bool) {
    todosController.switchAllCompletion(to: complete)
    todosTableView.reloadData()
    updateMoreActions()
  }

  private func cleareCompleted() {
    todosController.removeCompleted()
    todosTableView.reloadData()
  }
}
