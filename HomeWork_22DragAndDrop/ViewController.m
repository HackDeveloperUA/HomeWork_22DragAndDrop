
#import "ViewController.h"

@interface ViewController ()

@property (strong , nonatomic) UIView* blackBoard;
@property (strong, nonatomic)  UIColor* randomColor;
@property (strong, nonatomic)  NSMutableArray* arrayForChecker;

@property (weak, nonatomic)   UIView* draggingView;
@property (assign , nonatomic) CGFloat sizeChecker;
@property (assign , nonatomic) CGFloat sizeCell;

@property (assign, nonatomic) CGPoint touchOffSet;
//@property (assign, nonatomic) CGPoint oldPos;
@property (assign, nonatomic) CGPoint newPos;

@property (assign , nonatomic) CGRect oldPos;
@property (strong, nonatomic)  NSMutableArray* arrayEmpty;
@property (strong, nonatomic)  NSMutableArray* arrayFull;


@end

@implementation ViewController


-(UIView*) buildChessBoard:(CGRect) rect andColor:(UIColor*)color andParentView:(UIView*) parentView {
    
    UIView* view = [[UIView alloc] initWithFrame:rect];
    //view.layer.cornerRadius = 20.0;
    view.backgroundColor = color;
    [parentView addSubview:view];
    
    view.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.arrayEmpty = [[NSMutableArray alloc] init];
    self.arrayFull = [[NSMutableArray alloc] init];

    
    
    /// Board Begin ///
    
    CGRect bounds = self.view.bounds;
    CGPoint centerOfView = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    // Инициализация доскм
    self.blackBoard = [[UIView alloc] initWithFrame:
                       CGRectMake(centerOfView.x - CGRectGetWidth(bounds)/2,
                                  centerOfView.y - CGRectGetWidth(bounds)/2,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.width )];
    
    //Добавляем доску на экран
    self.blackBoard.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.blackBoard];
    
    // Настраивание растягивания
    self.blackBoard.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    /// Board End ///
    
    self.arrayForChecker = [[NSMutableArray alloc] init];
    
    
    // Выбираем размер ячейки
    self.sizeCell = self.view.bounds.size.width/8;
    float x = 0;
    float y = 0;
    
    NSInteger midX = self.blackBoard.bounds.size.width - _sizeCell*8; // так как 10 клеток
    NSInteger midY = self.blackBoard.bounds.size.height - _sizeCell*8;  // так как 8 клеток
    
    // Выбираем размер шашки
    
    self.sizeChecker = _sizeCell/2; // Шашка в 2 раза меньше чем ячейка
    float xchecker    = 0;
    float ychecker    = 0;
    
    for (int i=0; i<=7; i++) {
        x=0;
        for (int j=0; j<=3; j++) {
            
            if (i%2 == 0) {
                y=i*_sizeCell+midY/2;
                
                [self buildChessBoard: CGRectMake(x, y, _sizeCell,   _sizeCell)   andColor:[UIColor blueColor]   andParentView:self.blackBoard];
                x+=_sizeCell;
                
                UIView* v1 = [self buildChessBoard: CGRectMake(x, y, _sizeCell, _sizeCell) andColor:[UIColor greenColor] andParentView:self.blackBoard];
                x+=_sizeCell;
                
                if (i == 4) {
                   
                    CGRect r1 = v1.frame;
                    NSValue* r1Obj = [NSValue valueWithCGRect:r1];
                    [self.arrayEmpty  addObject:r1Obj];
                } else {
                   
                    CGRect r1 = v1.frame;
                    NSValue* r1Obj = [NSValue valueWithCGRect:r1];
                    [self.arrayFull  addObject:r1Obj];
                }
                
                
            }
            else {
                y=i*_sizeCell+midY/2;
              UIView* v2 = [self buildChessBoard: CGRectMake(x, y, _sizeCell, _sizeCell) andColor:[UIColor greenColor] andParentView:self.blackBoard];
                x+=_sizeCell;
                
                [self buildChessBoard: CGRectMake(x, y, _sizeCell, _sizeCell) andColor:[UIColor blueColor] andParentView:self.blackBoard];
                x+=_sizeCell;
                
                if (i == 3) {
                    
                    CGRect r2 = v2.frame;
                    NSValue* r2Obj = [NSValue valueWithCGRect:r2];
                    [self.arrayEmpty  addObject:r2Obj];
                }
                else {
                    CGRect r2 = v2.frame;
                    NSValue* r2Obj = [NSValue valueWithCGRect:r2];
                    [self.arrayFull  addObject:r2Obj];

                }
            }
        }
    }
    
    NSLog(@"array empty - %@ ",self.arrayEmpty);
    NSLog(@"array full - %@ ",self.arrayFull);

    // Рисуем белые шашки
    // цикл повторяется 3 раза , т.к. 3 - ряда шашек
    for (int line = 0; line<3; line++){
        
        xchecker=0;
        // цикл повторяется 4 раза , т.к. на одной линии должно стоять 4 шашки
        for (int numberChecker = 0; numberChecker < 4; numberChecker++) {
            // Если line четное число тогда первая клетка имеет желтый цвет
            
            if (line%2==0) {
                // y = линию * размерЯчейки+(Находим центр ячейки для шашки)
                ychecker=line*_sizeCell+midY/2+_sizeCell/4;
                UIView* view = [self buildChessBoard:CGRectMake(xchecker+_sizeCell+_sizeCell/4, ychecker, _sizeChecker, _sizeChecker)
                                            andColor:[UIColor yellowColor]
                                       andParentView:self.blackBoard];
                // добавляем на экран
                [self.arrayForChecker addObject:view];
                // увеличиваем х для прорисовки следующий шашки
                xchecker+=_sizeCell*2;
            }
            
            else {
                ychecker=line*_sizeCell+midY/2+_sizeCell/4;
                UIView* view = [self buildChessBoard:CGRectMake(xchecker+_sizeCell/4, ychecker, _sizeChecker, _sizeChecker)
                                            andColor:[UIColor yellowColor]  andParentView:self.blackBoard];
                [self.arrayForChecker addObject:view];
                xchecker+=_sizeCell*2;
            }
        }
    }
    
    // Рисуем черные шашки
    
    for (int line = 5; line<8; line++) {
        xchecker=0;
        
        for (int numberChecker = 0; numberChecker < 4; numberChecker++) {
            
            if (line%2==0) {
                ychecker=line*_sizeCell+midY/2+_sizeCell/4;
                UIView* view = [self buildChessBoard:CGRectMake(xchecker+_sizeCell+_sizeCell/4, ychecker, _sizeChecker, _sizeChecker)
                                            andColor:[UIColor redColor] andParentView:self.blackBoard];
                [self.arrayForChecker addObject:view];
                xchecker+=_sizeCell*2;
            }
            else {
                
                ychecker=line*_sizeCell+midY/2+_sizeCell/4;
                UIView* view = [self buildChessBoard:CGRectMake(xchecker+_sizeCell/4, ychecker, _sizeChecker, _sizeChecker) andColor:[UIColor redColor] andParentView:self.blackBoard];
                
                [self.arrayForChecker addObject:view];
                xchecker+=_sizeCell*2;
            } } }
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //Меняем цвет
    CGFloat redRandomColorLevel = (CGFloat)arc4random_uniform(256)/255;
    CGFloat greenRandomColorLevel = (CGFloat)arc4random_uniform(256)/255;
    CGFloat blueRandomColorLevel = (CGFloat)arc4random_uniform(256)/255;
    
    self.randomColor = [UIColor colorWithRed:redRandomColorLevel
                                       green:greenRandomColorLevel
                                        blue:blueRandomColorLevel
                                       alpha:1];
    
    for (UIView* view in self.blackBoard.subviews) {
        
        if ([view.backgroundColor isEqual:[UIColor greenColor]])
            view.backgroundColor =  self.randomColor;
    }
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    NSMutableArray* Checkers = self.arrayForChecker;
    
    for (int i=0 ; i<=17; i++) {
        
        NSInteger firstNumberChecker = arc4random() % [Checkers count];
        UIView*   firstTestView = [Checkers objectAtIndex:firstNumberChecker];
        
        NSInteger secondNumberChecker = arc4random() % [Checkers count];
        UIView*   secondTestView = [Checkers objectAtIndex:secondNumberChecker];
        
        CGPoint point = firstTestView.center;
        [UIView animateWithDuration:1 animations:^{
            
            firstTestView.center = secondTestView.center;
            secondTestView.center = point;
        }];
    }
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    
    
    
    UITouch* touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView: self.blackBoard];
    UIView* view = [self.blackBoard hitTest:pointOnMainView withEvent:event];

    if (CGRectGetWidth(view.bounds) == self.sizeChecker) {
        self.draggingView = view;
        
    
        
        BOOL myVar = false;
        for (int i=0 ; i <= [self.arrayFull count] - 1; i++) {
            
            
            NSValue* value = [self.arrayFull objectAtIndex:i];
            CGRect   r     = [value CGRectValue];
            
            
            myVar = CGRectContainsPoint(r, pointOnMainView);
            
            if (myVar) {
                self.oldPos = r;
                NSLog(@"self.oldPos - %@",NSStringFromCGRect(self.oldPos));
                break;
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        [self.blackBoard bringSubviewToFront:self.draggingView];

        
         CGPoint touchPoint = [touch locationInView:self.draggingView];
         
         self.touchOffSet = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                        CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
         
         [UIView animateWithDuration:0.3
                          animations:^{
                              self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                              self.draggingView.alpha = 0.3f;
                          }];

    }
    else {
        self.draggingView = nil;
    }
    
   }

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   
   
    if (self.draggingView) {
        
        
        UITouch* touch = [touches  anyObject];
        CGPoint pointOnMainView = [touch locationInView:self.blackBoard];
        
        if (CGRectGetWidth(self.blackBoard.bounds) > pointOnMainView.x &&
            CGRectGetHeight(self.blackBoard.bounds) > pointOnMainView.y &&
            pointOnMainView.x > 0 &&
            pointOnMainView.y > 0) {

            CGPoint correction = CGPointMake(pointOnMainView.x + self.touchOffSet.x,
                                             pointOnMainView.y + self.touchOffSet.y);
            
            self.draggingView.center = correction;
        }
    }

    
}

