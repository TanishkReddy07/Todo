//
//  TodoDetailsViewController.swift
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

enum TodoAction {
    case create
    case update
    case delete
    case cancel
    
    var alerMessage: String {
        switch self {
        case .create:
            return "Do you want to save as new Todo?"
        case .update:
            return "Do you want to save the changes?"
        case .delete:
            return "Do you want to delete this Todo?"
        case .cancel:
            return "This will discard all the current changes, Do you wish to continue"
        }
    }
}

class TodoDetailsViewController: UIViewController {
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var hasDueSwitch: UISwitch!
    @IBOutlet weak var todoDetailTextView: UITextView!
    @IBOutlet weak var todoNameTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveOrUpdateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var container: UIView!
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if todo == nil {
            todoNameTextField.delegate = self
        }
        
        setUpView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        didRecivedValue(todo: todo)
    }

    func setUpView() {
        
            self.deleteButton.isEnabled = todo == nil ? false : true
            self.cancelButton.isEnabled = todo == nil ? false : true
        self.container.isHidden = todo == nil ? true : false
        todoDetailTextView.layer.borderWidth = 0.5
        todoDetailTextView.layer.borderColor = UIColor.black.cgColor
        todoDetailTextView.layer.shadowRadius = 7
        todoDetailTextView.layer.cornerRadius = 10
        
        actionContainer.layer.shadowColor = UIColor.black.cgColor
        actionContainer.layer.shadowOpacity = 0.15
        actionContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        actionContainer.layer.shadowRadius = 7
        actionContainer.layer.cornerRadius = 10
    }
    
    private func didRecivedValue(todo: Todo?) {
        self.todoNameTextField.text = todo?.name
        self.todoDetailTextView.text = todo?.notes
        if let dueDate = todo?.dueDate {
            self.dueDatePicker.date = dueDate
        }
        if let hasDueDate = todo?.hasDueDate {
            self.hasDueSwitch.isOn = hasDueDate
            if hasDueDate {
                self.dueDatePicker.isEnabled = true
            } else {
                self.dueDatePicker.isEnabled = false
            }
        }
        if let isCompleted = todo?.isCompleted {
            self.isCompletedSwitch.isOn = isCompleted
        }
        
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        showAlert(type: .update, completion: {
            Task.init {
                if let todo = self.todo {
                    let updatedTodo = try await ToDoRepository.shared.updateTodo(name: self.todoNameTextField.text ?? "", hasDueDate: self.hasDueSwitch.isOn, isCompleted: self.isCompletedSwitch.isOn, dueDate: self.dueDatePicker.date, notes: self.todoDetailTextView.text, object: todo)
                    print(updatedTodo?.name)
                } else {
                    let addedTodo = await ToDoRepository.shared.addTodo(name: self.todoNameTextField.text ?? "", hasDueDate: self.hasDueSwitch.isOn, isCompleted: self.isCompletedSwitch.isOn, dueDate: self.dueDatePicker.date, notes: self.todoDetailTextView.text)
                    print(addedTodo.name)
                }
                
                }
            self.navigationController?.popViewController(animated: true)
        })
        
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        showAlert(type: .cancel, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        showAlert(type: .delete, completion: {
            Task.init {
                if let todo = self.todo {
                    let _ = try await ToDoRepository.shared.deleteTodo(object: todo)
                }
                
            }
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    func showAlert(type: TodoAction, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: "Alert", message: type.alerMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                completion()
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func hasDueDateChanged(_ sender: Any) {
        if hasDueSwitch.isOn {
            self.dueDatePicker.isEnabled = true
        } else {
            self.dueDatePicker.isEnabled = false
        }
    }
}

extension TodoDetailsViewController: UITextFieldDelegate {

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            self.container.isHidden = false
        } else {
            self.container.isHidden = true
        }
    }
}
