# iOS 锁相关知识

**线程安全**：指某个函数、函数库在多线程环境中被调用时，能正确处理多个线程之间的共享变量，使程序功能正确完成。

## 互斥锁和自旋锁

### 互斥锁（Mutex）

**互斥锁**是sleep-waiting类型的锁。当抢互斥锁失败时，线程会进入休眠，这些系统就会将这个线程放入等待队列，转而去处理其他线程的任务（这时候会有上下文的切换）；等到资源被解锁，该线程会被唤醒

### 自旋锁（SpinLock）

**自旋锁**是busy-waiting类型的锁。当抢自旋锁失败时，线程会一直循环等待锁的释放，期间一直占用CPU

## iOS中的锁

### OSSpinLock

iOS中唯一的自旋锁，在iOS 10被废弃，由os_unfair_lock替代。

初始化方法是一个宏，当要使用时，需要用OS_SPINLOCK_INIT初始化一个锁

```Objective-C
/*! @abstract The default value for an <code>OSSpinLock</code>.
    @discussion
	The convention is that unlocked is zero, locked is nonzero.
 */
#define	OS_SPINLOCK_INIT    0


/*! @abstract Data type for a spinlock.
    @discussion
	You should always initialize a spinlock to {@link OS_SPINLOCK_INIT} before
	using it.
 */
typedef int32_t OSSpinLock OSSPINLOCK_DEPRECATED_REPLACE_WITH(os_unfair_lock);


```

使用方式：

```Objective-C
// 初始化
OSSpinLock lock = OS_SPINLOCK_INIT;

// 加锁
OSSpinLockLock(&lock);

//解锁
OSSpinLockUnlock(&lock);
```



OSSpinLock存在优先级反转的隐患：如果一个低优先级的线程或得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它就会因为spin lock处于忙等而占用大量CPU，低优先级的线程无法高优先级的线程争夺CPU，导致任务无法完成、无法释放Lock，高优先级的线程也无法开展任务。所以，除非访问锁的所有线程都处于同一优先级，不然自旋锁就不能再使用（这也是苹果废弃OSSpinLock的原因）

### os_unfair_lock

在 iOS 10/macOS 10.12 发布时，苹果提供了新的 os_unfair_lock 作为 OSSpinLock 的替代，并且将 OSSpinLock 标记为了 Deprecated。虽然os_unfair_lock是OSSpinLock的替代，但是os_unfair_lock其实不是自旋锁，而是互斥锁。

> This is a replacement for the deprecated `OSSpinLock`. This function doesn't spin on contention, but instead waits in the kernel to be awoken by an unlock. Like `OSSpinLock`, this function does not enforce fairness or lock ordering—for example, an unlocker could potentially reacquire the lock immediately, before an awoken waiter gets an opportunity to attempt to acquire the lock. This may be advantageous for performance reasons, but also makes starvation of waiters a possibility.

os_unfair_lock的加锁和解锁必须在同一个线程，不然会在编译时出错；并且不能被共享内存或者多重映射内存的进程或者线程访问，因为os_unfair_lock是基于锁本身的值的地址和持有它的进程的地址。（multiply-mapped memory是指多个虚拟内存地址映射到同一个物理地址）。

> A lock must be unlocked only from the same thread in which it was locked. Attempting to unlock from a different thread causes a runtime error.
>
> A lock must not be accessed from multiple processes or threads via shared or multiply-mapped memory, because the lock implementation relies on the address of the lock value and owning process.

使用方式：