- (void) onTouchesEnded {
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 
    if (self.draggingView) {
    
        BOOL myVar;
        for (int i=0 ; i <= [self.arrayEmpty count] - 1; i++) {
          

            NSValue* value = [self.arrayEmpty objectAtIndex:i];
            CGRect   r     = [value CGRectValue];
          
            
            myVar = CGRectContainsPoint(r, CGPointMake(CGRectGetMidX(self.draggingView.frame),
                                                            CGRectGetMaxY(self.draggingView.frame)));
            
            if (myVar) {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     
                                     CGPoint p1 = CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
                                     self.draggingView.center = p1;
                                     self.draggingView.transform = CGAffineTransformIdentity;
                                     self.draggingView.alpha = 1.f;
                                 }];
                
                //[self.arrayEmpty removeObject:value];
                //  value = [NSValue valueWithCGRect: self.oldPos];
               // [self.arrayEmpty addObject:value];
               // self.oldPos = CGRectNull;
               
                [self.arrayEmpty removeObject:value];
                CGRect testOld = self.oldPos;
                self.oldPos = [value CGRectValue];
                value = [NSValue valueWithCGRect:testOld];
                [self.arrayEmpty addObject:value];
                
                
                value = [NSValue valueWithCGRect:self.oldPos];
                [self.arrayFull addObject:value];
                NSLog(@"array - %@",self.arrayEmpty);
                NSLog(@"self.oldPos - %@",NSStringFromCGRect(self.oldPos));
                break;
            }
        }
        
        if (!myVar) {
            CGPoint p1 = CGPointMake(CGRectGetMidX(self.oldPos), CGRectGetMidY(self.oldPos));
            
            [UIView animateWithDuration:0.3 animations:^{
                self.draggingView.center = p1;
                self.draggingView.transform = CGAffineTransformIdentity;
                self.draggingView.alpha = 1.f;
            }];

        }
    }
  
    self.draggingView = nil;
    
    /*
    if (self.draggingView) {
    for (NSValue* value  in self.arrayEmpty) {
        
        CGRect r = [value CGRectValue];
        BOOL myVar = CGRectContainsPoint(r, self.draggingView.frame.origin);
        
        
        
        
        if (myVar) {
             [UIView animateWithDuration:0.3
                              animations:^{
                    
             CGPoint p1 = CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
             self.draggingView.center = p1;
                    
             // self.draggingView.center = self.oldPos;
             self.draggingView.transform = CGAffineTransformIdentity;
             self.draggingView.alpha = 1.f;
             }];
            //r = self.oldPos;
            
            [self.arrayEmpty removeObject:value];
            NSValue* test = [NSValue valueWithCGRect:self.oldPos];
            [self.arrayEmpty addObject:test];
            
            NSLog(@"array - %@",self.arrayEmpty);
            self.draggingView = nil;
        }
        else {
        

        CGPoint p1 = CGPointMake(CGRectGetMidX(self.oldPos), CGRectGetMidY(self.oldPos));
        self.draggingView.center = p1;
            
        [UIView animateWithDuration:0.3 animations:^{
        
        self.draggingView.transform = CGAffineTransformIdentity;
        self.draggingView.alpha = 1.f;
        }];
            
        }
        self.draggingView = nil;
    }
    } */
    
    
    /*
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.blackBoard bringSubviewToFront:self.draggingView];

                        // self.draggingView.center = self.oldPos;
                         self.draggingView.transform = CGAffineTransformIdentity;
                         self.draggingView.alpha = 1.f;
                    
                     }];
    
    self.draggingView = nil;*/
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    

    [self onTouchesEnded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
