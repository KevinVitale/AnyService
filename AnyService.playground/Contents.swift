import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let service: AnyService = "https://jsonplaceholder.typicode.com"

let task = try service.fetch(endpoint: "users", "1") { request in
    do {
        print("\(try request().0)")
    } catch {
        print("\(error)")
    }
    PlaygroundPage.current.finishExecution()
}

task.resume()
