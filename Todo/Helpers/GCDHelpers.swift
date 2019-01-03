import Dispatch

func io(body: @escaping ()->()) {
    DispatchQueue.global(qos: .utility).async {
        body()
    }
}

func ui(body: @escaping ()->()) {
    DispatchQueue.main.async {
        body()
    }
}
