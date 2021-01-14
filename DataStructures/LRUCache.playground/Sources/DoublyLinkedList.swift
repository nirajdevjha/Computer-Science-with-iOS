import Foundation
import XCTest

/// A Node class to represent data objects in the LinkedList class
public class Node<T> {
    public var value: T
    var previous: Node<T>?
    var next: Node<T>?

    init(value: T) {
        self.value = value
    }
}

/// An implementation of a generic doubly linkedList.
public class DoublyLinkedList<T> {
    public var head: Node<T>?
    public var tail: Node<T>?
    var isEmpty: Bool {
        return head == nil && tail == nil
    }

    public var count: Int = 0

    public init() {}

    /// print the values of each node in order in the LinkedList
    public func prettyPrint() {
        var nodes = [T]()
        var currNode = head
        while currNode != nil {
            nodes.append(currNode!.value)
            currNode = currNode?.next
        }
        print(nodes)
    }

    /// traverses the nodes and returns the node at the given index and nil if no nodes are found in the LinkedList.
    /// The head starting at index 0.
    func node(at index: Int) -> Node<T>? {
        guard !isEmpty || index == 0 else {
            return head
        }

        var node = head
        for _ in stride(from: 0, to: index, by: 1) {
            node = node?.next
        }

        return node
    }

    /// Adds a node from the value to the LinkedList.
    func add(value: T) {
        let node = Node(value: value)

        guard !isEmpty else {
            head = node
            tail = node
            count += 1
            return
        }

        node.previous = tail
        tail?.next = node
        tail = node
        count += 1
    }

    /// The head starting at index 0
    /// returns bool indicating wether or not the insert was successful.
    public func insert(value: T, at index: Int) -> Bool {
        guard !isEmpty else {
            add(value: value)
            return true
        }

        guard case 0..<count = index else {
            print("NOT WITHIN HERE")
            return false
        }

        let newNode = Node(value: value)

        var currNode = head
        for _ in stride(from: 0, to: index - 1, by: 1) {
            currNode = currNode?.next
        }

        if currNode === head {
            if head === tail {
                newNode.next = head
                head?.previous = newNode
                head = newNode
            } else {
                newNode.next = head
                head = newNode
            }

            count += 1
            return true
        }

        newNode.previous = currNode
        newNode.next = currNode?.next
        currNode?.next?.previous = newNode
        currNode?.next = newNode

        count += 1
        return true
    }

    /// The head of the LinkedList starting at index 0
    /// Returns bool indicating wether or not the remove was successful
    func remove(at index: Int) -> Bool {
        guard case 0..<count = index else {
            return false
        }

        var currNode = head
        for _ in stride(from: 0, to: index, by: 1) {
            currNode = currNode?.next
        }

        if currNode === head {
            if head === tail {
               head = nil
               tail = nil
            } else {
               head?.next?.previous = nil
               head = head?.next
            }
            count -= 1
            return true
        }

        currNode?.previous?.next = currNode?.next
        currNode?.next?.previous = currNode?.previous

        count -= 1
        return true
    }

    /// Removes the last element from the linkedlist.
    public func remove() -> Bool {
        guard !isEmpty else {
            return false
        }

        if head === tail {
            head = nil
            tail = nil
            count -= 1
            return true
        }

        tail?.previous?.next = nil
        tail = tail?.previous

        count -= 1
        return true
    }

    public func moveToHead(node: Node<T>) {
        guard !isEmpty else {
            return
        }

        if head === node && tail === node {
            // do nothing
        } else if head === node {
            // do nothing
        } else if tail === node {
            tail?.previous?.next = nil
            tail = tail?.previous

            let prevHead = head
            head?.next?.previous = node
            head = node
            head?.next = prevHead
        } else {
            var currNode = head
            while currNode?.next !== node && currNode !== tail {
                currNode = currNode?.next
            }

            currNode?.next = node.next
            node.next?.previous = currNode

            let prevHead = head
            head = node
            head?.next = prevHead
            prevHead?.previous = head
        }
    }
}


public class TestDoublyLinkedList: XCTestCase {

    var linkedList = DoublyLinkedList<Int>()

    func testFirstCase() {
        let node = Node(value: 5)

        linkedList.moveToHead(node: node)

        XCTAssert(linkedList.isEmpty ==  true)
    }

    func testSecondCase() {

        linkedList.add(value: 5)
        linkedList.add(value: 4)
        linkedList.moveToHead(node: linkedList.tail!)

        XCTAssert(linkedList.isEmpty == false)
        XCTAssert(linkedList.head?.value == 4)
        XCTAssert(linkedList.tail?.value == 5)
    }

    func testThirdCase() {
        linkedList.add(value: 5)
        linkedList.add(value: 4)
        linkedList.add(value: 3)
        linkedList.moveToHead(node: linkedList.tail!)

        XCTAssert(linkedList.isEmpty == false)
        XCTAssert(linkedList.head?.value == 3)
        XCTAssert(linkedList.head?.next?.value == 5)
        XCTAssert(linkedList.tail?.value == 4)
    }

    func testFourthCase() {
        linkedList.add(value: 5)
        linkedList.moveToHead(node: linkedList.tail!)

        XCTAssert(linkedList.isEmpty == false)
        XCTAssert(linkedList.head?.value == 5)
        XCTAssert(linkedList.tail?.value == 5)
    }

    func testFifthCase() {
        linkedList.add(value: 5)
        linkedList.add(value: 4)
        linkedList.add(value: 3)
        linkedList.add(value: 2)
        linkedList.add(value: 1)

        if let nodey = linkedList.node(at: 2) {
            linkedList.moveToHead(node: nodey)
        }

        XCTAssert(linkedList.head?.value == 3)
        XCTAssert(linkedList.node(at: 1)?.value == 5)
        XCTAssert(linkedList.node(at: 2)?.value == 4)
        XCTAssert(linkedList.node(at: 3)?.value == 2)

        linkedList.prettyPrint()
    }
}