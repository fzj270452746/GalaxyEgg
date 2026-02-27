//
//  GalaxyEggCodexViewController.swift
//  GalaxyEgg
//
//  Created by Assistant on 10/10/25.
//

import UIKit

class GalaxyEggCodexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let GalaxyEggEngine: GalaxyEggSpinEngine
    private let GalaxyEggBackgroundView = GalaxyEggGradientBackgroundView()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggTableView = UITableView(frame: .zero, style: .insetGrouped)
    private let GalaxyEggCloseButton = GalaxyEggButtonView()
    private var GalaxyEggEntries: [GalaxyEggSpaceElementModel] = []
    
    init(engine GalaxyEggEngine: GalaxyEggSpinEngine) {
        self.GalaxyEggEngine = GalaxyEggEngine
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GalaxyEggConfigureLayout()
        GalaxyEggConfigureContent()
        GalaxyEggReloadEntries()
    }
    
    private func GalaxyEggConfigureLayout() {
        view.addSubview(GalaxyEggBackgroundView)
        GalaxyEggBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            GalaxyEggBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GalaxyEggBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GalaxyEggBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            GalaxyEggBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        GalaxyEggCloseButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCloseButton.GalaxyEggContentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        view.addSubview(GalaxyEggCloseButton)

        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(GalaxyEggTitleLabel)

        GalaxyEggTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(GalaxyEggTableView)

        NSLayoutConstraint.activate([
            GalaxyEggCloseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            GalaxyEggCloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            GalaxyEggCloseButton.heightAnchor.constraint(equalToConstant: 44),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            GalaxyEggTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            GalaxyEggTableView.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 20),
            GalaxyEggTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GalaxyEggTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GalaxyEggTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func GalaxyEggConfigureContent() {
        GalaxyEggTitleLabel.text = "Galaxy Encyclopedia"
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        GalaxyEggTitleLabel.textColor = .white
        
        GalaxyEggTableView.dataSource = self
        GalaxyEggTableView.delegate = self
        GalaxyEggTableView.backgroundColor = .clear
        GalaxyEggTableView.separatorStyle = .none
        GalaxyEggTableView.register(GalaxyEggCodexCell.self, forCellReuseIdentifier: GalaxyEggCodexCell.GalaxyEggReuseIdentifier)
        
        GalaxyEggCloseButton.GalaxyEggSetTitle("◀︎ Back")
        GalaxyEggCloseButton.addTarget(self, action: #selector(GalaxyEggHandleClose), for: .touchUpInside)
    }
    
    private func GalaxyEggReloadEntries() {
        GalaxyEggEntries = GalaxyEggEngine.GalaxyEggUnlockedElements()
        GalaxyEggTableView.reloadData()
    }
    
    @objc private func GalaxyEggHandleClose() {
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ GalaxyEggTableView: UITableView, numberOfRowsInSection GalaxyEggSection: Int) -> Int {
        max(1, GalaxyEggEntries.count)
    }
    
    func tableView(_ GalaxyEggTableView: UITableView, cellForRowAt GalaxyEggIndexPath: IndexPath) -> UITableViewCell {
        guard !GalaxyEggEntries.isEmpty else {
            let GalaxyEggEmptyCell = UITableViewCell(style: .subtitle, reuseIdentifier: "GalaxyEggEmptyCell")
            GalaxyEggEmptyCell.backgroundColor = UIColor(white: 1, alpha: 0.08)
            GalaxyEggEmptyCell.textLabel?.text = "No discoveries yet."
            GalaxyEggEmptyCell.textLabel?.textColor = .white
            GalaxyEggEmptyCell.detailTextLabel?.text = "Spin the slots to forge new entries."
            GalaxyEggEmptyCell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
            GalaxyEggEmptyCell.selectionStyle = .none
            GalaxyEggEmptyCell.layer.cornerRadius = 16
            GalaxyEggEmptyCell.layer.masksToBounds = true
            return GalaxyEggEmptyCell
        }
        
        guard let GalaxyEggCell = GalaxyEggTableView.dequeueReusableCell(withIdentifier: GalaxyEggCodexCell.GalaxyEggReuseIdentifier, for: GalaxyEggIndexPath) as? GalaxyEggCodexCell else {
            return UITableViewCell()
        }
        GalaxyEggCell.GalaxyEggConfigure(with: GalaxyEggEntries[GalaxyEggIndexPath.row])
        return GalaxyEggCell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ GalaxyEggTableView: UITableView, heightForRowAt GalaxyEggIndexPath: IndexPath) -> CGFloat {
        96
    }
}

class GalaxyEggCodexCell: UITableViewCell {
    static let GalaxyEggReuseIdentifier = "GalaxyEggCodexCell"
    
    private let GalaxyEggContainer = UIView()
    private let GalaxyEggSymbolLabel = UILabel()
    private let GalaxyEggNameLabel = UILabel()
    private let GalaxyEggDetailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        GalaxyEggConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }
    
    private func GalaxyEggConfigure() {
        selectionStyle = .none
        backgroundColor = .clear
        
        GalaxyEggContainer.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggContainer.backgroundColor = UIColor(white: 1, alpha: 0.08)
        GalaxyEggContainer.layer.cornerRadius = 20
        GalaxyEggContainer.layer.borderWidth = 1
        GalaxyEggContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        contentView.addSubview(GalaxyEggContainer)
        
        GalaxyEggSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSymbolLabel.font = UIFont.systemFont(ofSize: 48)
        
        GalaxyEggNameLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        GalaxyEggNameLabel.textColor = .white
        
        GalaxyEggDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggDetailLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        GalaxyEggDetailLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        GalaxyEggDetailLabel.numberOfLines = 2
        
        GalaxyEggContainer.addSubview(GalaxyEggSymbolLabel)
        GalaxyEggContainer.addSubview(GalaxyEggNameLabel)
        GalaxyEggContainer.addSubview(GalaxyEggDetailLabel)
        
        NSLayoutConstraint.activate([
            GalaxyEggContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            GalaxyEggContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            GalaxyEggContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            GalaxyEggContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            GalaxyEggSymbolLabel.leadingAnchor.constraint(equalTo: GalaxyEggContainer.leadingAnchor, constant: 20),
            GalaxyEggSymbolLabel.centerYAnchor.constraint(equalTo: GalaxyEggContainer.centerYAnchor),
            
            GalaxyEggNameLabel.leadingAnchor.constraint(equalTo: GalaxyEggSymbolLabel.trailingAnchor, constant: 16),
            GalaxyEggNameLabel.trailingAnchor.constraint(equalTo: GalaxyEggContainer.trailingAnchor, constant: -16),
            GalaxyEggNameLabel.topAnchor.constraint(equalTo: GalaxyEggContainer.topAnchor, constant: 20),
            
            GalaxyEggDetailLabel.leadingAnchor.constraint(equalTo: GalaxyEggNameLabel.leadingAnchor),
            GalaxyEggDetailLabel.trailingAnchor.constraint(equalTo: GalaxyEggNameLabel.trailingAnchor),
            GalaxyEggDetailLabel.topAnchor.constraint(equalTo: GalaxyEggNameLabel.bottomAnchor, constant: 6),
            GalaxyEggDetailLabel.bottomAnchor.constraint(lessThanOrEqualTo: GalaxyEggContainer.bottomAnchor, constant: -16)
        ])
    }
    
    func GalaxyEggConfigure(with GalaxyEggModel: GalaxyEggSpaceElementModel) {
        GalaxyEggSymbolLabel.text = GalaxyEggModel.GalaxyEggSymbol
        GalaxyEggNameLabel.text = GalaxyEggModel.GalaxyEggDisplayName
        GalaxyEggDetailLabel.text = GalaxyEggModel.GalaxyEggDetail
    }
}