```Objective-C
#import <os/lock.h>

//初始化
os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
//加锁
os_unfair_lock_lock(&lock);
//解锁
os_unfair_lock_unlock(&lock);

/*!
 * @function os_unfair_lock_trylock
 *
 * @abstract
 * Locks an os_unfair_lock if it is not already locked.
 *
 * @discussion
 * It is invalid to surround this function with a retry loop, if this function
 * returns false, the program must be able to proceed without having acquired
 * the lock, or it must call os_unfair_lock_lock() directly (a retry loop around
 * os_unfair_lock_trylock() amounts to an inefficient implementation of
 * os_unfair_lock_lock() that hides the lock waiter from the system and prevents
 * resolution of priority inversions).
 *
 * @param lock
 * Pointer to an os_unfair_lock.
 *
 * @result
 * Returns true if the lock was succesfully locked and false if the lock was
 * already locked.
 */
OS_UNFAIR_LOCK_AVAILABILITY
OS_EXPORT OS_NOTHROW OS_WARN_RESULT OS_NONNULL_ALL
bool os_unfair_lock_trylock(os_unfair_lock_t lock);

/*!
 * @function os_unfair_lock_assert_owner
 *
 * @abstract
 * Asserts that the calling thread is the current owner of the specified
 * unfair lock.
 *
 * @discussion
 * If the lock is currently owned by the calling thread, this function returns.
 *
 * If the lock is unlocked or owned by a different thread, this function
 * asserts and terminates the process.
 *
 * @param lock
 * Pointer to an os_unfair_lock.
 */
OS_UNFAIR_LOCK_AVAILABILITY
OS_EXPORT OS_NOTHROW OS_NONNULL_ALL
void os_unfair_lock_assert_owner(os_unfair_lock_t lock);

/*!
 * @function os_unfair_lock_assert_not_owner
 *
 * @abstract
 * Asserts that the calling thread is not the current owner of the specified
 * unfair lock.
 *
 * @discussion
 * If the lock is unlocked or owned by a different thread, this function
 * returns.
 *
 * If the lock is currently owned by the current thread, this function asserts
 * and terminates the process.
 *
 * @param lock
 * Pointer to an os_unfair_lock.
 */
OS_UNFAIR_LOCK_AVAILABILITY
OS_EXPORT OS_NOTHROW OS_NONNULL_ALL
void os_unfair_lock_assert_not_owner(os_unfair_lock_t lock);

```

经过简单的性能测试，单线程上，发现os_unfair_lock的性能其实要比OSSpinLock差一点，和dispatch_semaphore差不多（参考[不再安全的 OSSpinLock](https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/)，代码也是在其基础上增加了os_unfair_lock的部分）

### Dispatch Semaphore

*Semaphore*就是信号量，dispatch semaphore是传统信号量的一个有效实现方式。仅当需要阻塞调用线程时，dispatch semaphore才会调用内核。

使用方式如下：

```Objective-C
// 初始化，dispatch_semaphore_create传入的参数需要>=0，不然生成的dispatch_semaphore_t是nil，在dispatch_semaphore_wait和dispatch_semaphore_signal调用时会产生运行时错误
dispatch_semaphore_t signal = dispatch_semaphore_create(1);

// wait方法，将信号量减一，如果结果为负，进入等待队列，等待信号量变为正，直到timeout（如果timeout时信号量小于0，会将信号量+1）
dispatch_semaphore_wait(signal, timeout);

//signal方法，将信号量+1，如果增加前信号值>=0，直接返回；否则，唤起一个之前在等待的线程
dispatch_semaphore_signal(signal);
```

