import Foundation

// 把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。
// 输入一个递增排序的数组的一个旋转，输出旋转数组的最小元素。
// 例如，数组 [3,4,5,1,2] 为 [1,2,3,4,5] 的一个旋转，该数组的最小值为1。

// 二分法
// 时间复杂度：O(logn)
// 空间复杂度：O(1)
func findMin<T: Comparable>(in array: [T]) -> T {
	var i = 0, j = array.count - 1
	while(i < j) {
		let m = (j - i)/2 + i
		if array[m] > array[j] { 
			i = m + 1
		} else if array[m] < array[j] {
			j = m
		} else {
			j -= 1
		}
	}
	return array[j]
}

let test = [3, 5, 7, 1, 2]
print(findMin(in: test))