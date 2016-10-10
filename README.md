# VideoPager

[![CI Status](http://img.shields.io/travis/Takuya Okamoto/VideoPager.svg?style=flat)](https://travis-ci.org/Takuya Okamoto/VideoPager)
[![Version](https://img.shields.io/cocoapods/v/VideoPager.svg?style=flat)](http://cocoapods.org/pods/VideoPager)
[![License](https://img.shields.io/cocoapods/l/VideoPager.svg?style=flat)](http://cocoapods.org/pods/VideoPager)
[![Platform](https://img.shields.io/cocoapods/p/VideoPager.svg?style=flat)](http://cocoapods.org/pods/VideoPager)

## Demo (GIF)

<img src="https://github.com/entotsu/VideoPager/blob/master/sample_gif/1.gif?raw=true" alt="demo" title="demo" width="240" />

* [**Demo2**](https://github.com/entotsu/VideoPager/blob/master/sample_gif/2.gif)
* [**Demo3**](https://github.com/entotsu/VideoPager/blob/master/sample_gif/3.gif)

## Available UI

* seekSlider: UISlider

* playIcon: UIImage

* pauseIcon: UIImage

* playButton: UIButton

* progressView: UIProgressView

* currentTimeLabel: UILabel

* remainTimeLabel: UILabel

* activityIndicator: UIActivityIndicatorView

* playSpeedButton: UIButton

* speedRateList: [Float]

* frontSkipButton: UIButton

* backSkipButton: UIButton

* topShadowHeight: CGFloat

* bottomShadowHeight: CGFloat

* shadowOpacity: CGFloat

* fadeEnabledViews: [UIView]

# Simple Usage

```swift
let videoPager = VideoPagerViewController()

videoPager.updateUrls(urls)
```

# Custom Cell

```swift
class YourCell: VideoPagerCell {
  // your implementation
}
```

## VideoPagerCustomUI
You can easily implement control UI by conforming to [`VideoPagerCustomUI`](https://github.com/entotsu/VideoPager/blob/master/Docs/API.md#available-protocols-of-videopagercustomui).

```swift
class YourCell: VideoPagerCell, VideoPagerCustomUI {

    // VideoPagerCustomUI
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var seekSlider: UISlider!
}
```


# Custom VideoPagerViewController

``` swift

class CustomVideoPager: VideoPagerViewController {

    required init?(coder aDecoder: NSCoder) {
        // initialize with your cell
        let cellNib = UINib(nibName: "CustomCell", bundle: nil)
        super.init(coder: aDecoder, videoPagerCellNib: cellNib)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set urls
        updateUrls(urls)
    }

    override func configureCell(cell: VideoPagerCell, index: Int) {
        super.configureCell(cell, index: index)
        // you can configure your cell with this method
        if let cell = cell as? CustomCell {
            cell.urlLabel.text = urls[index]
        }
    }

    override func didSelectItemAtIndex(index: Int) {
        super.didSelectItemAtIndex(index)
        // you can add tap action
        activeCell?.playOrPause()
    }
}
```


# Documentation

[API document is here.](https://github.com/entotsu/VideoPager/blob/master/Docs/API.md)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS8.0~

## Installation

VideoPager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VideoPager"
```

and import to your swift file.

```swift
import VideoPager
```

## Author

Takuya Okamoto, blackn.red42@gmail.com

## License

VideoPager is available under the MIT license. See the LICENSE file for more info.
