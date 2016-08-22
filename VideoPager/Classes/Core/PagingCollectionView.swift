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
    func pagingCollectionView(collectionView: PagingCollectionView, cellDidEndPlayback cell: VideoPagerCell)
    func pagingCollectionView(collectionView: PagingCollectionView, cellDidFailedToPlay cell: VideoPagerCell)
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
    private var didStopAnimationOfAutoScroll: () -> Void = {}
    // config
    private let slowScrollAnimationDuration: NSTimeInterval = 1
    private let slowScrollAcnimationDelay: NSTimeInterval = 0.2

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
        activate(0)
    }
    
    func scrollToNext(isFast isFast: Bool) {
        isFast
            ? scrollToNextFast()
            : scrollToNextSlowly()
    }
}

// MARK: - logic
extension PagingCollectionView {
    
    private func didStopScroll() {
        let visibleCells = self.visibleCells()
        guard let
            activatingCell = self.getCenterCell(visibleCells),
            indexPath = indexPathForCell(activatingCell)
        else { return }
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
            activate(indexPath.item)
        }
    }
}

extension PagingCollectionView: VideoPagerCellDelegate {

    func videoPagerCell(didEndPlayback cell: VideoPagerCell) {
        self.scrollToNext(isFast: false)
        customDelegate.pagingCollectionView(self, cellDidEndPlayback: cell)
    }

    func videoPagerCell(didFailedToPlay cell: VideoPagerCell) {
        customDelegate.pagingCollectionView(self, cellDidFailedToPlay: cell)
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
            cell.delegate = self
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
    
    private func activate(index: Int) {
        guard let cell = cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? VideoPagerCell else { return }
        let url = urls[index]
        cell.activate(url)
        self.activeIndex = index
    }

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
    
    private func registerClass<T: VideoPagerCell>(cellType: T.Type) {
        registerClass(cellType, forCellWithReuseIdentifier: CELL_ID)
    }
    
    private func registerNib(nib: UINib) {
        registerNib(nib, forCellWithReuseIdentifier: CELL_ID)
    }
}

// MARK: - Auto Scroll Animation
extension PagingCollectionView {
    
    private func scrollToNextSlowly() {
        // configure next cell by calling delegate method "cellForItemAtIndexPath"
        setContentOffset(CGPoint(x: contentOffset.x, y: contentOffset.y + 1), animated: false)
        scrollToNextOf(NSIndexPath(forItem: self.activeIndex, inSection: 0))
    }
    
    private func scrollToNextFast() {
        self.scrollEnabled = false
        // scroll animation provided by UIKit
        let nextIndexPath = NSIndexPath(
            forItem: activeIndex + 1,
            inSection: 0
        )
        if self.numberOfItemsInSection(0) > nextIndexPath.item {
            self.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Top, animated: true)
            delay(1) { [weak self] in
                guard let wself = self else { return }
                wself.scrollEnabled = true
                wself.isScrollStopped = true
                wself.activate(nextIndexPath.item)
            }
        }
    }
    
    private func scrollToNextOf(indexPath: NSIndexPath) {
        guard indexPath.item < self.numberOfItemsInSection(0) - 1 else { return }
        guard let activeCell = self.cellForItemAtIndexPath(indexPath) else { return }
        let nextOffset = CGPoint(
            x: self.contentOffset.x,
            y: activeCell.frame.origin.y + activeCell.frame.height
        )
        let scrollAmount = nextOffset.y - self.contentOffset.y
        // Activate next Cell
        let nextIndex = NSIndexPath(
            forItem: indexPath.item + 1,
            inSection: indexPath.section
        )
        // start animation
        self.startScrollAnimation(scrollAmountY: scrollAmount, nextIndexPath: nextIndex)
        self.scrollEnabled = false
        // activate cell
        self.didStopAnimationOfAutoScroll = { [weak self] in
            delay(0.05) {
                guard let wself = self else { return }
                wself.scrollEnabled = true
                wself.isScrollStopped = true
                wself.activate(nextIndex.item)
            }
        }
    }
    
    private func startScrollAnimation(scrollAmountY scrollAmountY: CGFloat, nextIndexPath: NSIndexPath) {
        var bounds = self.bounds
        let keyPath = "bounds"
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.duration = self.slowScrollAnimationDuration
        anim.beginTime = CACurrentMediaTime() + slowScrollAcnimationDelay
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.fromValue = NSValue(CGRect: bounds)
        bounds.origin.y += scrollAmountY
        anim.toValue = NSValue(CGRect: bounds)
        anim.delegate = self
        anim.setValue(nextIndexPath, forKey: "nextIndexPath")
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        self.layer.addAnimation(anim, forKey: keyPath)
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let nextIndexPath = anim.valueForKeyPath("nextIndexPath") as? NSIndexPath {
            if self.numberOfItemsInSection(nextIndexPath.section) > nextIndexPath.item {
                self.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Top, animated: false)
            }
        }
        self.layer.removeAnimationForKey("bounds")
        self.didStopAnimationOfAutoScroll()
        self.didStopAnimationOfAutoScroll = {}
    }
}

private func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}