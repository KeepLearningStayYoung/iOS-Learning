//
// Al.swift
// Created by Isaac Pan on 2021/1/12.

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

class Stack<T: Comparable>: CustomDebugStringConvertible {
	
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

class Tree {
	
	var root: Node
	
	init(root: Node) {
		self.root = root
	}
	
	class Node {
		
		var value: Int
		
		var left: Node?
		
		var right: Node?
		
		init(_ val: Int) {
			self.value = val
		}
	}
}

// 反转链表_非递归
func reverse_1(list: List) {
	guard list.head != nil, list.head?.next != nil else { return }
	var temp: List.Node?
	var ptr = list.head
	while ptr != nil {
		let next = ptr?.next
		ptr?.next = temp
		temp = ptr
		print(temp?.chainDes ?? "")
		ptr = next
	}
	list.head = temp
}
let list_1 = List(with: [1, 3, 5, 7, 8, 10, 12])
reverse_1(list: list_1)
print(list_1)

// 反转链表_递归
func reverse_2(list: List) {
	guard list.head != nil, list.head?.next != nil else { return }
	func reverse(head: List.Node?) -> List.Node? {
		guard let h = head, let next = h.next else { return head }
		let node = reverse(head: next)
		next.next = h
		h.next = nil
		return node
	}
	let node = reverse(head: list.head)
	list.head = node
}
//reverse_2(list: list_1)
//print(list_1)

// 栈排序
func sort<T: Comparable>(stack: Stack<T>) -> Stack<T> {
	let temp = Stack<T>()
	while !stack.isEmpty, let top = stack.pop() {
		while !temp.isEmpty, let current = temp.top, current > top {
			stack.push(current)
			temp.pop()
		}
		temp.push(top)
	}
	return temp
}
//let stack_1 = Stack<Int>([3, 7, 2, 9, 16, 8])
//let sortedStack_1 = sort(stack: stack_1)
//print(sortedStack_1)

var cacheMap = [Int: Int64]()
func fibonacci(n: Int) -> Int64 {
	guard n >= 0 else { return -1 }
	guard let cache = cacheMap[n] else {
		let result: Int64
		switch n {
		case 0, 1:
			result =  Int64(n)
		case 2:
			result = 1
		default:
			result = fibonacci(n: n-1) + fibonacci(n: n - 2)
		}
		cacheMap[n] = result
		return result
	}
	return cache
}

//print(fibonacci(n: 64))

var sortList = [10, 8, 7, 6, 4, 3, 2, 1]
func quickSorted_1<T: Comparable>(list: [T]) -> [T] {
	guard list.count > 1 else { return list }
	let center = list[list.count/2]
	let less = list.filter { $0 < center }
	let equal = list.filter { $0 == center }
	let greater = list.filter { $0 > center }
	return quickSorted_1(list: less) + equal + quickSorted_1(list: greater)
	
}


//let quickSortResult_1 = quickSorted_1(list: sortList)
//print(quickSortResult_1)

func quickSort_2<T: Comparable>(list: inout [T], left: Int, right: Int) {
	guard list.count > 1 else { return }
	
	func helper(list: inout [T], left: Int, right: Int) -> Int {
		let pivot = list[right]
		var i = left
		for j in left ..< right {
			if list[j] <= pivot {
				list.swapAt(i, j)
				i += 1
			}
		}
		list.swapAt(i, right)
		return i
	}
	
	if left < right {
		let p = helper(list: &list, left: left, right: right)
		quickSort_2(list: &list, left: left, right: p - 1)
		quickSort_2(list: &list, left: p + 1, right: right)
	}
}

//quickSort_2(list: &sortList, left: 0, right: sortList.count - 1)
//print(sortList)

var swapCount = 0
var compareCount = 0
func bubbleSort<T: Comparable>(list: inout [T]) {
	guard list.count > 1 else { return }
	for i in 0 ..< list.count {
		for j in 1 ..< list.count - i {
			compareCount += 1
			if list[j - 1] > list[j]  {
				swapCount += 1
				list.swapAt(j, j - 1)
			}
		}
	}
}

//bubbleSort(list: &sortList)
//print(sortList)
