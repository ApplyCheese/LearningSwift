
enum Theme: String {
    case light
    case dark
    case black
}

class ThemeController {
    private(set) lazy var currentTheme = loadTheme()
    private let defaults: UserDefaults
    private let defaultsKey = "theme"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func changeTheme(to theme: Theme) {
        currentTheme = theme
        defaults.setValue(theme.rawValue, forKey: defaultsKey)
    }

    private func loadTheme() -> Theme {
        let rawValue = defaults.string(forKey: defaultsKey)
        return rawValue.flatMap(Theme.init) ?? .light
    }
}
