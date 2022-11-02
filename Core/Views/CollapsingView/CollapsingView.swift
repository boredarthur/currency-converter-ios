import UIKit
import Stevia

public class CollapsingView: UIView {

    private let headerRootContainerView = UIView()
    private let contentRootContainerView = UIView()

    private var headerHeight: CGFloat = 0

    public func viewDidLoad(headerHeight: CGFloat) {
        self.headerHeight = headerHeight

        style(viewStyle)

        subviews(
            headerRootContainerView.style(headerRootContainerViewStyle),
            contentRootContainerView.style(contentRootContainerViewStyle)
        )

        layout(
            0,
            |-0-headerRootContainerView.height(self.headerHeight)-0-|,
            0,
            |-0-contentRootContainerView-0-|,
            0
        )
    }

    public func addHeaderView(_ view: UIView) {
        headerRootContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        headerRootContainerView.subviews(view)
        headerRootContainerView.layout(
            0,
            |-0-view-0-|,
            0
        )
    }

    public func addContentView(_ view: UIScrollViewDelegate) {
        guard let view = view as? UIView else { return }
        contentRootContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        contentRootContainerView.subviews(view)
        contentRootContainerView.layout(
            0,
            |-0-view-0-|,
            0
        )
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CollapsingView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerRootContainerView.heightConstraint?.constant = max(
            safeAreaInsets.top,
            headerHeight - scrollView.contentOffset.y
        )
    }
}

extension CollapsingView {

    private func viewStyle(_ view: UIView) {
        view.backgroundColor = .white
    }

    private func headerRootContainerViewStyle(_ view: UIView) {
        view.backgroundColor = .white
    }

    private func contentRootContainerViewStyle(_ view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        view.layer.masksToBounds = false
        view.backgroundColor = .white
    }
}
