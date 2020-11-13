import SwiftUI

struct ToolView: View {
    @State var value: String = ""
    
    var body: some View {
        VStack {
            Text("SwiftUI/UIKit")
            TextField("Value", text: $value)
                .frame(width: 200)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .frame(minWidth: 0, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color.purple)
    }
}

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        ToolView()
    }
}