更详细的可以查看[源码](https://github.com/apple/swift-corelibs-libdispatch/blob/main/src/semaphore.c)

### pthread_mutex

Pthreads是POSIX Threads的缩写，POSIX线程（POSIX Threads）是POSIX（可移植操作系统接口-Portable Operating System Interface，是IEEE为要在各种UNIX操作系统上运行软件而定义API的一系列互相关联的标准的总称）的线程标准，定义了创建和操纵线程的一套API。

pthread_mutex是互斥锁的一种，等待锁的线程会处于休眠状态。通过修改pthread_mutex的属性，可以实现很多功能。

```Objective-C
// 属性初始化

pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);

// 锁的类型
/*
 * Mutex type attributes
 */
#define PTHREAD_MUTEX_NORMAL		0 // lock之后需要unlock才能再次lock，不然会死锁
#define PTHREAD_MUTEX_ERRORCHECK	1 //没有找到相关说明，之后补充
#define PTHREAD_MUTEX_RECURSIVE		2 //允许同一个线程对同一把锁进行重复加锁
#define PTHREAD_MUTEX_DEFAULT		PTHREAD_MUTEX_NORMAL


//设置锁的类型
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);

// 锁的协议
/*
 * Mutex protocol attributes
 */
#define PTHREAD_PRIO_NONE            0 // When a thread owns a mutex with the PTHREAD_PRIO_NONE protocol attribute, its priority and scheduling shall not be affected by its mutex ownership. The default value of the attribute shall be PTHREAD_PRIO_NONE.
#define PTHREAD_PRIO_INHERIT         1 // When a thread is blocking higher priority threads because of owning one or more robust (or non-robust) mutexes with the PTHREAD_PRIO_INHERIT protocol attribute, it shall execute at the higher of its priority or the priority of the highest priority thread waiting on any of the robust mutexes owned by this thread and initialized with this protocol.
#define PTHREAD_PRIO_PROTECT         2 // When a thread owns one or more robust (or non-robust) mutexes initialized with the PTHREAD_PRIO_PROTECT protocol, it shall execute at the higher of its priority or the highest of the priority ceilings of all the robust mutexes owned by this thread and initialized with this attribute, regardless of whether other threads are blocked on any of these robust mutexes or not.

// 可以通过PTHREAD_PRIO_INHERIT解决优先级反转的问题

// 设置锁的协议
pthread_mutexattr_setprotocol(&attr, PTHREAD_PRIO_INHERIT);

// 初始化锁，attr传NULL默认采用PTHREAD_MUTEX_NORMAL和PTHREAD_PRIO_NONE
pthread_mutex_init(mutex, &attr);

// 销毁属性
pthread_mutexattr_destroy(&attr);

// 加锁
pthread_mutex_lock(&mutex);

// 解锁
pthread_mutex_unlock(&mutex);

// 销毁锁
pthread_mutex_destroy(&mutex);


```

### NSLock

NSLock是对pthread_mutex普通锁（PTHREAD_MUTEX_NORMAL）的封装（参考https://github.com/apple/swift-corelibs-foundation/blob/main/Sources/Foundation/NSLock.swift，网上也有说法是PTHREAD_MUTEX_ERRORCHECK的封装，不确定是不是因为Swift和OC的实现不一致）。由于不是递归锁，所以只有在解锁之后才能加锁。如果对不是锁住状态的锁解锁，会进行报错。

> The `NSLock` class uses POSIX threads to implement its locking behavior. When sending an unlock message to an `NSLock` object, you must be sure that message is sent from the same thread that sent the initial lock message. Unlocking a lock from a different thread can result in undefined behavior.
>
> You should not use this class to implement a recursive lock. Calling the `lock` method twice on the same thread will lock up your thread permanently. 
>
> Unlocking a lock that is not locked is considered a programmer error and should be fixed in your code. The `NSLock` class reports such errors by printing an error message to the console when they occur.

除了lock和unlock外，还有如下方法：

```Objective-C
// 尝试加锁，如果失败会返回false，内部调用的是pthread_mutex_trylock
- (BOOL)tryLock;

// 尝试在指定Date前加锁，在截止时间前会一直尝试加锁；内部通过一个timeoutMutex和一个timeoutCond实现
- (BOOL)lockBeforeDate:(NSDate *)limit;
```

### NSRecursiveLock

NSRecursiveLock是对pthread_mutex递归锁的封装，除了锁的类型是递归锁，同一个线程能多次加锁以外，其他的跟NSLock一致（包括实现）

### NSCondition

NSCondition内部由mutex和cond实现，斥锁的 lock/unlock 方法和条件变量的 wait/signal 统一封装在 NSCondition 对象中。

除了lock和unlock外，主要方法如下（方法都要在锁中调用）：

```Objective-C
// 锁住当前线程直到条件满足（即等待signal或者broadcast）
- (void)wait;

// 锁住当前线程直到条件满足或者到达截止时间
- (BOOL)waitUntilDate:(NSDate *)limit;

// 唤醒一个等待条件变量的线程，可以调用多次去唤醒多个线程，没有等待的线程时，调用该方法不会有影响
- (void)signal;

// 唤醒所有等待条件的线程，没有等待的线程时，调用该方法不会有影响
- (void)broadcast;
```

### NSConditionLock

NSConditionLock是对NSCondition的进一步封装，可以自定义条件

主要方法如下：

```Objective-C

// 用自定义的条件初始化
- (instancetype)initWithCondition:(NSInteger)condition NS_DESIGNATED_INITIALIZER;

// 满足条件时加锁
- (void)lockWhenCondition:(NSInteger)condition;

// 尝试加锁，不管条件变量，会立马返回
- (BOOL)tryLock;

// 尝试在满足条件的时候加锁，内部实际上调用的是lockWhenCondition:beforeDate:，会立马返回
- (BOOL)tryLockWhenCondition:(NSInteger)condition;

// 解锁并将修改条件变量的值
- (void)unlockWithCondition:(NSInteger)condition;

// 在截止时间，如果条件变量满足，进行加锁
- (BOOL)lockWhenCondition:(NSInteger)condition beforeDate:(NSDate *)limit;

```

### @synchonized

@synchronized是对pthread_mutex递归锁的封装。根据[StackOverflow上的一个回答](https://stackoverflow.com/a/6047218)，@synchronized实际上会变成`objc_sync_enter`和`objc_sync_exit`的成对调用。我们能在[objc-sync.mm](https://opensource.apple.com/source/objc4/objc4-646/runtime/objc-sync.mm)找到这两个方法的实现：

```Objective-C
// Begin synchronizing on 'obj'. 
// Allocates recursive mutex associated with 'obj' if needed.
// Returns OBJC_SYNC_SUCCESS once lock is acquired.  
int objc_sync_enter(id obj)
{
    int result = OBJC_SYNC_SUCCESS;

    if (obj) {
        SyncData* data = id2data(obj, ACQUIRE);
        require_action_string(data != NULL, done, result = OBJC_SYNC_NOT_INITIALIZED, "id2data failed");
	
        result = recursive_mutex_lock(&data->mutex);
        require_noerr_string(result, done, "mutex_lock failed");
    } else {
        // @synchronized(nil) does nothing
        if (DebugNilSync) {
            _objc_inform("NIL SYNC DEBUG: @synchronized(nil); set a breakpoint on objc_sync_nil to debug");
        }
        objc_sync_nil();
    }

done: 
    return result;
}


// End synchronizing on 'obj'. 
// Returns OBJC_SYNC_SUCCESS or OBJC_SYNC_NOT_OWNING_THREAD_ERROR
int objc_sync_exit(id obj)
{
    int result = OBJC_SYNC_SUCCESS;
    
    if (obj) {
        SyncData* data = id2data(obj, RELEASE); 
        require_action_string(data != NULL, done, result = OBJC_SYNC_NOT_OWNING_THREAD_ERROR, "id2data failed");
        
        result = recursive_mutex_unlock(&data->mutex);
        require_noerr_string(result, done, "mutex_unlock failed");
    } else {
        // @synchronized(nil) does nothing
    }
	
done:
    if ( result == RECURSIVE_MUTEX_NOT_LOCKED )
         result = OBJC_SYNC_NOT_OWNING_THREAD_ERROR;

    return result;
}
```

其中`id2data`方法，传入的参数分别是需要转换的对象和使用的方式（ACQUIRE, RELEASE, CHECK），加锁时，使用方式是ACQUIRE，解锁时，使用方式时RELEASE。对于ACQUIRE，如果线程的缓存中有对应对象的缓存，会直接对其的lockCount + 1，否则会去sDataLists（类型是SyncList）找对象对应的SyncData（找到会将增加threadCount），如果还找不到会创建对应SnycData，并加到sDataLists和缓存当中。RELEASE的话，如果在缓存中找不到，不进行任何操作，否则将lockCount - 1，如果lockCount为0，从缓存中移除，也会将减少的SyncData的threadCount。缓冲中找不到之后的步骤，会在自旋锁中进行。

```Objective-C
typedef struct SyncData {
    struct SyncData* nextData;
    id               object;
    int              threadCount;  // number of THREADS using this block
    recursive_mutex_t        mutex;
} SyncData;

typedef struct {
    SyncData *data;
    unsigned int lockCount;  // number of times THIS THREAD locked this block
} SyncCacheItem;

typedef struct SyncCache {
    unsigned int allocated;
    unsigned int used;
    SyncCacheItem list[0];
} SyncCache;

typedef struct {
    SyncData *data;
    spinlock_t lock;

    char align[64 - sizeof (spinlock_t) - sizeof (SyncData *)];
} SyncList __attribute__((aligned(64)));
```

总结一下，使用@synchronized时，传入的每个对象都会分配一个递归锁并存在哈希表中，如果传入的对象是nil或者对象的内存地址发生了变化，相当于没有加锁，即不能保证线程安全。相比于NSLock等其他锁，主要优势就是不用担心因为忘记写unlock。

