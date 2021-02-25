import Foundation

// 请设计一个函数，用来判断在一个矩阵中是否存在一条包含某字符串所有字符的路径。
// 路径可以从矩阵中的任意一格开始，每一步可以在矩阵中向左、右、上、下移动一格。
// 如果一条路径经过了矩阵的某一格，那么该路径不能再次进入该格子。
// 例如，在下面的3×4的矩阵中包含一条字符串“bfce”的路径。
// [["a","b","c","e"]
// 	["s","f","c","s"]
// 	["a","d","e","e"]]
// 但矩阵中不包含字符串“abfb”的路径，因为字符串的第一个字符b占据了矩阵中的第一行第二个格子之后，路径不能再次进入这个格子。

// 深度优先搜索
func find(path: String, in matrix: inout [[Character]]) -> Bool {
	
	func dfs(_ matrix: inout [[Character]], _ path: String, _ i: Int, _ j: Int, _ k: Int) -> Bool {
		if k >= path.count { return true }
		if i < 0 || j < 0 || i >= matrix.count || j >= matrix[0].count { return false }
		if matrix[i][j] == "1" || matrix[i][j] != path[k] { return false }
		let temp = matrix[i][j]
		matrix[i][j] = "1"
		if dfs(&matrix, path, i + 1, j, k+1) || dfs(&matrix, path, i - 1, j, k+1) || dfs(&matrix, path, i, j + 1, k+1) || dfs(&matrix, path, i, j - 1, k+1) { return true }
		matrix[i][j] = temp
		return false
	}
	
	guard matrix.count > 0, matrix[0].count > 0, path.count > 0 else { return false }
	
	for i in 0 ..< matrix.count {
		for j in 0 ..< matrix[0].count {
			if dfs(&matrix, path, i, j, 0) {
				return true
			}
		}
	}
	
	return false
}

extension String {
	subscript(index: Int) -> Character? {
		if index > count - 1 || index < 0 { return nil }
		return self[self.index(self.startIndex, offsetBy: index)]
	}
}

var test: [[Character]] = [["a","b","c","e"], ["s","f","c","s"], ["a","d","e","e"]]

let result = find(path: "bfce", in: &test)

print(result)

print(test)

class Stack<T: Any>: CustomDebugStringConvertible {
	
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
