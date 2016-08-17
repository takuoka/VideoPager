//
//  PagingCollectionView.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import UIKit

protocol PagingCollectionViewDelegate: class {
    func pagingCollectionView(collectionView: PagingCollectionView, configureCell cell: VideoPagerCell, index: Int)
    func pagingCollectionView(collectionView: PagingCollectionView, didSelectItemAtIndexPath index: Int)
}

class PagingCollectionView: UICollectionView {
    
    var urls: [NSURL] = []
    weak var customDelegate: PagingCollectionViewDelegate!
    private let CELL_ID = "CELL"
    private var activeIndex: Int = 0
    private var isScrollStopped = true {
        didSet {
            if self.isScrollStopped != oldValue && self.isScrollStopped {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.didStopScroll()
                })
            }
        }
    }

    convenience init<T: VideoPagerCell>(frame: CGRect, cellType: T.Type) {
        self.init(frame: frame)
        self.registerClass(cellType)
    }

    convenience init(frame: CGRect, videoPagerCellNib: UINib) {
        self.init(frame: frame)
        registerNib(videoPagerCellNib)
    }
    
    private init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
        self.pagingEnabled = true
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateFirstCell() {
        guard let firstCell = cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? VideoPagerCell else { return }
        firstCell.activate(urls[0])
        self.activeIndex = 0
    }
    
    private func registerClass<T: VideoPagerCell>(cellType: T.Type) {
        registerClass(cellType, forCellWithReuseIdentifier: CELL_ID)
    }
    
    private func registerNib(nib: UINib) {
        registerNib(nib, forCellWithReuseIdentifier: CELL_ID)
    }
}

// MARK: - Private logics
extension PagingCollectionView {
    
    private func didStopScroll() {
        let visibleCells = self.visibleCells()
        guard let
            activatingCell = self.getCenterCell(visibleCells),
            indexPath = indexPathForCell(activatingCell)
            else { return }
        let url = urls[indexPath.item]
        // disable other cells
        visibleCells
            .filter {
                $0 != activatingCell
            }
            .forEach {
                ($0 as? VideoPagerCell)?.deactivate()
        }
        // activate
        activatingCell.layer.borderColor = UIColor.purpleColor().CGColor
        if indexPath.item != activeIndex {
            (activatingCell as? VideoPagerCell)?.activate(url)
            self.activeIndex = indexPath.item
        }
    }
}

extension PagingCollectionView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath)
        if let cell = cell as? VideoPagerCell {
            customDelegate!.pagingCollectionView(self, configureCell: cell, index: indexPath.item)
        } else {
            fatalError("cell is not VideoPagerCell.")
        }
        return cell
    }
    
}

extension PagingCollectionView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.customDelegate.pagingCollectionView(self, didSelectItemAtIndexPath: indexPath.item)
    }
}

extension PagingCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isScrollStopped {
            isScrollStopped = false
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if !isScrollStopped {
                isScrollStopped = true
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if !isScrollStopped {
            isScrollStopped = true
        }
    }
}

// MARK: private util methods
extension PagingCollectionView {
    
    func getCenterCell(cells: [UICollectionViewCell]) -> UICollectionViewCell? {
        var closestCell: UICollectionViewCell?
        var minDistance = CGFloat.max
        for cell in cells {
            let distance = distanceFromCenter(cell: cell, inView: self)
            if minDistance > distance {
                minDistance = distance
                closestCell = cell
            }
        }
        return closestCell
    }
    
    private func distanceFromCenter(cell cell: UICollectionViewCell, inView: UIView) -> CGFloat {
        let halfHeight = inView.frame.height / 2
        let yInCollectionView = cell.convertRect(cell.bounds, toView: inView).origin.y
        let centerYOfCell = yInCollectionView + cell.bounds.height / 2
        return CGFloat(fabsf(Float(halfHeight) - Float(centerYOfCell)))
    }
}