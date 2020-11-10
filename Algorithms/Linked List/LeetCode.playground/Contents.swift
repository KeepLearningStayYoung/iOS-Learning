import Foundation


extension Optional: Comparable where Wrapped: Comparable {
    
    public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        guard let lhsValue = lhs, let rhsValue = lhs else { return false }
        return lhsValue < rhsValue
    }
    
    public static func < (lhs: Optional<Wrapped>, rhs: Wrapped) -> Bool {
        guard let lhsValue = lhs else { return false }
        return lhsValue < rhs
    }
    
    public static func < (lhs: Wrapped, rhs: Optional<Wrapped>) -> Bool {
        guard let rhsValue = rhs else { return false }
        return lhs < rhsValue
    }
    
}

class LeetCode {
    
    class ListNode: CustomDebugStringConvertible, Equatable {
        
        static func == (lhs: LeetCode.ListNode, rhs: LeetCode.ListNode) -> Bool {
            return lhs.val == rhs.val
        }
        
        var val: Int
        
        var next: ListNode?
        
        var debugDescription: String {
            var text: String = ""
            var current: ListNode? = self
            while current != nil {
                if current?.next != nil {
                    text += (String(current?.val ?? 0) + " -> ")
                } else {
                    text += String(current?.val ?? 0)
                }
                current = current?.next
            }
            return text
        }
        
        init(_ val: Int) {
            self.val = val
            self.next = nil
        }
        
        init(_ vals: [Int]) {
            if let first = vals.first {
                val = first
                for i in 1 ..< vals.count {
                    appendTail(vals[i])
                }
            } else {
                val = 0
                self.next = nil
            }
        }
        
        @discardableResult
        func appendTail(_ val: Int) -> Self {
            let new = ListNode(val)
            var current: ListNode? = self
            while current?.next != nil {
                current = current?.next
            }
            current?.next = new
            return self
        }
        
        @discardableResult
        func append(_ vals: [Int]) -> Self {
            for val in vals {
                self.appendTail(val)
            }
            return self
        }
        
        func target(value: Int) -> ListNode? {
            var current: ListNode? = self
            while current?.val != value && current?.next != nil {
                current = current?.next
            }
            return current
        }
        
    }
    
    // LeetCode - 21: 合并两个有序链表(非递归), Easy
    class func solution21_1(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        var l1 = list1, l2 = list2
        var prev: ListNode?
        let preHead = ListNode(-1)
        prev = preHead
        while l1 != nil && l2 != nil, let val1 = l1?.val, let val2 = l2?.val {
            if val1 <= val2 {
                prev?.next = l1
                l1 = l1?.next
            } else {
                prev?.next = l2
                l2 = l2?.next
            }
            prev = prev?.next
        }
        prev?.next = l1 ?? l2
        return preHead.next
    }
    
    // LeetCode - 21: 合并两个有序链表(递归), Easy
    class func solution21_2(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        
        guard let value1 = list1?.val else { return list2 }
        guard let value2 = list2?.val else { return list1 }
        
        if value1 < value2 {
            list1?.next = solution21_2(list1?.next, list2)
            return list1
        } else {
            list2?.next = solution21_2(list2?.next, list1)
            return list2
        }
    }
    // LeetCode - 83: 删除排序列表中的重复元素, Easy
    class func solution83(_ head: ListNode?) -> ListNode? {
        let headFlag = head
        var node = head
        while node != nil && node?.next != nil {
            if node?.val == node?.next?.val {
                node?.next = node?.next?.next
            } else {
                node = node?.next
            }
        }
        return headFlag
    }
    // LeetCode - 141: 给定一个链表，判断链表中是否有环, Easy
    class func solution141(_ head: ListNode?) -> Bool {
        guard head != nil else { return false }
        var slow = head
        var fast = head
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            if slow === fast {
                return true
            }
        }
        return false
    }
    // LeetCode - 160: 编写一个程序，找到两个单链表相交的起始节点, Easy
    class func solution160(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        guard headA != nil, headB != nil else { return nil }
        var listA = headA, listB = headB
        while listA !== listB {
            listA = listA == nil ? headB : listA?.next
            listB = listB == nil ? headA : listB?.next
        }
        return listA
    }
    
    // LeetCode - 203: 移除链表元素, Easy
    class func solution203(_ head: ListNode?, _ val: Int) -> ListNode? {
        guard head != nil else { return nil }
        let dummyNode = ListNode(0)
        dummyNode.next = head
        var preNode: ListNode? = dummyNode
        var current = head
        while current != nil {
            if current?.val == val {
                preNode?.next = current?.next
            } else {
                preNode = preNode?.next
            }
            current = current?.next
        }
        return dummyNode.next
    }
    
    // LeetCode - 206: 反转链表（非递归）, Easy
    class func solution206_1(_ head: ListNode?) -> ListNode? {
        
    }
    
    // LeetCode - 206: 反转链表（递归）, Easy
    class func solution206_2(_ head: ListNode?) -> ListNode? {
        
    }
    
    // LeetCode - 237: 删除链表中的节点, Easy
    class func solution237(_ node: ListNode?) {
        if let nextNode = node?.next {
            node?.val = nextNode.val
            node?.next = node?.next?.next
        }
    }
}


