
import Foundation

enum UserDefaultConstants: String {
    case disableIntro
    
    func string() -> String {
        switch self {
        case .disableIntro : return "DisableIntro"
        }
    }
}
