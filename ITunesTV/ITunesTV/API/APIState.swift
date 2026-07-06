import Foundation

enum APIState: Equatable{
    case idle
    case loading
    case loaded([Item])
    case error(String)
}
