
import Foundation

enum UserDefaultConstants: String {
    case disableIntro
    case videoFolderName
    
    func string() -> String {
        switch self {
        case .disableIntro : return "DisableIntro"
        case .videoFolderName : return "Videos"
        }
    }
}
