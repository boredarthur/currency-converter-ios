import UIKit

class CollapsingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func configure(
        headerHeight: CGFloat,
        headerController: UIViewController,
        contentController: UIViewController
    ) {
        getView().viewDidLoad(headerHeight: headerHeight)
        addHeaderController(headerController)
        addContentController(contentController)
    }

    private func addHeaderController(_ controller: UIViewController) {
        addChild(controller)
        getView().addHeaderView(controller.view)
    }

    private func addContentController(_ controller: UIViewController) {
        guard var collapsingChildView = controller.view as? CollapsingChildView else {
            return
        }
        addChild(controller)
        collapsingChildView.scrollDelegate = getView()
        getView().addContentView(controller.view as! UIScrollViewDelegate)
    }

    override func loadView() {
        self.view = CollapsingView(frame: UIScreen.main.bounds)
    }

    func getView() -> CollapsingView {
        return self.view as! CollapsingView
    }
}
