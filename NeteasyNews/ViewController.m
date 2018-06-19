//
//  ViewController.m
//  NeteasyNews
//
//

#import "ViewController.h"
#import "TableViewController.h"
#define COUNT 7
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *conScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      [self setChildVc];
    
    
    [self setupTitle];
    
  
    
    [self scrollViewDidEndScrollingAnimation:self.conScrollView];
    
}

-(void)setChildVc{
//创建子控制器
    TableViewController *vc0=[[TableViewController alloc]init];
    vc0.title=@"国际";
    [self addChildViewController:vc0];
    
    TableViewController *vc1=[[TableViewController alloc]init];
    vc1.title=@"军事";
    [self addChildViewController:vc1];
    
    TableViewController *vc2=[[TableViewController alloc]init];
    vc2.title=@"社会";
    [self addChildViewController:vc2];
    
    TableViewController *vc3=[[TableViewController alloc]init];
    vc3.title=@"政治";
    [self addChildViewController:vc3];
    
    TableViewController *vc4=[[TableViewController alloc]init];
    vc4.title=@"经济";
    [self addChildViewController:vc4];
    
    TableViewController *vc5=[[TableViewController alloc]init];
    vc5.title=@"体育";
    [self addChildViewController:vc5];
    
    TableViewController *vc6=[[TableViewController alloc]init];
    vc6.title=@"娱乐";
    [self addChildViewController:vc6];
    
    
    
    
    
}





- (void)setupTitle
{
    for (int i=0; i<COUNT; i++) {
        
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*100, 0, 100, self.titleScrollView.frame.size.height)];
        label.text=[self.childViewControllers[i] title];
        label.textAlignment=NSTextAlignmentCenter;
        
        [label setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:arc4random_uniform(100)/100.0]];
       label.userInteractionEnabled=YES;
      //  创建手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
        
        label.tag=i;
        
        [self.titleScrollView addSubview:label];
        
    }
    
    //设置titleScrollView滚动范围
    self.titleScrollView.contentSize=CGSizeMake(COUNT*100, 0);
    //self.titleScrollView.in
  
    self.conScrollView.contentSize=CGSizeMake(COUNT*[UIScreen mainScreen].bounds.size.width, 0);
    
    
}

-(void)tap:(UITapGestureRecognizer*)tap{
    NSInteger index=tap.view.tag;
    NSLog(@"======%zd",index);
    CGPoint offset=self.conScrollView.contentOffset;
    offset.x=self.conScrollView.frame.size.width*index;
    [self.conScrollView setContentOffset:offset animated:YES];
}

//scrollow的代理方法
//滚动动画结束的时候调用这个方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //设置一些临时变量
    CGFloat width=scrollView.frame.size.width;
    CGFloat height=scrollView.frame.size.height;
    
    CGFloat offSet=scrollView.contentOffset.x;
   
    
    //获取当前控制器的索引
    NSInteger index=offSet/width;
    
    //顶部居中处理
    UILabel *lable=self.titleScrollView.subviews[index];
    CGPoint offsetTitle=  self.titleScrollView.contentOffset;
    offsetTitle.x=lable.center.x-width/2;
    
  if (offsetTitle.x<0) {
      offsetTitle.x=0;
    }
    
    CGFloat MAXOfset=self.titleScrollView.contentSize.width-width;
    
    
    if (offsetTitle.x>MAXOfset) {
        offsetTitle.x=MAXOfset;
    }
    
    
    
    [self.titleScrollView setContentOffset:offsetTitle animated:YES];
    
    
    
    
    
   
    //取出需要显示的控制器
    UIViewController *controller=self.childViewControllers[index];
    if ([controller isViewLoaded]) {
        return;
   }
    controller.view.frame=CGRectMake(offSet, 0, width, height);
    
    [scrollView addSubview:controller.view];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}






@end
