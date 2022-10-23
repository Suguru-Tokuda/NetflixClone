//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Suguru on 10/19/22.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randingTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
        
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.refreshControl = self.refreshControl
        homeFeedTable.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        configuerNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("preview"), object: nil, queue: nil) { notification in
            guard
                let userInfo = notification.userInfo as [AnyHashable : Any]?,
                let title: Title = userInfo["title"] as? Title,
                let titleName: String = title.originalTitle ?? title.originalName
                else { return }

            APICaller.shared.getMovie(with: titleName) { [weak self] result in
                switch result {
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let vc = TitlePreviewViewController()
                        vc.configure(
                            with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""),
                            title: title
                        )
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                guard let selectedTitle = titles.randomElement() else { return }                
                self?.randingTrendingMovie = selectedTitle
                self?.headerView?.configure(with: selectedTitle)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configuerNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    @objc private func handleRefreshControl() {
        self.homeFeedTable.reloadData()
        
        DispatchQueue.main.async {
            self.homeFeedTable.refreshControl?.endRefreshing()
        }
    }
    
    private func navigateToPreview(viewModel: TitlePreviewViewModel, title: Title) {
        let vc = TitlePreviewViewController()
        vc.configure(with: viewModel, title: title)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTVs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }

        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = self.sectionTitles[section].capitalizeFirstLetter()
        sectionHeaderLabel.textColor = .white
        sectionHeaderLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        sectionHeaderLabel.frame = CGRect(x: 0, y: 5, width: 250, height: 20)
        header.addSubview(sectionHeaderLabel)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top // offset of the safe area
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCelDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel, title: Title) {
        DispatchQueue.main.async {
            self.navigateToPreview(viewModel: viewModel, title: title)
        }
    }
}
 
