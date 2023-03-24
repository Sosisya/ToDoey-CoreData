//
//  ToDoListTableViewController.swift
//  ToDoey
//
//  Created by Луиза Самойленко on 23.03.2023.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        configureTableView()
        cofigureNavigationBar()

        var item = Item()
        item.title = "Find Mike"
        itemArray.append(item)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemTableViewCell", for: indexPath) as! ToDoItemTableViewCell
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    private func configureTableView() {
        tableView.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: "ToDoItemTableViewCell")
    }

    private func cofigureNavigationBar() {
        let addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(clickButton))
        addBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem  = addBarButtonItem
    }

    @objc private func clickButton(){
        let alert = UIAlertController(title: "Add item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {_ in
            print("add")
        }
            alert.addAction(action)
            alert.addTextField { textField in
                textField.placeholder = "Add a task"
            }
        self.present(alert, animated: true, completion: nil)
    }
}
