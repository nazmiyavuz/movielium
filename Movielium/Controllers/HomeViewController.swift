//
//  HomeViewController.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func performRefreshControl()
}

class HomeViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var statusView: UIView!
    // TableView
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: NowPlayingMovieTableViewCell.self)
            tableView.register(cellType: UpcomingMovieTableViewCell.self)
            tableView.register(cellType: EmptyListTableViewCell.self)
        }
    }
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    private let networkManager: NetworkManager = .shared
    private let dispatchQueueMain: DispatchQueue = .main
    private let deviceHelper: DeviceHelper = .main
    private let notificationCenter: NotificationCenter = .default
    
    weak var delegate: HomeViewControllerDelegate?
    
    // Now Playing Movies
    private var nowPlayingMovieList: [Movie] = []
    private var maxPageNumberOfNowPlaying: Int?
    // Upcoming Movies
    private var upcomingPage = 1
    private var upcomingTotalPage: Int?
    private var upcomingMovieList: [Movie] = []
    private var isAppending: Bool?
    
    private var contentOffsetY: CGFloat = 0
    private var firstSectionHeight: CGFloat = 256
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchNowPlayingMovies()
        fetchUpcomingMovies(atFirst: true)
        configureRefreshControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstSectionHeight = decideFirstSectionHeight()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Handling Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let deviceOrientation = deviceHelper.getOrientation()
        
        if deviceOrientation == .portrait {
            statusView.isHidden = true
        } else if deviceOrientation == .landscape
                    && statusView.isHidden
                    && contentOffsetY > (firstSectionHeight - 30) {
            statusView.isHidden = false
        }
    }
    
    // MARK: - Services
    
    private func fetchNowPlayingMovies() {
        networkManager.fetchResult(
            endpoint: .nowPlayingMovies(page: 1)) { [weak self] (result: Result<RemoteMovieData, RemoteDataError>) in
                switch result {
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    
                case .success(let data):
                    self?.maxPageNumberOfNowPlaying = data.totalPages
                    self?.dispatchQueueMain.async {
                        
                        self?.nowPlayingMovieList = data.movieList
                        self?.tableView.reloadSections([0], with: .automatic)
                    }
                }
            }
    }
        
    private func fetchUpcomingMovies(atFirst: Bool) {
        guard handleTotalPageForUpcomingMovies() else { return }

        networkManager.fetchResult(
            endpoint: .upcomingMovies(page: upcomingPage)) {
                [weak self] (result: Result<RemoteMovieData, RemoteDataError>) in
                
                switch result {
                    
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    
                    self?.dispatchQueueMain.async {
                        self?.tableView.reloadData()
                    }
                    
                    self?.presentCustomAlertPresentableWith(error)
                    
                case .success(let data):
                    self?.upcomingTotalPage = data.totalPages
                    
                    self?.dispatchQueueMain.async {
                        self?.addOrAppendMovies(with: data.movieList, atFirst: atFirst)
                    }
                }
            }
    }
    
    private func addOrAppendMovies(with movieList: [Movie], atFirst: Bool) {
        switch atFirst {
        case true:
            upcomingMovieList = movieList
            tableView.reloadSections([1], with: .automatic)
            
        case false:
            let newList = movieList.compactMap { (movie) -> Movie? in
                let isSameMovie =  upcomingMovieList.lazy.filter { $0.id == movie.id }.first
                return isSameMovie == .none ? movie : nil
            }
            let firstIndex = upcomingMovieList.count
            let lastIndex = newList.count + firstIndex - 1
            guard lastIndex >= firstIndex else { return } // Safety check
            let indexPathList = Array(firstIndex...lastIndex)
                .map { IndexPath(row: $0, section: 1) }
            upcomingMovieList.append(contentsOf: newList)
            tableView.insertRows(at: indexPathList, with: .automatic)
            
            isAppending = false
        }
        upcomingPage += 1
    }
    
    // MARK: - Private Functions
    /// to prevent unnecessary add upcomingMovies to the tableView
    private func handleTotalPageForUpcomingMovies() -> Bool {
        let totalPage = upcomingTotalPage ?? 22
        return totalPage > upcomingPage
    }
    
    // MARK: - Action
    @objc private func handleRefreshControl() {
        fetchUpcomingMovies(atFirst: true)
        
        delegate?.performRefreshControl()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    // 500 x 280
    private func decideFirstSectionHeight() -> CGFloat {
        let dimensions = deviceHelper.getDimensions()
        let generalImageRatio: CGFloat = 500 / 280
        return dimensions.short / generalImageRatio
    }
    
    private func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(
            self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func toggleStatusView() {
        let limit: CGFloat = (firstSectionHeight - 30)
        if statusView.isHidden && contentOffsetY > limit {
            self.statusView.isHidden = false
        } else if !statusView.isHidden && contentOffsetY < limit  {
            self.statusView.isHidden = true
        }
    }
    
}

// MARK: - DataSource

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? upcomingMovieList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as NowPlayingMovieTableViewCell
            cell.nowPlayingMovieList = nowPlayingMovieList
            cell.maximumPageNumber = maxPageNumberOfNowPlaying
            self.delegate = cell
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UpcomingMovieTableViewCell
            cell.movie = upcomingMovieList[indexPath.row]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as EmptyListTableViewCell
            return cell
            
        }
        
    }
}

// MARK: - Delegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }
        
        let movie = upcomingMovieList[indexPath.row]
        let movieDetail = MovieDetail(from: movie)
        let appNavigator: AppNavigator = .shared
        appNavigator.navigate(to: .movieDetail(detail: movieDetail))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return firstSectionHeight
            
        case 1:
            return nowPlayingMovieList.count == 0
            ? 0 : UITableView.automaticDimension
            
        default:
            return upcomingMovieList.count == 0 && nowPlayingMovieList.count == 0
            ? UITableView.automaticDimension : 0
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
        
        guard deviceHelper.getOrientation() == .portrait else { return }
        
        toggleStatusView()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        let reloadingIndex = upcomingMovieList.count - 8
        
        guard reloadingIndex == indexPath.row && !(isAppending ?? false) else { return }
        isAppending = true
        fetchUpcomingMovies(atFirst: false)
    }
    
}
