import Foundation

let DefaulLocalizationTableName = "Localizable"
fileprivate let defaultBundle = Bundle.main

protocol Localizable {
  var fileName: String { get }
  var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
  var localized: String {
    return rawValue.localized(tableName: fileName)
  }
}

extension String {
  func localized(bundle: Bundle = defaultBundle, tableName: String = DefaulLocalizationTableName) -> String {
    return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
  }
}
