//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Луиза Самойленко on 26.03.2023.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categories: [Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchBar = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
        cofigureNavigationBar()
        loadCategories()
    }

    // -MARK: -TableView Data Sourse methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    // -MARK: -Data Manipulation methods
    private func saveCategories() {
        do {
            try context.save()
        }  catch {
            print("error: \(error)")
        }
        tableView.reloadData()
    }

    private func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        tableView.reloadData()
    }

    // -MARK: -TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemVC = ToDoListTableViewController()
        itemVC.selectedCategory = categories[indexPath.row]
        show(itemVC, sender: self)
    }
}

extension CategoryTableViewController {
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.searchBar.delegate = self
        navigationItem.searchController = searchBar
        searchBar.searchBar.placeholder = "Search"
    }
    
    private func cofigureNavigationBar() {
        title = "ToDoey"
        let addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(clickButton))
        addBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem  = addBarButtonItem
    }

    private func configureTableView() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
    }

    // -MARK: -Add New Categories
    @objc private func clickButton() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action  in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"

        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CategoryTableViewController: UISearchControllerDelegate, UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] % @", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadCategories(with: request)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
