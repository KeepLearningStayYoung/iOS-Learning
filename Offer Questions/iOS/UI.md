# 常见UI面试题

#### 简述iOS事件传递及响应链

UIKit中事件传递主要依靠`UIResponder`及其子类，常见的子类包括`UIView`、`UIViewController`和`UIApplication`, `UIResponder`及其子类主要能处理的事件包括触摸事件(`UITouch`)、加速传感器、远程控制事件等等。触摸事件主要通过以下四个方法来获取回调：

```Swift
open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
```
**确定触摸事件的第一响应者**

例如，当发生触摸事件时，`UIApplication`会触发`func sendEvent(_ event: UIEvent)`将封装好的`UIEvent`传递给当前的`UIWindow`，`UIWindow`会继续传给`UIViewController`，接下来传给`UIViewController`的根view，从这里开始视图层级将变得复杂起来。
确定第一响应者过程中有一个关键函数：
```
func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
```
称之为命中测试(hit-testing), 具体过程如下：

- 检查自身是否同时符合以下三个条件：

1. `view.isUserInteractionEnabled = true`
2. `view.alpha > 0.01`
3. `view.isHidden = false`

- 检查坐标是否在自身内部，这里使用了关键函数：

`func point(inside point: CGPoint, with event: UIEvent?) -> Bool`

该方法还可以被重写来实现更多扩展功能，例如支持超出自身范围内的子view响应点击事件

- 从后往前遍历子视图(以FILO原则)重新开始命中测试，原因是最后添加的view显示在层级最上方，也是用户最可能发生触摸行为的视图

- 若没有子视图能响应该事件，则最终响应事件的视图就是自身。

逻辑大概如下：

```
	func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard isUserInteractionEnabled && !isHidden && alpha > 0.01 else {
			// 此视图无法响应event
		   return nil
	   }
	   if self.point(inside: point, with: event) {
	   		// 触摸区域在该视图内，从后向前遍历子视图
	       for subview in subviews.reversed() {
	       	let convertedPoint = subview.convert(point, from: self)
	       	if let targetView = subview.hitTest(convertedPoint, with: event) {
	       		// 找到该子视图及其子视图们中响应该事件的view
	       		return targetView
	       	} else {
	       		// 当前子视图及其子视图们不响应该事件，继续遍历下一个
	       		continue
	       	}
	       	// 所有子视图都没有响应该事件，所以是自身响应该事件
	       	return self
	       }
	   } else {
	       // 此触摸区域不在该视图内
	   	   return nil
	   }
	}
```

**确定触摸事件响应链**

找到第一响应者之后，则会确认出该事件的响应链
从第一响应者开始往上连接为响应链

subview -> superview -> ... -> UIViewController.view -> UIViewController -> UIWindow -> UIApplication -> App Delegate

**沿响应链传递触摸事件**

触摸事件首先由第一响应者响应，触发其对应的触摸事件方法，然后继续传递给响应链中的下一个响应者，也就是superview，直到App Delegate。若最终没有响应，则会被丢弃

需要注意的是，`UIControl`和`UIScrollView`，响应触摸事件后不会继续往下传递触摸事件，这样可以做到某控件响应事件后，事件传递终止。

***特殊情况***

`UIControl`接收信息的机制是target-action机制，和`UIGestureRecognizer`的处理方式相关但不完全相同。
当某一个视图添加了`UIGestureRecognizer`后，`UITouch`会同时分发给手势识别系统，随着用户手指的不同行为和持续不断的触摸和滑动，UITouch对象会不断更新，并同时触发touches系列方法，当手势识别系统判断出UITouch符合某个收集到的手势，即识别成功时，第一响应着会收到`touchesCancelled`消息，并该视图不再收到任何该UITouch的touches事件。同时也让该`UITouch`关联的其他手势也收到`touchesCancelled`，并且之后不再收到此`UITouch`的touches事件

更多阅读：[iOS | 响应链及手势识别](https://juejin.cn/post/6905914367171100680)

#### UIControl和UIView有和差别？

`UIControl`是一类特殊的`UIView`，其最大的特点是可以通过target-action机制响应事件。

`UIView`更注重于页面布局和视图，如果想识别手势和响应事件可以通过添加`UIGestureRecognizer`, 而`UIControl`及其子类可以通过添加target-action响应各种事件，例如`UIControlEventTouchUpInside`, `UIControlEventValueChanged`, `UIControlEventEditingChanged`等等，常见的UIControl有`UIButton`, `UITextField`, `UISwitch`等等

#### UIView和CALayer有和差别

- 两者最大的区别是`UIView`继承自`UIResponder`，可以响应事件，而`CALayer`不可以
- 每一个`UIView`对象会持有一个`CALayer`对象负责视图的绘制
- `UIView`可以视为其持有的`CALayer`的代理，主要侧重于显示内容的管理和响应事件
- `UIView.frame`会直接映射其持有的`CALayer.frame`, 设置`UIView`的`frame`, `center`, `position`, `bounds`等等等同于直接设置其持有的`CALayer`的对应属性
- `CALayer`作为非`UIView`的rootLayer是是默认修改属性支持隐式动画的，在给`UIView`的Layer做动画的时候，View作为Layer的代理, Layer通过 `actionForLayer:forKey:`向View请求相应的 action(动画行为)
- `CALayer`是跨越移动端和桌面端的视图绘制框架`CoreAnimation`中的核心类，`UIView`是在移动端平台框架`UIKit`上封装了`CALayer`并支持了移动端设备上特殊的响应事件，而在桌面端平台框架`AppKit`上有类似的核心类`NSView`。这样做可以复用在多个平台中共通的视图绘制功能，而在单独的平台上适配其对应的操作方式。

四大系统的绘图框架结构：

[UIKit] [AppKit]

[Core Animation]

[OpenGL/Metal] [Core Graphics]

[Hardware]
 

#### 简述渲染的三棵树

- Model Layer Tree(模型树), 视图的模型及属性，通常负责视图数据的存取，添加`CAAnimaiton`并不会改变它
- Presentation Layer Tree(呈现树)，通常只负责显示，用在同步动画和动画过程中处理用户交互，获取的是CALayer当前显示在设备上的真实属性
- Rendering Layer Tree(渲染树，私有)

通常在每次屏幕刷新时，P树会和M树同步状态。但当加入`CAAnimation`并执行动画时，这个同步过程会被取代，P树将随着动画的进程不断改变，直到动画结束后P树和M树同步，这是因为`CAAnimation`在默认执行完的情况下会从`CALayer`中移除，即`removedOnCompletion`为`true`, 要想在动画结束后保留最终状态，可以将`fillMode`设置为`.forward`，并将`removedOnCompletion `置为`false`

#### 什么是异步渲染

异步渲染即在子线程处理需要绘制的图形和内容，然后在主线程提交给视图绘制

#### layoutSubviews在何时调用

- `addSubview`
- 设置view的frame(width或height发生改变)
- 滚动`UIScrollView`
- 旋转屏幕

#### 什么是离屏渲染，什么情况下会导致离屏渲染，以及如何避免


