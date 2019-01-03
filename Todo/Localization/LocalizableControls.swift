import UIKit

@IBDesignable
class UILocalizedTabBarItem: UITabBarItem {
  @IBInspectable var localizationFileName: String? {
    didSet {
      guard let tableName = localizationFileName else { return }
      title = title?.localized(tableName: tableName)
    }
  }
}

@IBDesignable
class UILocalizedLabel: UILabel {
  @IBInspectable var localizationFileName: String? {
    didSet {
      guard let tableName = localizationFileName else { return }
      text = text?.localized(tableName: tableName)
    }
  }
}

@IBDesignable
class UILocalizedButton: UIButton {
  @IBInspectable var localizationFileName: String? {
    didSet {
      guard let tableName = localizationFileName else { return }
      let title = self.title(for: .normal)?.localized(tableName: tableName)
      setTitle(title, for: .normal)
    }
  }
}

@IBDesignable
class UILocalizedBarButtonItem: UIBarButtonItem {
  @IBInspectable var localizationFileName: String? {
    didSet {
      guard let tableName = localizationFileName else { return }
      title = title?.localized(tableName: tableName)
    }
  }
}

@IBDesignable
class UILocalizedNavigationItem: UINavigationItem {
  @IBInspectable var localizationFileName: String? {
    didSet {
      guard let tableName = localizationFileName else { return }
      title = title?.localized(tableName: tableName)
    }
  }
}
