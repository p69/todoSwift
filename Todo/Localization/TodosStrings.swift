enum TodosStrings: String, Localizable {
  case mainTitle = "Main title"
  case todosTab = "Todos tab"
  case statsTab = "Stats tab"
  case undoButton = "Undo button"
  case filterAll = "Filter: show all"
  case filterActive = "Filter: show active"
  case filterCompleted = "Filter: show completed"
  case actionMarkAllComplete = "Action: sark all complete"
  case actionMarkAllIncomplete = "Action: mark all incomplete"
  case actionCleareCompleted = "Action: cleare completed"
  case statsCompleted = "Stats: completed todos"
  case statsActive = "Stats: active todos"
  case detailsTitle = "Details title"
  case toolbarEdit = "Toolbar: edit"
  case toolbarRemove = "Toolbar: remove"
  case createNewTitle = "Create new title"
  case createNewDone = "Create: done button"
  case editTitle = "Edit title"
  case createNewTitlePlaceholder = "Create new title placeholder"
  case createNewNotesPlaceholder = "Create new notes placeholder"

  var fileName: String {
    return "Todos";
  }
}
