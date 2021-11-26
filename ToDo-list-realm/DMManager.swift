//MARK: - Отложено

import Foundation
import RealmSwift


// Отложено
protocol DataManager{
    func save(object: Object)
}

// Отложено
class ManagerRealm: DataManager{
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration, queue: .main)

    func save(object: Object) {
        try! mainRealm.write({
            mainRealm.add(object)
        })
    }
}
