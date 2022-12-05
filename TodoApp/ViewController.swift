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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "TodoDetailsViewController") as! TodoDetailsViewController
        detailsViewController.todo = item
        self.navigationController?.pushViewController(detailsViewController, animated: true)
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
}

