import Foundation

// 写一个函数，输入 n ，求斐波那契（Fibonacci）数列的第 n 项（即 F(N)）。斐波那契数列的定义如下：
// F(0) = 0,   F(1) = 1
// F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
// 斐波那契数列由 0 和 1 开始，之后的斐波那契数就是由之前的两数相加而得出。
// 答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

// 递归法
// 时间复杂度：O(n)
// 空间复杂度：O(n)
var cacheMap = [Int: Int]()
func fibonacci_1(n: Int) -> Int {
	guard n >= 0 else { return 0 }
	if let result = cacheMap[n] {
		return result
	}
	var result: Int
	switch n {
		case 0, 1:
		result = n
		default:
		result = fibonacci_1(n: n - 1) + fibonacci_1(n: n - 2)
	}
	cacheMap[n] = result
	return result
}

// 动态规划
// 时间复杂度：O(n)
// 空间复杂度：O(1)
func fibonacci_2(n: Int) -> Int {
	guard n >= 0 else { return 0 }
	switch n {
		case 0, 1:
			return n
		default:
		var a = 0, b = 1
		for _ in 2 ... n {
			let temp = a + b
			a = b
			b = temp
		}
		return b
	}
}

for n in 0 ..< 60 {
	print("n: \(n) result: \(fibonacci_1(n: n) == fibonacci_2(n: n))")
}
