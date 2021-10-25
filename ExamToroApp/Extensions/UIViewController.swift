import UIKit
import Network

extension UIViewController {
    func presentAlert(title: String, message: String? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("BtnOk", comment: "Ok"), style: .default) { action in
            completion?()
        })
        self.present(alert, animated: true)
    }
}
