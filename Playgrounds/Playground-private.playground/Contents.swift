//: Playground - noun: a place where people can play

import Cocoa

let path = NSBezierPath()

path.empty

var str = "Hello, playground"

var d = ["b": 1]

d["b"] = nil

NSDate()

var collection = [7, 8, 9]

collection.insert(10, atIndex: 3)
collection.isEmpty

//NSArray(

class A<T> {
	func doSomething(x: T) -> String {
		return "hello"
	}
}

let a = A<Int>()
//let selector = #selector(A.doSomething)

//a.performSelector(selector)

String("A.doSomething")

let mirror = Mirror(reflecting: a)

mirror.children.count

typealias GenericHandlerFunction = @convention(swift) (AnyObject) -> () -> (Any)
typealias HandlerFunction = @convention(swift) (A<Int>) -> () -> (String)

let cf: (A) -> () -> (String) = A.doSomething(_:)
let functionPointer = unsafeBitCast(cf, GenericHandlerFunction.self)
let f = unsafeBitCast(functionPointer, HandlerFunction.self)

f(a)()

f.dynamicType

private class BaseEventHandler<T, R> {

}

class EventHandler<T> : BaseEventHandler<T, AnyObject> {
	typealias EventType = T
}

let handler = EventHandler<Int>()

handler.dynamicType.EventType.self

let c =  AnySequence<String>(["a", "b"])
