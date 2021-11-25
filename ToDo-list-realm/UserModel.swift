import Foundation
import RealmSwift

class ToDoListItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
