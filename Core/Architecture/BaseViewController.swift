import Foundation
import UIKit
import Combine

class BaseViewController<V: BaseView<S>, A: BaseViewIntent, S: BaseViewState, VM: BaseViewModel<A, S>>:
    BaseStatlessViewController<V> {

    let viewModel = VM.init()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.stateSubject.eraseToAnyPublisher().sink { _ in } receiveValue: { [weak self] state in
            DispatchQueue.main.async {
                self?.getView().render(state: state)
            }
        }.store(in: &cancellables)
    }
}
