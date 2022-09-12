// My post on Stack Overflow
// https://stackoverflow.com/a/73691922/5780595

// ADD A BORDER TO ONE SIDE OF ANY VIEW:

Import SwiftUI
// Can be added to any View:

// Horizontal border aka Divider
.overlay( Divider()
           .frame(maxWidth: .infinity, maxHeight:1)
           .background(Color.green), alignment: .top) // overlay

// Vertical border aka Divider
.overlay( Divider()
        .frame(maxWidth: 1, maxHeight: .infinity)
        .background(Color.green), alignment: .leading ) // overlay


// EXAMPLE USAGE
Image("ScatterLogoLight")
      .resizable()
      .scaledToFit()
      .frame(height: 40)
      .padding(.top, 6)
      .overlay( Divider()
          .frame(maxWidth: 1, maxHeight: .infinity).background(Color.green), alignment: .leading )
      .padding(.top, 0)


/*
Explanation:

For a horizontal border aka Divider, frame width is the length of the border and height is the thickness of the border.
Vertical border the frame width is thickness and frame height is the length.

The .background will set the color of the border.

Alignment will set, where the border will draw. For example "alignment: .bottom" will place the border on the bottom of the Image
and "alignment: .top" on the top of the Image.

".leading & .trailing" will draw the border on the left and right of the Image correspondingly.
*/
