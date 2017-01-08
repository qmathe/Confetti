//: Playground - noun: a place where people can play

import Cocoa

let path = NSBezierPath()

path.isEmpty

var str = "Hello, playground"

var d = ["b": 1]

d["b"] = nil

NSDate()

var collection = [7, 8, 9]

collection.insert(10, at: 3)
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

let cf: (A) -> () -> (String) = A.doSomething(x:)
let functionPointer = unsafeBitCast(cf, to: GenericHandlerFunction.self)
let f = unsafeBitCast(functionPointer, to: HandlerFunction.self)

f(a)()

type(of: f)

private class BaseEventHandler<T, R> {

}

class EventHandler<T> : BaseEventHandler<T, AnyObject> {
	typealias EventType = T
}

let handler = EventHandler<Int>()

type(of: handler).EventType.self

let c =  AnySequence<String>(["a", "b"])
