HEAD: HEAD 指向当前所在的分支,回退版本可以通过相关信息修改指向， 一般操作可以不用到（个人总结，网上资料没细说，若总结不对欢迎指出）

master:一般默认创建的分支，我们一般不在这里添加代码开发工程，一般是用来储存上线正式版本的代码，即其他分支合并到这个分支，我们开始一般会建一个dev分支

1. 基础知识
1.1 ARC 是什么，怎么工作的
ARC基于MRC实现，MRC即为手动引用计数。
MRC的原则是：谁拥有对象谁释放，手动进行内存管理。
retain使对象的引用计数加1，release使对象的引用计数减一，当对象引用计数为0时，则被系统释放。
创建对象时可以指定autorelease，把对象放到自动释放池中，系统的自动释放池会在runloop结束的时候释放这个对象。

声明属性时：
   assign: 基础数据类型(非OC对象类型)指定。
   retain: 一般MRC时使用，会使对象引用计数加1。
   weak: 保持对象的一个弱引用，引用计数不会加1，对象释放时，这个变量自动置为nil。一般delegate指定为weak。
   strong: 一般ARC使用，会使对象引用计数加1。

ARC:
    ARC基于MRC实现，编译器会在创建对象的时候加上retain、autorelease等调用, 当需要释放对象时，自动添加release调用。

1.2 property 实现思路
编译器语法糖，自动实现属性的setter、getter方法。

1.3 不手动指定autoreleasepool的前提下，autorealease相关的对象什么时候释放
runloop开始的时候，会创建一个autoreleasepool，autorealease对象会自动加入这个pool中。

runloop结束的时候，autoreleasepool会被释放，里面所有对象的引用计数会被减1，当某个对象的引用计数为0时，对象被释放。

1.4 block什么情况下会循环引用
一般是一个对象强引用一个block, block里面又强引用了这个对象。比如：
typedef void(^block)();

@property (copy, nonatomic) block myBlock;
@property (copy, nonatomic) NSString *blockString;

- (void)testBlock {
    self.myBlock = ^() {
        // block里面引用了self，导致对象被强引用
        NSString *localString = self.blockString;
    };
}

需要使用weak打破循环引用：

- (void)testBlock {
    __weak typeof(self) weakSelf = self;
    self.myBlock = ^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *localString = self.blockString;
    };
}

1.1.5. 如何手动触发KVO
1、重写监听属性的set、get方法
2、重写 + (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
    针对指定key，禁止掉自动通知。比如：
    
    + (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
        // 如果监测到键值为age,则指定为非自动监听对象
       if ([key isEqualToString:@"age"]) {
           return NO;
       }
       return [super automaticallyNotifiesObserversForKey:key];
    }
3、在set方法中在赋值的前后分别调用：willChangeValueForKey和didChangeValueForKey

    - (void)setAge:(NSString *)age {
        [self willChangeValueForKey:@"age"];
        _age = age;
       [self didChangeValueForKey:@"age"];
    }
4、实现willChangeValueForKey和didChangeValueForKey方法

2. 高级知识点

2.1 runloop 其实现原理？runloop和线程的关系是什么？
一个Runloop就是一个事件处理循环, Run loop处理的输入事件有两种不同的来源：
    输入源（input source）和定时源（timer source）。
处理的事件如下：
    界面刷新：比如手动调用了 UIView/CALayer的setNeedsLayout/setNeedsDisplay方法
    事件响应: 比如锁屏、摇晃、加速
    手势识别：比如识别出点击手势，做相应的处理
    GCD任务：比如调用dispatch_async(dispatch_get_main_queue(), block, 会向主线程的RunLoop发送消息
    timer: 定时器触发
    网络请求：网络请求到达

runloop和线程的关系：
    每个线程都拥有一个Runloop，Runloop负责处理线程响应的事件。
    主线程的runloop自动创建，子线程的runloop默认不创建（在子线程中调用NSRunLoop *runloop = [NSRunLoop currentRunLoop];
   获取RunLoop对象的时候，就会创建RunLoop）。

2.2 GCD的一些高级用法
可以实现多读单写机制，实现线程安全的数组、字典等。
如：
一次性执行(dispatch_once_t)
延时操作
调度组(Dispatch_groups)

2.3 考核基本算法（链表、集合、Map、Tree 等）
二分查找等。
3. 巨大型App架构方面需要注意什么
3.1 安全包大小优化
图片压缩优化
linkmap分析出模块大小分布

3.2 启动速度优化
精准定位出影响启动速度的模块，优化思路

3.3 模块化
cocoapod模块化管理
router的设计

3.4 持续集成
自动打包
静态分析
代码review
单元测试
代码覆盖率
Monkey自动测试
等。


88888888
