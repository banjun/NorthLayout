import UIKit
import NorthLayout

class ViewLevelSafeAreaExampleViewController: UIViewController {
    let accountView = AccountView(frame: CGRect(x: 50, y: 100, width: 200, height: 150))

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        // free positioned accountView
        view.addSubview(accountView)

        // movable by swipe
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // back to center on rotation
        coordinator.animate(alongsideTransition: {_ in self.accountView.center = CGPoint(x: size.width / 2, y: size.height / 2)})
        super.viewWillTransition(to: size, with: coordinator)
    }

    var panStart: CGPoint = .zero

    @objc func panned(_ r: UIPanGestureRecognizer) {
        switch r.state {
        case .began:
            panStart = accountView.center
        case .changed:
            let t = r.translation(in: view)
            accountView.center = CGPoint(x: panStart.x + t.x, y: panStart.y + t.y)
        default:
            break
        }
    }
}

class AccountView: UIView {
    let iconView: UIImageView = {
        let v = UIImageView(image: colorImage(UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)))
        v.layer.cornerRadius = 32
        v.clipsToBounds = true
        return v
    }()

    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Drag me to iPhone X edges"
        l.numberOfLines = 0
        l.textAlignment = .center
        l.backgroundColor = .lightGray
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray

        // autolayout respecting safe area without reference to container view controller
        let autolayout = northLayoutFormat([:], [
            "icon": iconView,
            "name": nameLabel])
        autolayout("H:||-(>=0)-[icon(==64)]-(>=0)-||") // 64pt fitting width icon with default margin
        autolayout("H:||[name]||") // fitting width label with default margin
        autolayout("V:||[icon(==64)]-[name]||") // stack them vertically
        // constrain iconView horizontal ambiguity to safe area center
        layoutMarginsGuide.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
}
