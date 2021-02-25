import Foundation


// 用两个栈实现一个队列。
// 队列的声明如下，请实现它的两个函数 appendTail 和 deleteHead，
// 分别完成在队列尾部插入整数和在队列头部删除整数的功能。
// (若队列中没有元素，deleteHead 操作返回 -1 )

class Queue<T: Comparable> {
	
}

class Stack<T>: Comparable: CustomDebugStringConvertible {
	
	private var _storage: [T]
	
	var debugDescription: String {
		return "\(_storage)"
	}
	
	init() {
		_storage = [T]()
	}
	
	convenience init(_ vals: [T]) {
		self.init()
		for val in vals {
			push(val)
		}
	}
	
	func push(_ val: T) {
		_storage.append(val)
	}
	
	@discardableResult
	func pop() -> T? {
		return _storage.removeLast()
	}
	
	var peek: T? {
		return _storage.first
	}
	
	var top: T? {
		return _storage.last
	}
	
	var isEmpty: Bool {
		return _storage.isEmpty
	}
	
}