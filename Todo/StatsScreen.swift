import UIKit
import PopMenu

class StatsScreen: UIViewController {

    @IBOutlet weak var completedTodosLabel: UILabel!
    @IBOutlet weak var activeTodosLabel: UILabel!
    @IBOutlet weak var moreButton: UIBarButtonItem!

    var todosController: TodosController {
        return (tabBarController as! MainScreen).todosController
    }

    private var moreMenu: PopMenuViewController!

    private lazy var markAllCompleteAction = PopMenuDefaultAction(title: TodosStrings.actionMarkAllComplete.localized, didSelect: { [unowned self] (_) in self.switchAllCompletion(to: true) })

    private lazy var markAllIncompleteAction = PopMenuDefaultAction(title: TodosStrings.actionMarkAllIncomplete.localized, didSelect: { [unowned self] (_) in self.switchAllCompletion(to: false) })

    private lazy var cleareCompletedAction = PopMenuDefaultAction(title: TodosStrings.actionCleareCompleted.localized, didSelect: { [unowned self] (_) in self.cleareCompleted() })


    override func viewDidLoad() {
        super.viewDidLoad()
        moreButton.target = self
        moreButton.action = #selector(onMoreButtonTapped)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
        updateMoreActions()
    }

    private func updateStats() {
        let completedCount = todosController.filtered(by: Filter.completed).count
        let activeCount = todosController.todos.count - completedCount
        completedTodosLabel.text = String(completedCount)
        activeTodosLabel.text = String(activeCount)
    }

    private func switchAllCompletion(to complete: Bool) {
        todosController.switchAllCompletion(to: complete)
        updateStats()
        updateMoreActions()
    }

    private func cleareCompleted() {
        todosController.removeCompleted()
        updateStats()
        updateMoreActions()
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

    @objc private func onMoreButtonTapped() {
        present(moreMenu, animated: true)
    }
}

