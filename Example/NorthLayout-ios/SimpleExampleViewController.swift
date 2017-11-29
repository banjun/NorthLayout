import UIKit
import NorthLayout

class SimpleExampleViewController: UIViewController {
    let iconView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()

    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Name"
        l.backgroundColor = .lightGray
        return l
    }()

    override func loadView() {
        super.loadView()
        title = "Simple Example"
        view.backgroundColor = .white

        let autolayout = northLayoutFormat(["p": 8], [
            "icon": iconView,
            "name": nameLabel])
        autolayout("H:||[icon(==64)]") // 64pt width icon on left side with default margin
        autolayout("H:||[name]||") // full width label with default margin
        autolayout("V:||-p-[icon(==64)]-p-[name]") // stack them vertically
    }
}
