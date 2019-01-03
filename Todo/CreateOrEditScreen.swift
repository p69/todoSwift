import Foundation
import UIKit

class CreateOrEditScreen : UIViewController {

    fileprivate let placeholderColor = UIColor.white.withAlphaComponent(0.6)
    fileprivate let mainTextColor = UIColor(named: AppColors.mainTextColor.rawValue)
    fileprivate let notesPlaceholderText = TodosStrings.createNewNotesPlaceholder.localized
    fileprivate let taskPlaceholderText = TodosStrings.createNewTitlePlaceholder.localized

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var taskEditText: UITextField!
    @IBOutlet weak var noteEditText: UITextView!

    var todo: TodoEntity?
    var todosController: TodosController!

    fileprivate var noteText: String? {
        return noteEditText.textColor?.isEqual(placeholderColor) ?? false ? nil : noteEditText.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.target = self
        doneButton.action = #selector(onDoneTapped)
        noteEditText.delegate = self
        taskEditText.attributedPlaceholder = NSAttributedString(string: taskPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])

        if let editTodo = todo {
            taskEditText.text = editTodo.task
            if editTodo.note.isEmpty {
                noteEditText.textColor = placeholderColor
                noteEditText.text = notesPlaceholderText
            } else {
                noteEditText.text = editTodo.note
                noteEditText.textColor = mainTextColor
            }
        } else {
            noteEditText.text = notesPlaceholderText
            noteEditText.textColor = placeholderColor
        }

    }

    @objc private func onDoneTapped() {
        if let task = taskEditText.text {
            if let editTodo = todo {
                let updated = TodoEntity(id: editTodo.id, task: task, note: noteText ?? "", complete: editTodo.complete)
                todosController.update(todo: updated)
            } else {
                let todo = TodoEntity(id: String(describing: UUID()), task: task, note: noteText ?? "")
                todosController.addNew(todo: todo)
            }
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CreateOrEditScreen: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor?.isEqual(placeholderColor) ?? false {
            textView.text = nil
            textView.textColor = mainTextColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = notesPlaceholderText
            textView.textColor = placeholderColor
        }
    }
}
