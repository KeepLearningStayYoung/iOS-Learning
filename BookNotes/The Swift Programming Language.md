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

## [Strings and Characters](https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html)

- Swift中可以用两个`"""`来声明多行的String，如果单行的字符串过长，可以用`\`来进行换行，这种方式不会影响最终字符串的换行，只是让代码可读性更强

  > If you need a string that spans several lines, use a multiline string literal—a sequence of characters surrounded by three double quotation marks:
  >
  > ```Swift
  > let quotation = """
  > The White Rabbit put on his spectacles.  "Where shall I begin, please your Majesty?" he asked.
  > 
  > "Begin at the beginning," the King said gravely, "and go on till you come to the end; then stop."
  > """
  > ```
  >
  > If you want to use line breaks to make your source code easier to read, but you don’t want the line breaks to be part of the string’s value, write a backslash (`\`) at the end of those lines
  >
  > ```Swift
  > let softWrappedQuotation = """
  > The White Rabbit put on his spectacles.  "Where shall I begin, \
  > please your Majesty?" he asked.
  > 
  > "Begin at the beginning," the King said gravely, "and go on \
  > till you come to the end; then stop."
  > """
  > ```

- 与`NSString`不同的是，Swift中的`String`是**值类型**，在使用过程中，方法传递或者赋值的是拷贝后的值，不用担心会改变原始的值。不过编译器会进行优化，只有在真正需要的时候才会进行拷贝

  > Swift’s `String` type is a *value type*. If you create a new `String` value, that `String` value is *copied* when it’s passed to a function or method, or when it’s assigned to a constant or variable
  >
  > Swift’s copy-by-default `String` behavior ensures that when a function or method passes you a `String` value, it’s clear that you own that exact `String` value, regardless of where it came from. You can be confident that the string you are passed won’t be modified unless you modify it yourself.
  >
  > Behind the scenes, Swift’s compiler optimizes string usage so that actual copying takes place only when absolutely necessary. This means you always get great performance when working with strings as value types.

- `String`之间可以直接用`+`进行拼接，`String`也可以通过`append()`方法拼接`Character`，但是不能对`Character`进行拼接，因为`Character`只能包含一个字符

  > You can’t append a `String` or `Character` to an existing `Character` variable, because a `Character` value must contain a single character only.

- Swift中，每个`Character`代表一个扩展字形簇（`extended graheme cluster`），每个extended grapheme cluster是由一个或多个`unicode scalar`组成的。不同的extended grapheme cluster可能展示出来的字符是一样的

  > Every instance of Swift’s `Character` type represents a single *extended grapheme cluster*. An extended grapheme cluster is a sequence of one or more Unicode scalars that (when combined) produce a single human-readable character.
  >
  > ```Swift
  > let eAcute: Character = "\u{E9}"                         // é
  > let combinedEAcute: Character = "\u{65}\u{301}"          // e followed by ́
  > // eAcute is é, combinedEAcute is é
  > 
  > let precomposed: Character = "\u{D55C}"                  // 한
  > let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"   // ᄒ, ᅡ, ᆫ
  > // precomposed is 한, decomposed is 한
  > ```

- 由于extended grapheme cluster的使用，字符串的拼接和修改可能不会导致`String`的`count`属性发生变化

  > Note that Swift’s use of extended grapheme clusters for `Character` values means that string concatenation and modification may not always affect a string’s character count.
  >
  > ```Swift
  > var word = "cafe"
  > print("the number of characters in \(word) is \(word.count)")
  > // Prints "the number of characters in cafe is 4"
  > 
  > word += "\u{301}"    // COMBINING ACUTE ACCENT, U+0301
  > 
  > print("the number of characters in \(word) is \(word.count)")
  > // Prints "the number of characters in café is 4"
  > ```

- 同一个字符可能是由不同的extended grapheme cluster的展示的（如`é`可能是`\u{E9}`，也可能是`\u{65}\u{301}`），所以每个字符需要占用的内存也不是一致的，这就导致只有在遍历整个字符串之后，才知道整个字符串有多少个`Character`，即`String`的`count`属性是需要遍历整个字符串之后才知道的（这也是`count`时间复杂度是*O(n)*的原因）

  > Extended grapheme clusters can be composed of multiple Unicode scalars. This means that different characters—and different representations of the same character—can require different amounts of memory to store. Because of this, characters in Swift don’t each take up the same amount of memory within a string’s representation. As a result, the number of characters in a string can’t be calculated without iterating through the string to determine its extended grapheme cluster boundaries. If you are working with particularly long string values, be aware that the `count` property must iterate over the Unicode scalars in the entire string in order to determine the characters for that string.

- 对于拥有字符的`String`和`NSString`来说，`String`的`count`返回的值跟`NSString`的`length`返回的值不一定是一致的。NSString的长度是指字符串的UTF-16展示中16位编码单元的数目，而String的长度则是Unicode extended grapheme clusters的个数

  > The count of the characters returned by the `count` property isn’t always the same as the `length` property of an `NSString` that contains the same characters. The length of an `NSString` is based on the number of 16-bit code units within the string’s UTF-16 representation and not the number of Unicode extended grapheme clusters within the string.

- 由于不同的Character需要的内存不一样，为了知道某个Character在String中的具体位置，必须得从开始或者末尾遍历每个Unicode scalar，这也是Swift中字符串不能用整数直接作为索引的原因

  > As mentioned above, different characters can require different amounts of memory to store, so in order to determine which `Character` is at a particular position, you must iterate over each Unicode scalar from the start or end of that `String`. For this reason, Swift strings can’t be indexed by integer values.

- `Substring`只适合短时间存在，因为substring实际上是复用的原始的string的内存空间，在substring存在期间，原始string的整个内存都不能被释放（除非你将substring转成`String`）

  > you use substrings for only a short amount of time while performing actions on a string. When you’re ready to store the result for a longer time, you convert the substring to an instance of `String`.
  >
  > The difference between strings and substrings is that, as a performance optimization, a substring can reuse part of the memory that’s used to store the original string, or part of the memory that’s used to store another substring. (Strings have a similar optimization, but if two strings share memory, they are equal.) This performance optimization means you don’t have to pay the performance cost of copying memory until you modify either the string or substring. As mentioned above, substrings aren’t suitable for long-term storage—because they reuse the storage of the original string, the entire original string must be kept in memory as long as any of its substrings are being used.

- 对于不同的Extended grapheme clusters，就算组成它们的Unicode scalars不同，只要它们的语义和外观是一致的，它们就可以认为是等价的（*canonically equivalent*）。Swift中，只要两个字符串的extended grapheme clusters等价，就认为这两个字符串是相等的

  > Two `String` values (or two `Character` values) are considered equal if their extended grapheme clusters are *canonically equivalent*. Extended grapheme clusters are canonically equivalent if they have the same linguistic meaning and appearance, even if they’re composed from different Unicode scalars behind the scenes.
  >
  > ```Swift
  > // "Voulez-vous un café?" using LATIN SMALL LETTER E WITH ACUTE
  > let eAcuteQuestion = "Voulez-vous un caf\u{E9}?"
  > 
  > // "Voulez-vous un café?" using LATIN SMALL LETTER E and COMBINING ACUTE ACCENT
  > let combinedEAcuteQuestion = "Voulez-vous un caf\u{65}\u{301}?"
  > 
  > if eAcuteQuestion == combinedEAcuteQuestion {
  >     print("These two strings are considered equal")
  > }
  > // Prints "These two strings are considered equal"
  > ```
  >
  > Conversely, `LATIN CAPITAL LETTER A` (`U+0041`, or `"A"`), as used in English, is *not* equivalent to `CYRILLIC CAPITAL LETTER A` (`U+0410`, or `"А"`), as used in Russian. The characters are visually similar, but don’t have the same linguistic meaning
  >
  > ```Swift
  > let latinCapitalLetterA: Character = "\u{41}"
  > 
  > let cyrillicCapitalLetterA: Character = "\u{0410}"
  > 
  > if latinCapitalLetterA != cyrillicCapitalLetterA {
  >     print("These two characters are not equivalent.")
  > }
  > // Prints "These two characters are not equivalent."
  > ```
  >
  > 