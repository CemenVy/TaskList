//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Семен Выдрин on 26.09.2023.
//

import UIKit

protocol NewTaskViewControllerDelegate: AnyObject {
    func reloadData()
}

final class TaskListViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var taskList: [TodoTask] = []
    private let cellID = "task"
    
    private let storageManager = StorageManager.shared
    
    // MARK: - Life View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        taskList = storageManager.fetchData()
        setupNavigationBar()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deletTask(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        showAlert(for: task, andMessage: "What do you want to do?")
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
         let cell = tableView.cellForRow(at: indexPath)
         cell?.contentView.backgroundColor = .lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
     }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .white
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Private Methods
    @objc private func addNewTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.delegate = self
        present(newTaskVC, animated: true)
    }
    
    private func showAlert(for task: TodoTask, andMessage message: String) {
        let alert = UIAlertController(title: task.title, message: message, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "Update task", style: .default) { [unowned self] _ in
            guard let newTitle = alert.textFields?.first?.text, !newTitle.isEmpty else { return }
            self.storageManager.update(task: task, newTitle: newTitle)
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Update Task"
        }
        present(alert, animated: true)
    }
}

    // MARK: - NewTaskViewControllerDelegate
extension TaskListViewController: NewTaskViewControllerDelegate {
    func reloadData() {
        taskList = storageManager.fetchData()
        tableView.reloadData()
    }
}

    // MARK: - SetupUI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let NavBarAppearance = UINavigationBarAppearance()
        NavBarAppearance.backgroundColor = UIColor.blue
        
        NavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        NavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = NavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = NavBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}

