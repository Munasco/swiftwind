import Cocoa
import SwiftUI

let start = CFAbsoluteTimeGetCurrent()

var greeting = "Hello, playground"
var x = "I love OpenAI"
var y = x.split(separator: " ")
var z = y.first

let regex = try! NSRegularExpression(pattern: "l")
let count = regex.numberOfMatches(in: greeting, range: NSRange(greeting.startIndex..., in: greeting))
// count == 3

let elapsed = CFAbsoluteTimeGetCurrent() - start

struct MyView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview{ MyView()
}
