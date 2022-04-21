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
    private let deviceHelper: DeviceHelper = .main
    
    private var shownMovieIndex: Int = 0
    private var pageNumber: Int = 2
    private var isFirstLoading: Bool = true
    
    
    var nowPlayingMovieList: [Movie] = [] {
        didSet {
            guard isFirstLoading else { return }
            dispatchQueueMain.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var maximumPageNumber: Int? {
        didSet {
            handlePageControlNumber()
        }
    }
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        handlePageControlNumber()
        
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
                    self?.maximumPageNumber = data.totalPages
                    self?.dispatchQueueMain.async {
                        self?.appendMoviesToCollectionView(with: data.movieList)
                    }
                }
            }
    }
    
    private func appendMoviesToCollectionView(with movieList: [Movie]) {
        pageNumber += 1
        
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
        
    }
    
    // MARK: - Helpers
    
    private func handlePageControlNumber() {
        let maxPageNumber = maximumPageNumber ?? 4
        
        if pageNumber == maxPageNumber {
            dispatchQueueMain.async {
                self.pageControl.numberOfPages = self.nowPlayingMovieList.count
            }
            
        } else if pageNumber == 2 {
            dispatchQueueMain.async { [self] in
                pageControl.numberOfPages = nowPlayingMovieList.count * maxPageNumber
            }
        }
        
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
        let movie = nowPlayingMovieList[indexPath.row]
        let movieDetail = MovieDetail(from: movie)
        let appNavigator: AppNavigator = .shared
        appNavigator.navigate(to: .movieDetail(detail: movieDetail))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard shownMovieIndex == nowPlayingMovieList.count - 5 else { return }
        appendMovies()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let type = deviceHelper.decideDeviceType()
        // 744 is the smallest point size for iPads
        let width = type == .iPhone ? contentView.frame.width : 744
        let cgFloatValue = collectionView.contentOffset.x / width
        handlePageControlMovements(with: cgFloatValue)
    }
    
}

// MARK: - FlowLayout

extension NowPlayingMovieTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

// MARK: - HomeViewControllerDelegate
extension NowPlayingMovieTableViewCell: HomeViewControllerDelegate {
    
    func performRefreshControl() {
        Logger.info("changeMovie is worked")
        let cellNumber = collectionView.numberOfItems(inSection: 0)
        shownMovieIndex += 1
        
        guard cellNumber > shownMovieIndex else { return } // Safety Check
        
        collectionView.scrollToItem(at: [0, shownMovieIndex],
                                    at: .centeredHorizontally, animated: true)
    }
    
}

extension NowPlayingMovieTableViewCell: NibReusable {}
