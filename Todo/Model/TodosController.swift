import Foundation
import then

enum Filter {
  case all, completed, active
}

protocol TodosProvider {
  var todos: [TodoEntity] { get }
  func filtered(by filter: Filter) -> [TodoEntity]
}

class TodosController: TodosProvider {
  let repo: TodosRepositoryAsync
  private var cache: [TodoEntity] = []

  var todos: [TodoEntity] {
    return cache
  }

  init() {
    repo = FileRepository()
  }

  func reloadTodos()->Promise<[TodoEntity]> {
    return repo.getTodosAsync()
      .chain { [weak self] todos in self?.cache = todos }
  }

  func onCompletionSwitched(todo: TodoEntity) {
    if let index = cache.index(of: todo) {
      cache[index].switchCompletion()
      repo.saveTodosAsync(todos: cache).start()
    }
  }

  func remove(todo: TodoEntity) {
    if let index = cache.index(of: todo) {
      cache.remove(at: index)
      repo.saveTodosAsync(todos: cache).start()
    }
  }

  func filtered(by filter: Filter)->[TodoEntity] {
    return cache.filter {todo in isSatisfied(todo, by: filter)}
  }

  func switchAllCompletion(to complete:Bool) {
    for index in cache.indices {
      cache[index].switchCompletion(to: complete)
    }
    repo.saveTodosAsync(todos: cache).start()
  }

  func removeCompleted() {
    cache = cache.filter { !$0.complete }
    repo.saveTodosAsync(todos: cache).start()
  }
  
  func addNew(todo: TodoEntity) {
    cache.append(todo)
    repo.saveTodosAsync(todos: cache).start()
  }

  func update(todo: TodoEntity) {
    if let index = cache.index(of: todo) {
      cache[index] = todo
      repo.saveTodosAsync(todos: cache).start()
    }
  }

  fileprivate func isSatisfied(_ todo: TodoEntity, by filter: Filter) -> Bool {
    switch filter {
    case .all:
      return true
    case .active:
      return !todo.complete
    case .completed:
      return todo.complete
    }
  }

}
