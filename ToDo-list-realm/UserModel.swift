import Foundation
import RealmSwift



/// Модель данных(Realm)
@objcMembers
class ToDoListItem: Object {
     dynamic var name = ""
     dynamic var done = false
}
