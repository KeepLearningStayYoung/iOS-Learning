import Foundation

class Interview {
    
    // 二分查找(非递归)
    static func binarySearch_1<T: Comparable>(target: T, in array: [T], with range: Range<Int>) -> Int? {
        guard range.lowerBound <= range.upperBound, range.upperBound <= array.count else { return  nil }
        var left = range.lowerBound, right = array.count, mid = 0
        while left <= right {
            mid = left + (right - left)/2
            if array[mid] == target {
                return mid
            } else if array[mid] < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return nil
    }
    
    // 二分查找(递归)
    static func binarySearch_2<T: Comparable>(target: T, in array: [T], with range: Range<Int>) -> Int? {
        guard range.lowerBound <= range.upperBound, range.upperBound <= array.count else { return nil }
        let mid = range.lowerBound + (range.upperBound - range.lowerBound)/2
        if array[mid] == target {
            return mid
        } else if array[mid] < target {
            return binarySearch_2(target: target, in: array, with: mid + 1 ..< range.upperBound)
        } else {
            return binarySearch_2(target: target, in: array, with: range.lowerBound ..< mid - 1)
        }
    }
    
}
