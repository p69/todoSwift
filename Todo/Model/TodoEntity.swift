struct TodoEntity: Codable, Hashable {
  let id: String
  let task: String
  let note: String
  var complete: Bool
  
  init(id: String, task: String, note: String="", complete: Bool=false) {
    self.id = id
    self.task = task
    self.note = note
    self.complete = complete
  }
  
  mutating func switchCompletion() {
    self.complete = !self.complete
  }
  
  mutating func switchCompletion(to complete: Bool) {
    self.complete = complete
  }
}

extension TodoEntity: CustomStringConvertible, CustomDebugStringConvertible {
  var description: String {
    return "TodoEntity{complete: \(complete), task: \(task), note: \(note), id: \(id)}"
  }
  
  var debugDescription: String {
    return description
  }
}

extension TodoEntity: Equatable {
  static func == (left: TodoEntity, right: TodoEntity)->Bool {
    return left.id == right.id
  }
}
