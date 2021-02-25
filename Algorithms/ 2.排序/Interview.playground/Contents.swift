import Foundation

class Interview {
    
    /// Bad
    
    /// 冒泡排序
    /// Runtime:
    ///  - Average: O(n^2)
    ///  - Worst: O(n^2)
    static func bubbleSort<T: Comparable>(_ array: inout [T]) -> [T] {
        for _ in  0 ..< array.count {
            for j in 1 ..< array.count {
                if array[j] < array[j - 1] {
                    let temp = array[j - 1]
                    array[j - 1] = array[j]
                    array[j] = temp
                }
            }
        }
        return array
    }
    
    /// 选择排序
    /// Runtime:
    ///  - Worst: O(n^2)
    static func selectSort<T: Comparable>(_ array: inout [T]) -> [T] {
        guard array.count > 1 else { return array }
        for i in 0 ..< array.count - 1 {
            var minIndex = i
            for j in i + 1 ..< array.count {
                if array[j] < array[minIndex] {
                    minIndex = j
                }
            }
            if minIndex != i {
                array.swapAt(minIndex, i)
            }
        }
        return array
    }
    
    /// 快速排序(递归)
    static func quickSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        let pivot = array[array.count/2]
        let smaller = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        return quickSort(smaller) + equal + quickSort(greater)
    }
    
    
}

var test = [32, 34, 53, 1, 2, 54, 14, 26, 23]
// print(Interview.bubbleSort(&test))
 print(Interview.selectSort(&test))

