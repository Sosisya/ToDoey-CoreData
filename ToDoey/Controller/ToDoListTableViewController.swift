//
//  ToDoListTableViewController.swift
//  ToDoey
//
//  Created by Луиза Самойленко on 23.03.2023.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let searchBar = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        configureSearchBar()
        configureTableView()
        cofigureNavigationBar()
        loadItems()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemTableViewCell", for: indexPath) as! ToDoItemTableViewCell
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.searchBar.delegate = self
        navigationItem.searchController = searchBar
        searchBar.searchBar.placeholder = "Search"
    }
    private func configureTableView() {
        tableView.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: "ToDoItemTableViewCell")
    }

    private func cofigureNavigationBar() {
        title = "ToDoey"
        let addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(clickButton))
        addBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem  = addBarButtonItem
    }

    @objc private func clickButton() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action  in

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()

        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func saveItems() {
        do {
            try context.save()
        }  catch {
            print("error: \(error)")
        }
        tableView.reloadData()
    }

    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        tableView.reloadData()
    }
}

// - MARK: - Search bar methods
extension ToDoListTableViewController:  UISearchControllerDelegate, UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] % @", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
}

