# MagicMirror generator
Proof of concept reflection API and code generator for Swift. The project is based on the generator framework of the [Cuckoo](https://github.com/SwiftKit/Cuckoo) mocking framework.

## What it does
The MagicMirrorGenerator generates code using information provided by SourceKit to be able to dynamically call methods and set or get properties of Swift types.

Example of what you can do with the generated code for the following class:
```swift
class MyTestClass {
    var myProperty: String = "value"
    func myFunction(parameter1: String, parameter2: Int) -> String {
        return "\(parameter1)\(parameter2)"
    }
}

var obj = MyTestClass()
try obj.value(forKey: "myProperty") // => "value"
try obj.set("anotherValue", forKey: "myProperty")
obj.myProperty // => anotherValue
if let method = MyTestClass.magicMirror.methods.filter({ $0.name == "myFunction(_:parameter2:)" }).first {
    let result: String = try method.call(&obj, params: ["Test", 123]) // => "Test123"
}
```

## Installation

Install dependencies:

```
carthage bootstrap --no-use-binaries
```
