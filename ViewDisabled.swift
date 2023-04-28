import SwiftUI

struct ContentViewQ: View {
    @StateObject var viewManager = ContentViewManager()
    @State private var viewLocked: Bool = true
    
    var body: some View {
        switch viewManager.viewPath {
        case [.favorite]:
            ScatterHomePage()
                .environmentObject(viewManager)
                .disabled(viewLocked)
                .onAppear(){
                    viewLocked = true
                }
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        viewLocked = false
                    }
                }
            
        default:
            ScatterHomePage()
                .environmentObject(viewManager)
                .disabled(viewLocked)
                .onAppear(){
                    viewLocked = true
                }
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        viewLocked = false
                    }
                }
        } // switch
        
    } //body
} //ContentView
