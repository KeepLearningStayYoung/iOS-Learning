# [The Swift Programming Language](https://docs.swift.org/swift-book/)

基于Swift 5.3

## [The Basics](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)

- Swift是类型安全的语言，很多语言存在的隐式转换在Swift中并不存在。比如Swift中只能在相同类型下进行算术运算，如果将Int和Double直接进行运算，编译器会报错。

  > Swift is a *type-safe* language, which means the language helps you to be clear about the types of values your code can work with.
  >
  > Type safety helps you catch and fix errors as early as possible in the development process.

- 在Swift中，除了assert，还有precondition可以起到相同的作用，并且assert只能在debug环境下起作用，precondition在debug和production环境下都能起作用（虽然一般用不到）

  > Assertions are checked only in debug builds, but preconditions are checked in both debug and production builds.
  >
  > If you compile in unchecked mode (-Ounchecked), preconditions aren’t checked.
  >
  > In `-O` builds (the default for Xcode’s Release configuration), `condition` is not evaluated, and there are no effects.
  >
  > In `-O` builds (the default for Xcode’s Release configuration): If `condition`evaluates to `false`, stop program execution.

## [Basic Operators](https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html)

- Swift中仅有的一个三元操作符是`(a ? b : c)`

  > Swift has only one ternary operator, the ternary conditional operator (`a ? b : c`).

- 复合赋值操作符是没有返回值的，像`let b = a += 2`编译器会报warning，按照warning建议修改后，会变成`let b: () = a += 2`（将任意一个无返回值的函数赋值给一个变量，都会要求这样修改），改完后，代码调用`b`相当于调用`a += 2`

  > The compound assignment operators don’t return a value. For example, you can’t write let b = a += 2.

- 在Swift中，`%`代表取余操作。  进行取余操作时，除数的符号是会被忽略的，即`a % b`的结果跟`a % -b`一致（即遵循尽可能让商向0靠近的原则）

  > The remainder operator (`%`) is also known as a *modulo operator* in other languages. However, its behavior in Swift for negative numbers means that, strictly speaking, it’s a remainder rather than a modulo operation.
  >
  > The sign of `b` is ignored for negative values of `b`. This means that `a % b` and `a % -b` always give the same answer.

- Swift中，可以直接对少于7个元素的元组进行比较（保证元组的同一位置的元素是同类型且遵循Comparable协议，且元组中元素个数一致）

  > You can compare two tuples if they have the same type and the same number of values.The Swift standard library includes tuple comparison operators for tuples with fewer than seven elements.

- Swift中的空合并运算符（`??`）实行的是短路运算，对于`a ?? b`，当a不为nil时，b就不会执行

  > a ?? b : If the value of a is non-nil, the value of b is not evaluated. This is known as *short-circuit evaluation*.