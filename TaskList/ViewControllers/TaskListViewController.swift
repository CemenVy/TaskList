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
    private var taskList: [TodoTask] = []
    private let cellID = "task"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    @objc private func addNewTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.delegate = self
        present(newTaskVC, animated: true)
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
}

// MARK: - NewTaskViewControllerDelegate
extension TaskListViewController: NewTaskViewControllerDelegate {
    func reloadData() {
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

