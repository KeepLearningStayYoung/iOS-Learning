import Foundation

// 在一个 n * m 的二维数组中，每一行都按照从左到右递增的顺序排序
// 每一列都按照从上到下递增的顺序排序。
// 请完成一个高效的函数，输入这样的一个二维数组和一个整数
// 判断数组中是否含有该整数。

// 暴力遍历
// 时间复杂度：O(nm)
// 空间复杂度：O(1)
func find_1<T: Comparable>(target: T, in twoDArray: [[T]]) -> (Int, Int) {
	guard twoDArray.count > 0, twoDArray[0].count > 0 else { return (-1, -1) }
	for n in 0 ..< twoDArray.count {
		for m in 0 ..< twoDArray[0].count {
			if twoDArray[n][m] == target {
				return (n, m)
			}
		}
	}
	return (-1, -1)
}


// 线性查找
// 时间复杂度：O(n+m)
// 空间复杂度：O(1)
func find_2<T: Comparable>(target: T, in twoDArray: [[T]]) -> (Int, Int) {
	guard twoDArray.count > 0, twoDArray[0].count > 0 else { return (-1, -1) }
	var n = 0, m = twoDArray[0].count - 1
	while  n < twoDArray.count, m >= 0 {
		if target == twoDArray[n][m] {
			return (n, m)
		} else if target > twoDArray[n][m] {
			n += 1
		} else {
			m -= 1
		}
	}
	return (-1, -1)
}

let test = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15]]

print("\(find_1(target: 9, in: test)) \(find_2(target: 9, in: test))")
