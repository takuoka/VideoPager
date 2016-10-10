# Available APIs

## VideoPagerViewController

``` swift

public class VideoPagerViewController : UIViewController {

    // - initializers

    public init()

    public init(videoPagerCellNib: UINib)

    public init?(coder aDecoder: NSCoder, videoPagerCellNib: UINib)

    public init<T : VideoPagerCell>(cellType: T.Type)

    public init?<T : VideoPagerCell>(coder aDecoder: NSCoder, cellType: T.Type)


    // - Methods you can use

    public func updateUrls(urls: [NSURL])

    public func activateFirstCell()// if you can't update URL till viewDidAppear, you need to call this method after updateURL first.

    public func scrollToNext()


    // - Life Cycle Methods (You can override.)

    public func configureCell(cell: VideoPagerCell, index: Int)

    public func didSelectItemAtIndex(index: Int)

    public func didStopScrollAt(index: Int, length: Int)

    public func didPlayToEndTime(cell: VideoPagerCell)

    public func cellDidFailedToPlay(cell: VideoPagerCell)


    // - properties

    public var showsScrollIndicator: Bool { get set }

    public var activeCell: VideoPager.VideoPagerCell? { get }

    public var firstCell: VideoPager.VideoPagerCell? { get }
}

```



## VideoPagerCell

``` swift

/// please override if you create your cell
public class VideoPagerCell : UICollectionViewCell {

    // - properties

    public let thumbnailView: UIImageView

    public let topShadowView: UIView

    public let bottomShadowView: UIView


    // - Methods you can use

    public func playOrPause()


    // - Life Cycle Methods (You can override.)

    public func initialize()

    public func willLayoutSubViewsFirst()

    public func preferVideoFillMode() -> VideoPager.VideoPagerFillMode// .AspectFill or .AspectFit

    public func playerDidSetUrl()

    public func playerDidStartPlayback()

    public func playerDidPlayToEndTime()

    public func playerWillEndPlay()

    public func willDisplay()

    public func didAppear()

    public func didTapCell()

    public func viewControllerDidAppearWhenCellIsActive()
}

```

# Available protocols of `VideoPagerCustomUI`

If you set some components, then it works.

```swift
@objc public protocol VideoPagerCustomUI {

    optional var playIcon: UIImage { get }
    optional var pauseIcon: UIImage { get }
    optional var playButton: UIButton! { get }

    optional var playSpeedButton: UIButton! { get }
    optional var speedRateList: [Float] { get }

    optional var frontSkipButton: UIButton! { get }
    optional var backSkipButton: UIButton! { get }

    optional var progressView: UIProgressView! { get }
    optional var currentTimeLabel: UILabel! { get }
    optional var remainTimeLabel: UILabel! { get }
    optional var activityIndicator: UIActivityIndicatorView! { get }

    optional var seekSlider: UISlider! { get }

    optional var topShadowHeight: CGFloat { get }
    optional var bottomShadowHeight: CGFloat { get }
    optional var shadowOpacity: CGFloat { get }

    optional var fadeEnabledViews: [UIView] { get }
}
```




# How to set custom cell

## Initialize with cell class

```swift
let videoPager = VideoPagerViewController(cellType: YourCell.self)
```

## Initialize with cell nib

```swift
let cellNib = UINib(nibName: "YourCell", bundle: nil)
let videoPager = VideoPagerViewController(videoPagerCellNib: cellNib)
```

## Initialize with cell nib / class at subclass of `VideoPagerViewController`

```swift
// Make subclass `VideoPagerViewController` and initialize with your cell.

class CustomVideoPager: VideoPagerViewController {

    required init?(coder aDecoder: NSCoder) {
        let cellNib = UINib(nibName: "CustomCell", bundle: nil)
        super.init(coder: aDecoder, videoPagerCellNib: cellNib)
    }
}
```
