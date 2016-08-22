# VideoPager

[![CI Status](http://img.shields.io/travis/Takuya Okamoto/VideoPager.svg?style=flat)](https://travis-ci.org/Takuya Okamoto/VideoPager)
[![Version](https://img.shields.io/cocoapods/v/VideoPager.svg?style=flat)](http://cocoapods.org/pods/VideoPager)
[![License](https://img.shields.io/cocoapods/l/VideoPager.svg?style=flat)](http://cocoapods.org/pods/VideoPager)
[![Platform](https://img.shields.io/cocoapods/p/VideoPager.svg?style=flat)](http://cocoapods.org/pods/VideoPager)

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

## Simple Usage

```swift
let videoPager = VideoPagerViewController()

videoPager.updateUrls(urls)
```

## Custom Cell

```swift
class YourCell: VideoPagerCell {

    override func initialize() {
        super.initialize()
        // do something
    }    
}
```

### set your custom cell

```swift
let videoPager = VideoPagerViewController(cellType: YourCell.self)
```

or

```swift
let cellNib = UINib(nibName: "YourCell", bundle: nil)
let videoPager = VideoPagerViewController(videoPagerCellNib: cellNib)
```

### configure your cell with `VideoPagerViewControllerDelegate`

```swift
videoPager.delegate = self
```

```swift

extension ViewController: VideoPagerViewControllerDelegate {

    func videoPagerViewController(videoPagerViewController: VideoPagerViewController, configureCell cell: VideoPagerCell, index: Int) {
        if let cell = cell as? YourCell {
            // please configure cell
        }
    }

    func videoPagerViewController(videoPagerViewController: VideoPagerViewController, didSelectItemAtIndexPath index: Int) {
        // do something
    }

    func videoPagerViewController(videoPagerViewController: VideoPagerViewController, didEndPlayback cell: VideoPagerCell) {
      // do something
    }

    func videoPagerViewController(videoPagerViewController: VideoPagerViewController, cellDidFailedToPlay cell: VideoPagerCell) {
      // do something
    }
}
```

---------------------

You can also override `VideoPagerViewController` to do something.



## Author

Takuya Okamoto, blackn.red42@gmail.com

## License

VideoPager is available under the MIT license. See the LICENSE file for more info.
