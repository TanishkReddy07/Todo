//
//  TodoTableViewCell.swift
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

class TodoTableViewCell: UITableViewCell {
    
    var didClickEdit: ((_ item: Todo) -> Void)?

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var crossOutView: UIView!
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    var todo: Todo? {
        didSet {
            self.didRecivedValue(todo: todo)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.15
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 7
        container.layer.cornerRadius = 10
        
        crossOutView.isHidden = !isCompletedSwitch.isOn
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func didRecivedValue(todo: Todo?) {
        self.taskNameLabel.text = todo?.name
        self.taskStatusLabel.attributedText = self.todo?.getDuteDate()
        if let todo = self.todo {
            self.isCompletedSwitch.isOn = todo.isCompleted
            self.crossOutView.isHidden = !todo.isCompleted
        }
        
        
    }
    
    @IBAction func isCompletedSwitchChanged(_ sender: Any) {
        crossOutView.isHidden = !isCompletedSwitch.isOn
        
        Task.init {
            let _ = try await ToDoRepository.shared.updateTodo(name: self.todo!.name, hasDueDate: self.todo!.hasDueDate, isCompleted: isCompletedSwitch.isOn, dueDate: self.todo!.dueDate, notes: self.todo!.notes, object: self.todo!)
        }
        
    }
    @IBAction func editButtonClicked(_ sender: Any) {
        if let todo = self.todo {
            self.didClickEdit?(todo)
        }
        
    }
}
