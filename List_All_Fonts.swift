

// list all fonts

let allFontNames = UIFont.familyNames
  .flatMap { UIFont.fontNames(forFamilyName: $0) }

var body: some View {
  List(allFontNames, id: \.self) { name in
    Text(name)
      .font(Font.custom(name, size: 12))
  }
}
