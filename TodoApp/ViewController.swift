//
//  ViewController.swift
//  TodoApp
//
//  An app for creating todo list
//
//  Created by Group-7
//  Tanishk Sai Reddy Peruvala-301293616
//  Jashandeep Kaur Sidhu-301293237
//  Pujan Prasai-301290876
//  on 2022-11-09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [Todo]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Todo List"
        getTodoList()
    }
    
    // get todos from repository
    func getTodoList()  {
        async {
            do {
                let list = try await ToDoRepository.shared.getToDoList()
                self.todoList = list
                self.tableView.reloadData()
            } catch {
            }
        }
        
    }
    
    
    @objc func addTapped() {
        goToDetails(item: nil)
    }
    
    // handle navigation to details screen
    func goToDetails(item: Todo?) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "TodoDetailsViewController") as! TodoDetailsViewController
        detailsViewController.todo = item
        self.navigationController?.pushViewController(detailsViewController, animated: false)
    }
    
    //toggle todo complete
    func toggleTodoComplete(row: Int) {
        Task.init {
            let toDo = self.todoList[row]
                let _ = try await ToDoRepository.shared.updateTodo(name: toDo.name, hasDueDate: toDo.hasDueDate, isCompleted: !toDo.isCompleted, dueDate: toDo.dueDate, notes: toDo.notes, object: toDo)
            getTodoList()
            
            
        }
    }
    
    //delete Todo
    func deleteTodo(row: Int) {
        Task.init {
            let toDo = self.todoList[row]
                let _ = try await ToDoRepository.shared.deleteTodo(object: toDo)
            getTodoList()
            
            
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        cell.didClickEdit = self.goToDetails
        cell.todo = self.todoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    // left swipe action
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // left swipe to toggle complete
        let toggleComplete = UIContextualAction(style: .destructive,
                                       title: "toggleComplete") { [weak self] (action, view, completionHandler) in
            self?.toggleTodoComplete(row: indexPath.row)
            
            
        }
        toggleComplete.backgroundColor = .yellow
        
        
        // left long swipe to delete
        let longSwipeToDelete = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            print("Delete")
            self?.deleteTodo(row: indexPath.row)
            
        }
        longSwipeToDelete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [longSwipeToDelete,toggleComplete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let details = UIContextualAction(style: .destructive,
                                       title: "Details") { [weak self] (action, view, completionHandler) in
            self?.goToDetails(item: self?.todoList[indexPath.row])
            completionHandler(true)
        }
        details.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [details])
    }
    
    
}

