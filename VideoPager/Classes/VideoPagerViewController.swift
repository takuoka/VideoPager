//
//  VideoPagerViewController.swift
//  Pods
//
//  Created by Takuya Okamoto on 2016/08/19.
//
//

import Foundation
import UIKit

public class VideoPagerViewController: UIViewController {
    
    private var pagingCollectionView: PagingCollectionView
    public var showsScrollIndicator = true {
        didSet {
            pagingCollectionView.showsVerticalScrollIndicator = showsScrollIndicator
        }
    }
    
    // MARK: - initialize
    
    convenience public init() {
        self.init(cellType: VideoPagerCell.self)
    }
    
    public init<T: VideoPagerCell>(cellType: T.Type) {
        self.pagingCollectionView = PagingCollectionView(cellType: cellType)
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(videoPagerCellNib: UINib) {
        self.pagingCollectionView = PagingCollectionView(videoPagerCellNib: videoPagerCellNib)
        super.init(nibName: nil, bundle: nil)
    }

    public init?<T: VideoPagerCell>(coder aDecoder: NSCoder, cellType: T.Type) {
        self.pagingCollectionView = PagingCollectionView(cellType: cellType)
        super.init(coder: aDecoder)
    }
    
    public init?(coder aDecoder: NSCoder, videoPagerCellNib: UINib) {
        self.pagingCollectionView = PagingCollectionView(videoPagerCellNib: videoPagerCellNib)
        super.init(coder: aDecoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        VideoView.disposeSharedPlayer()
    }
    
    // MARK: - UIViewController Life Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()
        pagingCollectionView.frame = self.view.bounds
        pagingCollectionView.customDelegate = self
        view.insertSubview(pagingCollectionView, atIndex: 0)
        edgesForExtendedLayout = .None
    }
    
    var isFirstAppear = true
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear {
            isFirstAppear = false
            viewDidAppearFirst()
        } else {
            activeCell?.restorePlayer()
        }
        activeCell?.viewControllerDidAppearWhenCellIsActive()
    }
    
    func viewDidAppearFirst() {
        activateFirstCell()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        activeCell?.playerWillEndPlayIfNotEnded()
        activeCell?.pause(bySystem: true)
    }
    
    // MARK: - Control Method 👇 please use
    
    public func updateUrls(urls: [NSURL]) {
        pagingCollectionView.urls = urls
        pagingCollectionView.reloadData()
    }
    
    public func scrollToNext() {
        pagingCollectionView.scrollToNext(isFast: true)
    }
    
    // MARK: - Life Cycle Methods 👇 please override
    
    public func didStopScrollAt(index: Int, length: Int) {
        // override method
    }
    
    public func configureCell(cell: VideoPagerCell, index: Int) {
        // override method
    }
    
    public func didSelectItemAtIndex(index: Int) {
        // override method
    }
    
    public func didPlayToEndTime(cell: VideoPagerCell) {
        // override method
    }
    
    public func cellDidFailedToPlay(cell: VideoPagerCell) {
        // override method
    }
}

extension VideoPagerViewController: PagingCollectionViewDelegate {
    
    func pagingCollectionView(collectionView: PagingCollectionView, didStopScrollAt index: Int, length: Int) {
        didStopScrollAt(index, length: length)
    }

    func pagingCollectionView(collectionView: PagingCollectionView, configureCell cell: VideoPagerCell, index: Int) {
        configureCell(cell, index: index)
    }
    
    func pagingCollectionView(collectionView: PagingCollectionView, didSelectItemAtIndexPath index: Int) {
        didSelectItemAtIndex(index)
    }
    
    func pagingCollectionView(collectionView: PagingCollectionView, didPlayToEndTime cell: VideoPagerCell) {
        didPlayToEndTime(cell)
    }
    
    func pagingCollectionView(collectionView: PagingCollectionView, cellDidFailedToPlay cell: VideoPagerCell) {
        cellDidFailedToPlay(cell)
    }
}

extension VideoPagerViewController {

    public var activeCell: VideoPagerCell? {
        return pagingCollectionView.activeCell
    }

    public var firstCell: VideoPagerCell? {
        return pagingCollectionView.firstCell
    }
    
    public func activateFirstCell() {
        pagingCollectionView.activateFirstCell()
    }
}