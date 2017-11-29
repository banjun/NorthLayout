# NorthLayout

[![CI Status](http://img.shields.io/travis/banjun/NorthLayout.svg?style=flat)](https://travis-ci.org/banjun/NorthLayout)
[![Version](https://img.shields.io/cocoapods/v/NorthLayout.svg?style=flat)](http://cocoapods.org/pods/NorthLayout)
[![License](https://img.shields.io/cocoapods/l/NorthLayout.svg?style=flat)](http://cocoapods.org/pods/NorthLayout)
[![Platform](https://img.shields.io/cocoapods/p/NorthLayout.svg?style=flat)](http://cocoapods.org/pods/NorthLayout)

The fast path to autolayout views in code

## Simple Usage

```swift
let iconView = UIImageView() // and customize...
let nameLabel = UILabel() // and customize...

override func loadView() {
    super.loadView()
    
    let autolayout = northLayoutFormat(["p": 8], [
        "icon": iconView,
        "name": nameLabel])
    autolayout("H:|-p-[icon(==64)]") // 64pt width icon on left side with margin p
    autolayout("H:|-p-[name]-p-|") // full width label with margin p
    autolayout("V:|-p-[icon(==64)]-p-[name]") // stack them vertically
}
```

See also `Example` project.

## Features

### 📜 No Storyboards Required

Let's autolayout in code. boilerplates such as `translatesAutoresizingMaskIntoConstraints = false` and adding as subview are coded in `northLayoutFormat()`.

### ↔️ Visual Format Language

Use Visual Format Language (VFL) for layout.

[Auto Layout Guide: Visual Format Language](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html)

### ⏸ Extended Visual Format for Layout Margins & Safe Area

In addition to Apple VFL above, NorthLayout introduces `||` syntax for layout margin bounds.

```swift
// stick to side edges (i.e. screen edges for view of view controller)
autolayout("H:|[icon1]|")

// stick to side layout margins (avoids non safe areas)
autolayout("H:||[icon2]||")
```

### 📚 View Controller level & View level layout

In autolayout, there is some differences in view of view controller and independent view. `northLayoutFormat` is available for view controller and view.
You can use `|` as topLayoutGuide or bottomLayoutGuide (mainly for before iOS 11) and avoid conflicting scroll adjustments on view controllers.
You can also code layout simply without a view controller on views.

### 📱🖥 iOS & macOS

Available for UIView & NSView

## Migration to NorthLayout 5

NorthLayout 4 has supported Safe Area by translating `|` bounds as safe area layout guides by default.

NorthLayout 5 adds breaking changes that introduces `||` layout margin guides and thus `|` no longer respects Safe Area.
Choose `|` to stick to edges, or `||` to inset in layout margins or safe area.

## Installation

NorthLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NorthLayout"
```

## The Name

NorthLayout is named after where it was cocoapodized, [Lake Toya](http://en.wikipedia.org/wiki/Lake_Tōya) in the North prefecture of Japan, the setting of [Celestial Method](http://en.wikipedia.org/wiki/Celestial_Method).

## License

NorthLayout is available under the MIT license. See the LICENSE file for more info.
