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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func didRecivedValue(todo: Todo?) {
        self.taskNameLabel.text = todo?.name
        self.taskStatusLabel.attributedText = self.todo?.getDuteDate()
        if let todo = self.todo {
            self.crossOutView.isHidden = !todo.isCompleted
        }
        
        
    }
    
}
