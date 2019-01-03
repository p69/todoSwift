import Foundation
import Dispatch
import then

protocol TodosRepository {
  func getTodos() throws -> [TodoEntity]
  func saveTodos(todos:[TodoEntity]) throws
}

protocol TodosRepositoryAsync {
  func getTodosAsync() -> Promise<[TodoEntity]>
  func saveTodosAsync(todos: [TodoEntity]) -> Promise<Void>
}

class FileRepository : TodosRepository, TodosRepositoryAsync {
  private let fileName = "todos.json"

  func getTodos() throws -> [TodoEntity] {
    let fileUrl = getFileURL()

    if !FileManager.default.fileExists(atPath: fileUrl.path) {
      let stub = todosStub()
      let data = try JSONEncoder().encode(stub)
      try data.write(to: fileUrl)
    }

    if let content = FileManager.default.contents(atPath: fileUrl.path) {
      let result = try JSONDecoder().decode([TodoEntity].self, from: content)
      return result
    }

    return []
  }

  func saveTodos(todos: [TodoEntity]) throws {
    let json = try JSONEncoder().encode(todos)
    try json.write(to: getFileURL())
  }

  func getTodosAsync() -> Promise<[TodoEntity]> {
    let p = Promise<[TodoEntity]> { [weak self] resolve, reject in
      io {
        do {
          let todos = try self!.getTodos()
          ui {
            resolve(todos)
          }
        } catch {
          ui {
            reject(error)
          }
        }
      }
    }
    p.start()
    return p
  }

  func saveTodosAsync(todos: [TodoEntity]) -> Promise<Void> {
    let p = Promise { [weak self] resolve, reject in
      io {
        do {
          try self!.saveTodos(todos: todos)
          ui {
            resolve()
          }
        } catch {
          ui {
            reject(error)
          }
        }
      }
    }
    p.start()
    return p
  }

  private func getFileURL()->URL {
    return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
  }
}

fileprivate func todosStub()->[TodoEntity] {
  return [
    TodoEntity(id: "1", task: "Buy food for da kitty", note: "With the chickeny bits!"),
    TodoEntity(id: "2", task: "Find a Red Sea dive trip", note: "Echo vs MY Dream"),
    TodoEntity(id: "3", task: "Book flights to Egypt", complete: true),
    TodoEntity(id: "4", task: "Decide on accommodation"),
    TodoEntity(id: "5", task: "Sip Margaritas", note: "on the beach", complete: true)
  ]
}
