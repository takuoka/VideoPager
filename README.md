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

## Usage

### Override `VideoPagerCell`

```swift
class YourCell: VideoPagerCell {

    override func initialize() {
        super.initialize()
        // do someting
    }

    override func didEndPlayback() {
        // do someting
    }

    override func didFailedToPlay() {
        // do someting
    }    
}
```

### Create `VideoPagerViewController`

```swift
let videoPager = VideoPagerViewController(cellType: YourCell.self)
videoPager.delegate = self
```

if you want to create from nib:

```swift
let cellNib = UINib(nibName: "YourCell", bundle: nil)
let videoPager = VideoPagerViewController(videoPagerCellNib: cellNib)
videoPager.delegate = self
```

You can also override `VideoPagerViewController` to do something.

### Add video urls

```swift
videoPager.updateUrls(urls)
```

### Implement `VideoPagerViewControllerDelegate`

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
}
```

## Author

Takuya Okamoto, blackn.red42@gmail.com

## License

VideoPager is available under the MIT license. See the LICENSE file for more info.
