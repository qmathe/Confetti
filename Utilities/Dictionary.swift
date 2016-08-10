/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  November 2015
	License:  Proprietary
 */

import Foundation

extension Dictionary {

	// For the high-order additions returning dictionaries, 
	// see https://gist.github.com/kostiakoval/814730ad246bf95b08f6

    init(_ elements: [Element]){
        self.init()
        for (k, v) in elements {
            self[k] = v
        }
    }
    
    func map<U>(transform: Value -> U) -> [Key : U] {
        return Dictionary<Key, U>(map { (key, value) in (key, transform(value)) })
    }
    
    func map<T : Hashable, U>(transform: (Key, Value) -> (T, U)) -> [T : U] {
        return Dictionary<T, U>(map(transform))
    }
    
    func filter(includeElement: Element -> Bool) -> [Key : Value] {
        return Dictionary(filter(includeElement))
    }
    
    func reduce<U>(initial: U, @noescape combine: (U, Element) -> U) -> U {
        return reduce(initial, combine: combine)
    }
}

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) { 
    for (k, v) in right { 
        left.updateValue(v, forKey: k) 
    } 
}
