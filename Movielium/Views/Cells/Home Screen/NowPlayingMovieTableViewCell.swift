//
//  NowPlayingMovieTableViewCell.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import UIKit

class NowPlayingMovieTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Collection View
    private let flowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: NowPlayingMovieCollectionViewCell.self)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = flowLayout
        }
    }
    
    // MARK: - Properties
    private let notificationCenter: NotificationCenter = .default
    private let networkManager: NetworkManager = .shared
    private let dispatchQueueMain: DispatchQueue = .main
    
    private var shownMovieIndex = 0
    private var pageNumber = 2
    
    var nowPlayingMovieList: [Movie] = [] {
        didSet {
            pageControl.numberOfPages = nowPlayingMovieList.count
        }
    }
    
    var maximumPageNumber: Int?
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addNotificationObserver()
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: .changeMovieInNowPlayingTableView, object: nil)
    }
    
    // MARK: - Services
    
    private func appendMovies() {
        
        guard pageNumber <= (maximumPageNumber ?? 2) else { return } // Safety Check
        
        networkManager.fetchResult(
            endpoint: .nowPlayingMovies(page: pageNumber)) { [weak self] (result: Result<RemoteMovieData, RemoteDataError>) in
                switch result {
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    
                case .success(let data):
                    self?.dispatchQueueMain.async {
                        self?.appendMoviesToCollectionView(with: data.movieList)
                    }
                }
            }
    }
    
    private func appendMoviesToCollectionView(with movieList: [Movie]) {
        
        let newList = movieList.compactMap { (movie) -> Movie? in
            let isSameMovie =  nowPlayingMovieList.lazy.filter { $0.id == movie.id }.first
            return isSameMovie == .none ? movie : nil
        }
        let firstIndex = nowPlayingMovieList.count
        let lastIndex = newList.count + firstIndex - 1
        guard lastIndex >= firstIndex else { return } // Safety check
        let indexPathList = Array(firstIndex...lastIndex)
            .map { IndexPath(row: $0, section: 0) }
        nowPlayingMovieList.append(contentsOf: newList)
        collectionView.insertItems(at: indexPathList)
        
        pageControl.currentPage = firstIndex
        pageControl.numberOfPages = nowPlayingMovieList.count
        pageNumber += 1
    }
    
    // MARK: - Private Functions
    
    // MARK: - Action
    // TODO: if not necessary then delete it
    @objc private func changeMovie(_ notification: Notification) {
        Logger.info("changeMovie is worked")
        shownMovieIndex += 1
        let cell = collectionView.numberOfItems(inSection: 0)
    }
    
    // MARK: - Helpers
    
    private func addNotificationObserver() {
        notificationCenter.addObserver(
            self, selector: #selector(changeMovie),
            name: .changeMovieInNowPlayingTableView, object: nil)
    }
    
    private func handlePageControlMovements(with value: CGFloat) {
        let controlArray = (0...(nowPlayingMovieList.count - 1)).map { CGFloat($0) }
        // Works to much that's why I'm checking values
        guard value.controlEqualityAny(controlArray) else { return }
        let pageIndex = Int(round(value))
        pageControl.currentPage = Int(pageIndex)
        shownMovieIndex = pageIndex
    }
}

// MARK: - DataSource

extension NowPlayingMovieTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as NowPlayingMovieCollectionViewCell
        
        cell.movie = nowPlayingMovieList[indexPath.row]
        return cell
    }
}

// MARK: - Delegate
extension NowPlayingMovieTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: perform
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard shownMovieIndex == nowPlayingMovieList.count - 5 else { return }
        appendMovies()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cgFloatValue = collectionView.contentOffset.x / contentView.frame.width
        handlePageControlMovements(with: cgFloatValue)
    }
    
}

// MARK: - FlowLayout

extension NowPlayingMovieTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
}

extension NowPlayingMovieTableViewCell: NibReusable {}
