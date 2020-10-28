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