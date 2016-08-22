//
//  VideoPagerViewController.swift
//  Pods
//
//  Created by Takuya Okamoto on 2016/08/19.
//
//

import Foundation
import UIKit

@objc public protocol VideoPagerViewControllerDelegate: class {
    optional func videoPagerViewController(videoPagerViewController: VideoPagerViewController, configureCell cell: VideoPagerCell, index: Int)
    optional func videoPagerViewController(videoPagerViewController: VideoPagerViewController, didSelectItemAtIndexPath index: Int)
    optional func videoPagerViewController(videoPagerViewController: VideoPagerViewController, didEndPlayback cell: VideoPagerCell)
    optional func videoPagerViewController(videoPagerViewController: VideoPagerViewController, cellDidFailedToPlay cell: VideoPagerCell)
}

public class VideoPagerViewController: UIViewController {
    
    public var delegate: VideoPagerViewControllerDelegate?
    
    private var pagingCollectionView: PagingCollectionView!
    private var viewDidLoadClosure: (()->Void)?
    
    convenience public init() {
        self.init(cellType: VideoPagerCell.self)
    }
    
    /// you can override VideoPagerCell and set it
    public init<T: VideoPagerCell>(cellType: T.Type) {
        super.init(nibName: nil, bundle: nil)
        viewDidLoadClosure = {
            self.pagingCollectionView = PagingCollectionView(frame: self.view.frame, cellType: cellType)
        }
    }
    
    /// you can override VideoPagerCell and set it
    public init(videoPagerCellNib: UINib) {
        super.init(nibName: nil, bundle: nil)
        viewDidLoadClosure = {
            self.pagingCollectionView = PagingCollectionView(frame: self.view.frame, videoPagerCellNib: videoPagerCellNib)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadClosure?()
        viewDidLoadClosure = nil
        // init collection view
        pagingCollectionView.customDelegate = self
        self.view.addSubview(pagingCollectionView)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pagingCollectionView.contentInset = UIEdgeInsetsZero
        pagingCollectionView.activateFirstCell()
    }
    
    // 👇 please use
    public func updateUrls(urls: [NSURL]) {
        pagingCollectionView.urls = urls
        pagingCollectionView.reloadData()
    }
    
    public func scrollToNext() {
        pagingCollectionView.scrollToNext(isFast: true)
    }
    
    public func pauseActiveCell() {
        pagingCollectionView.pauseActiveCell()
    }
    
    public func playActiveCell() {
        pagingCollectionView.playActiveCell()
    }
}

extension VideoPagerViewController: PagingCollectionViewDelegate {
    
    func pagingCollectionView(collectionView: PagingCollectionView, configureCell cell: VideoPagerCell, index: Int) {
        delegate?.videoPagerViewController?(self, configureCell: cell, index: index)
    }
    
    func pagingCollectionView(collectionView: PagingCollectionView, didSelectItemAtIndexPath index: Int) {
        delegate?.videoPagerViewController?(self, didSelectItemAtIndexPath: index)
    }
    
    func pagingCollectionView(collectionView: PagingCollectionView, cellDidEndPlayback cell: VideoPagerCell) {
        delegate?.videoPagerViewController?(self, didEndPlayback: cell)
    }
    
    func pagingCollectionView(collectionView: PagingCollectionView, cellDidFailedToPlay cell: VideoPagerCell) {
        delegate?.videoPagerViewController?(self, cellDidFailedToPlay: cell)
    }
}