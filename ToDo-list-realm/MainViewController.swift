import UIKit
import RealmSwift

class MainViewController: UITableViewController{
    var realm: Realm!
    
    var toDoList: Results<ToDoListItem>{
        get {
            return realm.objects(ToDoListItem.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundImage = UIImage(named: "image.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.alpha = 0.3
        self.tableView.backgroundView = imageView
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = toDoList[indexPath.row]
        cell.textLabel!.text = item.name
        cell.backgroundColor = .clear
        cell.accessoryType = item.done == true ? .checkmark : .none // галочка
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = toDoList[indexPath.row]
        
        try! self.realm.write({
            item.done = !item.done
        })
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete) {
            let item = toDoList[indexPath.row]
            try! self.realm.write ({
                self.realm.delete(item)
            })
            tableView.deleteRows(at: [indexPath], with: .automatic)
          
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
    
      let alertVC = UIAlertController(title: "Новая задача🥰", message: "Что ты будешь делать?🧐", preferredStyle: .alert)
        alertVC.addTextField { (UITextField) in}
        
        let cancelAction = UIAlertAction.init(title: "Отменить😪", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Добавить😎", style: .default) { (UIAlertAction) -> Void in
            
            let todoItemTextField = (alertVC.textFields?.first)! as UITextField
            
            let newToDoListItem = ToDoListItem()
            newToDoListItem.name = todoItemTextField.text!
            newToDoListItem.done = false
            
            try! self.realm.write({
                self.realm.add(newToDoListItem)
                self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count - 1, section: 0)], with: .right)
            })
        }
        
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
}
