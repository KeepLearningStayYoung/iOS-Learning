import Foundation

class List: CustomDebugStringConvertible {
	
	var head: Node?
	
	var tail: Node?
	
	var debugDescription: String {
		var text: String = ""
		var current = head
		while current != nil {
			if current?.next != nil {
				text += (String(current?.value ?? 0) + " -> ")
			} else {
				text += String(current?.value ?? 0)
			}
			current = current?.next
		}
		return text
	}
	
	init() {
		head = nil
		tail = nil
	}
	
	convenience init(with values: [Int]) {
		self.init()
		for value in values {
			appendToTail(with: value)
		}
	}
	
	convenience init(with head: Node?) {
		self.init()
		self.head = head
	}
	
	
	func appendToTail(with value: Int) {
		let newNode = Node(value)
		appendToTail(with: newNode)
	}
	
	func appendToTail(with node: Node?) {
		if tail == nil {
			tail = node
			head = tail
		} else {
			tail?.next = node
			tail = tail?.next
		}
	}
	
	func appendToHead(with value: Int) {
		let node = Node(value)
		appendToHead(with: node)
	}
	
	func appendToHead(with node: Node?) {
		if head == nil {
			head = node
			tail = head
		} else {
			node?.next = head
			head = node
		}
	}
	
	class Node: CustomDebugStringConvertible {
		
		var value: Int
		
		var next: Node?
		
		var debugDescription: String {
			if let next = next {
				return "value: \(value), next: \(next.value)"
			} else {
				return "value: \(value), next: empty"
			}
		}
		
		var chainDes: String {
			let list = List(with: self)
			return list.debugDescription
		}
		
		init(_ value: Int) {
			self.value = value
			self.next = nil
		}
	}
}

class Stack: CustomDebugStringConvertible {
	
	private var _storage: [Int]
	
	var debugDescription: String {
		return "\(_storage)"
	}
	
	init() {
		_storage = [Int]()
	}
	
	convenience init(_ vals: [Int]) {
		self.init()
		for val in vals {
			push(val)
		}
	}
	
	func push(_ val: Int) {
		_storage.append(val)
	}
	
	@discardableResult
	func pop() -> Int? {
		return _storage.removeLast()
	}
	
	var peek: Int? {
		return _storage.first
	}
	
	var top: Int? {
		return _storage.last
	}
	
	var isEmpty: Bool {
		return _storage.isEmpty
	}
	
}

// 辅助栈法
// 时间复杂度：O(N)
// 空间复杂度：O(N)
func print_1(list: List.Node?) {
	guard list != nil else { return }
	var ptr = list
	let stack = Stack()
	while ptr != nil, let val = ptr?.value {
		stack.push(val)
		ptr = ptr?.next
	}
	while stack.top != nil {
		let current = stack.pop()
		print(current ?? -1)
	}
}

// 递归法
func print_2(list: List.Node?) {
	
}

let test = List(with: [1, 5, 7, 9, 3, 6])
print_1(list: test.head)