//
//  SettingsViewController.swift
//  Netflix Clone
//
//  Created by Suguru on 10/26/22.
//

import UIKit

enum SettingOption: String {
    case account = "Account"
    case appearance = "Appearance"
    case developer = "Developer"
}

class SettingsViewController: UIViewController {

   private let settingsOptions: [SettingOption] = [.account, .appearance, .developer]
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        settingsTable.delegate = self
        settingsTable.dataSource = self
        
        view.largeContentTitle = "Settings"
        view.addSubview(settingsTable)
        
        configureNavbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTable.frame = view.bounds
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(handleDismissButtonTapped))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func handleDismissButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        let title = self.settingsOptions[indexPath.row]
        cell.configure(with: title.rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(settingsOptions[indexPath.row])
    }
}
