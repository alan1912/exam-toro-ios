import Foundation

public struct Genders: Codable {
    public let key: Int
    private(set) var value: String

    init(key: Int) {
        self.key = key
        switch key {
        case 0:
            self.value = NSLocalizedString("Female", comment: "Female")
        case 1:
            self.value = NSLocalizedString("Male", comment: "Male")
        default:
            self.value = NSLocalizedString("Female", comment: "Female")
        }
    }
}
