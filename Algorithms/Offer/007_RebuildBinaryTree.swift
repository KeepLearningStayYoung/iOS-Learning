import Foundation

// 输入某二叉树的前序遍历和中序遍历的结果，请重建该二叉树。
// 假设输入的前序遍历和中序遍历的结果中都不含重复的数字。
// 例如：
// 前序遍历 preorder = [3, 9, 20, 15, 7]
// 中序遍历 inorder = [9, 3, 15, 20, 7]
// 返回二叉树：
//     3
//   /   \
//  9     20
//       /  \
//      15   7


// 递归
func rebuildTree(preorder: [Int], inorder: [Int]) -> TreeNode<Int>? {
	guard preorder.count > 0 && inorder.count > 0 && preorder.count == inorder.count else { return nil }
	
	let root = TreeNode<Int>(preorder[0])
	
	for (index, value) in inorder.enumerated() {
		if value == root.value {
			root.left = rebuildTree(preorder: Array(preorder[1 ..< index + 1]), inorder: Array(inorder[0 ..< index]))
			root.right = rebuildTree(preorder: Array(preorder[index + 1 ..< preorder.endIndex]), inorder: Array(inorder[index + 1 ..< inorder.endIndex]))
		}
	}
	return root
}

let tree = rebuildTree(preorder: [3, 9, 20, 15, 7], inorder: [9, 3, 15, 20, 7])
prePrint(tree)


class TreeNode<T: Comparable> {
	
	var value: T
	
	var left: TreeNode<T>?
	
	var right: TreeNode<T>?
	
	init(_ value: T) {
		self.value = value
	}
	
	func setLeft(_ value: T) -> Self {
		let leftNode = TreeNode<T>(value)
		self.left = leftNode
		return self
	}
	
	func setLeft(_ node: TreeNode<T>) -> Self {
		self.left = node
		return self
	}
	
	func setRight(_ value: T) -> Self {
		let rightNode = TreeNode<T>(value)
		self.right = rightNode
		return self
	}
	
	func setRight(_ node: TreeNode<T>) -> Self {
		self.right = node
		return self
	}
	
}

func prePrint<T: Comparable>(_ node: TreeNode<T>?) {
	guard let node = node else { return }
	print(node.value)
	prePrint(node.left)
	prePrint(node.right)
}

func inPrint<T: Comparable>(_ node: TreeNode<T>?) {
	guard let node = node else { return }
	inPrint(node.left)
	print(node.value)
	inPrint(node.right)
}

func sufPrint<T: Comparable>(_ node: TreeNode<T>?) {
	guard let node = node else { return }
	sufPrint(node.left)
	sufPrint(node.right)
	print(node.value)
}