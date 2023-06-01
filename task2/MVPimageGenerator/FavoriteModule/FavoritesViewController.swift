//
//  FavoritesViewController.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//


import UIKit

protocol FavoritesViewInput: AnyObject {}

class FavoritesViewController: UIViewController, FavoritesViewInput {

    var presenter: FavoritesViewOutput?
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
            self.tableView.reloadData()
    }

    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = AccessibilityIdentifier.tableview
        view.addSubview(tableView)
    }
}


extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getFavoritesCount() ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let favorite = presenter?.getFavorite(at: indexPath.row)
        cell.imageView?.image = favorite?.image
        cell.textLabel?.text = favorite?.query
        return cell
    }

}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.removeFavorite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


