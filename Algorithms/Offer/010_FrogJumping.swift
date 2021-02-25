import Foundation

// 一只青蛙一次可以跳上1级台阶，也可以跳上2级台阶。
// 求该青蛙跳上一个 n 级的台阶总共有多少种跳法。
// 答案需要取模 1e9+7（1000000007），
// 如计算初始结果为：1000000008，请返回 1。

// 递归法
// 时间复杂度：O(n)
// 空间复杂度：O(n)
var cacheMap = [Int: Int]()
func jumpResult_1(n: Int) -> Int {
	guard n >= 0 else { return 0 }
	if let result = cacheMap[n] {
		return result
	}
	var result: Int
	switch n {
		case 0, 1:
		result = 1
		default:
		result = jumpResult_1(n: n - 1) + jumpResult_1(n: n - 2)
	}
	cacheMap[n] = result
	return result
}

// 动态规划
// 时间复杂度：O(n)
// 空间复杂度：O(1)
func jumpResult_2(n: Int) -> Int {
	guard n >= 0 else { return 0 }
	switch n {
		case 0, 1:
			return 1
		default:
		var a = 1, b = 1
		for _ in 2 ... n {
			let temp = a + b
			a = b
			b = temp
		}
		return b
	}
}

for n in 0 ..< 60 {
	print("n: \(n) result: \(jumpResult_1(n: n) == jumpResult_2(n: n))")
}