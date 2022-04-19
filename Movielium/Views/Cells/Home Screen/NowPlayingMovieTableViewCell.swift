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
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Services
    
    // MARK: - Private Functions
    
    // MARK: - Action
    
}

// MARK: - DataSource

extension NowPlayingMovieTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as NowPlayingMovieCollectionViewCell
        return cell
    }
}

// MARK: - Delegate
extension NowPlayingMovieTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        <#code#>
//    }
}

// MARK: - FlowLayout

extension NowPlayingMovieTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return <#value#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return <#value#>
//    }
}

extension NowPlayingMovieTableViewCell: NibReusable {}
