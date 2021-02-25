import Foundation

// 找出数组中的重复数字
// 在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。
// 数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。
// 请找出数组中任意一个重复的数字。

func findDuplicatedNumber(in array: [Int]) -> Int {
	var array = array
	for i in 0 ..< array.count {
		if i == array[i] { continue }
		if array[i] == array[array[i]] { return array[i] }
		array.swapAt(i, array[i])
	}
	return -1
}

var test = [0, 4, 3, 2, 1, 6, 7, 3]
print(findDuplicatedNumber(in: test))