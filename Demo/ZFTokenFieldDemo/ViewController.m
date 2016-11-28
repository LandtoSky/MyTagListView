//
//  ViewController.m
//  ZFTokenFieldDemo
//
//  Created by Amornchai Kanokpullwad on 11/11/2014.
//  Copyright (c) 2014 Amornchai Kanokpullwad. All rights reserved.
//

#import "ViewController.h"
#import "ZFTokenField.h"

@interface ViewController () <ZFTokenFieldDataSource, ZFTokenFieldDelegate>
@property (weak, nonatomic) IBOutlet ZFTokenField *tokenField;
@property (nonatomic, strong) NSMutableArray *tokens;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tokens = [NSMutableArray array];
    
    self.tokenField.dataSource = self;
    self.tokenField.delegate = self;
    self.tokenField.textField.placeholder = @"Enter here";
    [self.tokenField reloadData];
    
//    [self.tokenField.textField becomeFirstResponder];
}

- (IBAction)sendButtonPressed:(id)sender
{
    self.tokens = [NSMutableArray array];
    self.tokens =[@[@"dfa", @"sdfas", @"adfa2",@"23", @"sds", @"adfa2",@"234121", @"sdfas", @"addfadsfa2",@"234121", @"sdffasdas", @"adfa2"] mutableCopy];
    [self.tokenField reloadData];
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tokens removeObjectAtIndex:index];
        [self.tokenField reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 25;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tokens.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UIImageView *imageView = (UIImageView*)[view viewWithTag:1];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [imageView setImage:[UIImage imageNamed:@"girl.jpeg"]];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tokens[index];
//    CGSize size = [label sizeThatFits:CGSizeMake(1000, 25)];
    CGFloat width = [self widthForText:label.text font:[UIFont systemFontOfSize:13] withHeight:25.0f];
    view.frame = CGRectMake(0, 0, width + 60, 25);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
    [self.tokens addObject:text];
    [tokenField reloadData];
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tokens removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return NO;
}

- (CGFloat)widthForText:(NSString*)text font:(UIFont*)font withHeight:(CGFloat)height {
    
    CGSize constraint = CGSizeMake(2000.0f, height);
    CGSize size;
    
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.width;
}
@end
