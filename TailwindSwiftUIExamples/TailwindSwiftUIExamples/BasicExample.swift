import SwiftUI
import TailwindSwiftUI

struct BasicExample: View {
    var body: some View {
        VStack {
            Text("Tailwind for SwiftUI")
                .tw("text-3xl font-bold text-slate-900")
            
            Text("Utility-first SwiftUI")
                .tw("text-lg text-slate-600")
            
            Text("Get Started")
                .tw("px-6 py-3 bg-blue-600 text-white rounded-lg shadow-md font-semibold")
        }
        .tw("p-8 bg-white rounded-2xl shadow-xl")
    }
}
