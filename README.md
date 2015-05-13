# NorthLayout

[![CI Status](http://img.shields.io/travis/banjun/NorthLayout.svg?style=flat)](https://travis-ci.org/banjun/NorthLayout)
[![Version](https://img.shields.io/cocoapods/v/NorthLayout.svg?style=flat)](http://cocoapods.org/pods/NorthLayout)
[![License](https://img.shields.io/cocoapods/l/NorthLayout.svg?style=flat)](http://cocoapods.org/pods/NorthLayout)
[![Platform](https://img.shields.io/cocoapods/p/NorthLayout.svg?style=flat)](http://cocoapods.org/pods/NorthLayout)

The fast path to autolayout views in code

## Installation

NorthLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NorthLayout"
```

## Usage

* `view.northLayoutFormat(_:_:)` to get autolayout closure for view
* `autolayout(...)` to layout with [Autolayout Visual Format Language](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage/VisualFormatLanguage.html)

```swift
override func loadView() {
    super.loadView()
    
    edgesForExtendedLayout = nil
    view.backgroundColor = UIColor.whiteColor()
    
    let nameLabel = UILabel()
    nameLabel.text = "Name"
    nameLabel.backgroundColor = UIColor.grayColor()
    
    let textLabel = UILabel()
    textLabel.text = "Some text label"
    textLabel.backgroundColor = UIColor.lightGrayColor()
    
    let autolayout = view.northLayoutFormat(["p": 8], [
        "name": nameLabel,
        "text": textLabel,
        ])
    autolayout("H:|-p-[name]-p-|")
    autolayout("H:|-p-[text]-p-|")
    autolayout("V:|-p-[name]-p-[text]")
}
```

## License

NorthLayout is available under the MIT license. See the LICENSE file for more info.
