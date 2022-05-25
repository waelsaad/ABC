//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit

// There are a number of ways for handling constants and it can be debatable :] but I wanted to share this technique

fileprivate extension Int {
    static let logoImageWidth = 38
    static let logoImageHeight = 38
}

fileprivate extension CGFloat {
    static let estimatedSectionHeaderHeight: CGFloat = 160.0
}

fileprivate extension String {
    static let tableViewAccessibilityIdentifier = "ArticleListTableView"
}

class JustInViewController: UIViewController {
    
    private lazy var appEventObserver = AppEvents()
    
    private lazy var centeredLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = UIColor.black
        loader.hidesWhenStopped = true
        return loader
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: .logoImageWidth,
                                                  height: .logoImageHeight))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "TranspireLogo")
        imageView.image = image
        return imageView
    }()
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.delegate = self
            tableView.dataSource = self
            //tableView.allowsSelection = false
            tableView.showsVerticalScrollIndicator = false
            tableView.registerCell(FeatureCardTableViewCell.self)
            tableView.registerCell(ContentCardTableViewCell.self)
            
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = .zero
            
            //tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = .estimatedSectionHeaderHeight
            
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)

            tableView.isAccessibilityElement = true
            tableView.accessibilityIdentifier = .tableViewAccessibilityIdentifier
            //tableView.contentInset = UIEdgeInsets(top: Constants.tableTopMargin, left: 0, bottom: 0, right: 0);
        }
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        fetchFeed()
        navigationItem.title = viewModel.title
        
        // Background Refresh
        appEventObserver.subscribe() { [weak self] event in
            if event.type == .willEnterForeground {
                self?.fetchFeed()
            }
        }
    }
    
    private func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.barColor = .navBarColor
        navigationItem.titleView = logoImageView
        
        Theme.applyAppearance(for: navigationBar, theme: .justIn)
    }
    
    private func fetchFeed() {
        showCenteredLoading()
        viewModel.fetchFeed(completion: { [weak self] (result: APIResponse<FeedResponse>) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.showTableView()
                    self.hideCenteredLoading()
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            case let .failure (error):
                DispatchQueue.main.async {
                    self?.viewModel.displayError(error: error)
                }
            }
        })
    }

    private func showTableView() {
        tableView.isHidden = false
    }
    
    private func showCenteredLoading() {
        centeredLoader.startAnimating()
        view.addSubview(self.centeredLoader)
        centeredLoader.backgroundColor = .clear
        centeredLoader.translatesAutoresizingMaskIntoConstraints = false
        centeredLoader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        centeredLoader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func hideCenteredLoading() {
        centeredLoader.stopAnimating()
        centeredLoader.removeConstraints(self.centeredLoader.constraints)
        centeredLoader.removeFromSuperview()
    }
    
    // MARK: Actions
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime,
                                      execute: { [weak self] in
            guard let self = self else { return }
            self.fetchFeed()
        })
    }
    
    // MARK: - Private Properties
    
    private lazy var viewModel: JustInViewModel = {
        return JustInViewModel()
    }()
}

// MARK: - UITableViewDataSource

extension JustInViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if viewModel.data.count == 0 { return 0 }
        switch viewModel.sections[section] {
        case .featureArticle:
            return 1
        case .contentArticle:
            return viewModel.data.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard
            let section = viewModel.section(at: indexPath)
        else { return UITableViewCell()}
        
        switch section {
        case .featureArticle:
            let cell: FeatureCardTableViewCell = tableView.dequeueReusableCell(withClass: FeatureCardTableViewCell.self)
            cell.isAccessibilityElement = true
            cell.configure(with: viewModel.data[indexPath.item])
            return cell
        case .contentArticle:
            let cell: ContentCardTableViewCell = tableView.dequeueReusableCell(withClass: ContentCardTableViewCell.self)
            cell.isAccessibilityElement = true
            cell.configure(with: viewModel.data[indexPath.item + 1])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension JustInViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.section(at: indexPath)
        guard
            let cellHeight = section?.cellHeight
        else { return 0 }
        return cellHeight
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let section = viewModel.section(at: indexPath)
        else { return }
        
        let index = section == .featureArticle
            ? 0
            : indexPath.row + 1
        
        let articleViewModel = ArticleViewModel(with: viewModel.data[index])
        navigationController?.pushViewController(ArticleViewController(viewModel: articleViewModel),
                                                 animated: true)
    }
}
