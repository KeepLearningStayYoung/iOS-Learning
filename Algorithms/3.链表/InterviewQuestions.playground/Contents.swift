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

class Interview {
    // 节点实现
    class ListNode: CustomDebugStringConvertible {
        
        // 节点值
        var value: Int
        
        // 下一个节点
        var next: ListNode?
        
        // 调试信息
        var debugDescription: String {
            if let next = next {
                return "value: \(value), next: \(next.value)"
            } else {
                return "value: \(value), next: empty"
            }
        }
        
        init(_ value: Int) {
            self.value = value
            self.next = nil
        }
        
        // 以自身作为头部构建一个新链表
        func list() -> List {
            return List(with: self)
        }
        
    }
    
    // 链表实现
    class List: CustomDebugStringConvertible {
        
        // 头部
        var head: ListNode?
        
        // 尾部
        var tail: ListNode?
        
        init() {
            
        }
        
        // 从数组初始化为一个新链表
        convenience init(with values: [Int]) {
            self.init()
            for value in values {
                appendToTail(with: value)
            }
        }
        
        // 以给定节点作为头部，构建一个新链表
        convenience init(with head: ListNode?) {
            self.init()
            self.head = head
        }
        
        // 调试信息
        var debugDescription: String {
            var text: String = ""
            var current = head
            while current != nil {
                if current?.next != nil {
                    text += (String(current?.value ?? 0) + " -> ")
                } else {
                    text += String(current?.value ?? 0)
                }
                current = current?.next
            }
            return text
        }
        
        // 尾插值
        func appendToTail(with value: Int) {
            let newNode = ListNode(value)
            if tail == nil {
                // 新建链表
                tail = newNode
                head = tail
            } else {
                // 插入新元素至尾部，更新尾部位置
                tail?.next = newNode
                tail = tail?.next
            }
        }
        
        // 尾插节点
        func appendToTail(with node: ListNode?) {
            if tail == nil {
                tail = node
                head = tail
            } else {
                tail?.next = node
                tail = tail?.next
            }
        }
        
        // 头插值
        func appendToHead(with value: Int) {
            if head == nil {
                // 新建链表
                head = ListNode(value)
                tail = head
            } else {
                // 新建节点，节点的next为头部，然后更新头部位置
                let temp = ListNode(value)
                temp.next = head
                head = temp
            }
        }
        
        // 头插节点
        func appendToHead(with node: ListNode?) {
            if head == nil {
                head = node
                tail = head
            } else {
                node?.next = head
                head = node
            }
        }
                
        // 寻找第一个满足条件的节点
        func firstNode(where condition: (ListNode) -> Bool) -> ListNode? {
            var node = head
            while node != nil {
                if let wrappedNode = node, condition(wrappedNode) {
                    return wrappedNode
                }
                node = node?.next
            }
            return nil
        }
        
        // 删除第一个满足条件的节点
        func removeFirst(where condition: (ListNode) -> Bool) {
            let dummyNode = ListNode(0)
            dummyNode.next = head
            var node: ListNode? = dummyNode
            while node != nil {
                if let wrappedNode = node?.next, condition(wrappedNode) {
                    node?.next = node?.next?.next
                    return
                }
                node = node?.next
            }
        }
        
        // 删除所有满足条件的节点
        func removeAll(where condition: (ListNode) -> Bool) {
            let dymmyNode = ListNode(0)
            dymmyNode.next = head
            var node: ListNode? = dymmyNode
            while node != nil {
                if let wrappedNode = node?.next, condition(wrappedNode) {
                    node?.next = node?.next?.next
                } else {
                    node = node?.next
                }
            }
        }
        
    }
    
    // 给出一个链表和一个值x，要求将链表中所有小于x的值放到左边，所有大于或等于x的值放到右边，且原链表的节点顺序不变
    static func question1(list: List?, target: Int) -> List? {
        guard list != nil else { return nil }
        let preDummy: ListNode? = ListNode(0), postDummy: ListNode? = ListNode(0)
        
        // 创建两个工具节点分别连接左侧和右侧节点
        var pre = preDummy, post = postDummy, node = list?.head
        while node != nil {
            if node?.value < target {
                // 左侧连接比target小的节点
                pre?.next = node
                pre = node
            } else {
                // 右侧连接比target大的节点
                post?.next = node
                post = node
            }
            node = node?.next
        }
        // 清除两个链表的尾部防止成环
        post?.next = nil
        pre?.next = nil
        // 连接左右两个链表
        pre?.next = postDummy?.next
        return preDummy?.next?.list()
    }
    
    // 检测链表是否有环，使用快慢指针
    static func question2(list: List?) -> Bool {
        guard list != nil else { return false }
        var slow = list?.head
        var fast = list?.head
        
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            // 若链表成环，则一定会有快慢指针重合的时候
            if slow === fast {
                return true
            }
        }
        return false
    }
    
    // 删除链表中倒数第n个节点(n小于等于链表长度)，使用双指针
    static func question3(list: List?, n: Int) {
        guard list != nil, n > 0 else { return }
        
        let dummyNode = ListNode(0)
        dummyNode.next = list?.head
        
        var pre: ListNode? = dummyNode
        var post: ListNode? = dummyNode
        
        for _ in 0 ..< n {
            post = post?.next
        }
        
        while post != nil && post?.next != nil {
            pre = pre?.next
            post = post?.next
        }
        pre?.next = pre?.next?.next
    }
    
    static func test(list: List) {
        var pre: ListNode?
        var head = list.head
        
        while head != nil {
            let next = head?.next
            print("next: \(next?.list())")
            head?.next = pre
            print("head: \(head?.list())")
            pre = head
            print("pre: \(pre?.list())")
            head = next
            print("head: \(head?.list())")
            
        }
        list.head = pre
    }
    
    
}

// 给出一个链表和一个值x，要求将链表中所有小于x的值放到左边，所有大于或等于x的值放到右边，且原链表的节点顺序不变
let list1 = Interview.List(with: [1, 5, 3, 2, 4, 2])
let target1 = 3
let result1 = Interview.question1(list: list1, target: target1)
//print("List1 process result: \(String(describing: result1))")


// 检测链表是否有环，使用快慢指针
let list2 = Interview.List(with: [1, 5, 3, 2, 4, 2, 6])
//print("List2 contains rings: \(Interview.question2(list: list2))")
let ringTarget2 = list2.firstNode { $0.value == 3 }
let lastNode2 = list2.tail
// 将list2连接成环
lastNode2?.next = ringTarget2
//print("List2 contains rings: \(Interview.question2(list: list2))")


// 删除链表中倒数第n个节点(n小于等于链表长度)，使用双指针
let list3 = Interview.List(with: [1, 2, 3, 3, 4, 5])
let n3 = 2
Interview.question3(list: list3, n: n3)
//print("List3 process result: \(list3)")

let testList = Interview.List(with: [1, 5, 7, 9])
print(testList)
Interview.test(list: testList)
print(testList)

