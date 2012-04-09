//
//  RBParallaxScrollerTableVC.m
//  RBParallaxTableViewController
//
//  Created by @RheeseyB on 01/02/2012.
//  Copyright (c) 2012 Rheese Burgess. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


#import "RBParallaxScrollerTableVC.h"

@implementation RBParallaxScrollerTableVC

static CGFloat WindowHeight = 200.0;
static CGFloat ImageHeight  = 300.0;

- (id)initWithImages:(NSArray *)images {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _imageScroller  = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _imageScroller.backgroundColor                  = [UIColor clearColor];
        _imageScroller.showsHorizontalScrollIndicator   = NO;
        _imageScroller.showsVerticalScrollIndicator     = NO;
        
        NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:[images count]];
        for (UIImage *image in images) {
            UIImageView *imageView  = [[[UIImageView alloc] initWithImage:image] autorelease];
            
            [imageViews addObject:imageView];
            [_imageScroller addSubview:imageView];
        }
        _imageViews = [imageViews retain];
        
        _transparentScroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _transparentScroller.backgroundColor                = [UIColor clearColor];
        _transparentScroller.delegate                       = self;
        _transparentScroller.bounces                        = NO;
        _transparentScroller.pagingEnabled                  = YES;
        _transparentScroller.showsVerticalScrollIndicator   = NO;
        _transparentScroller.showsHorizontalScrollIndicator = NO;
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor              = [UIColor clearColor];
        _tableView.dataSource                   = self;
        _tableView.delegate                     = self;
        _tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_imageScroller];
        [self.view addSubview:_tableView];
    }
    return self;
}

#pragma mark - Parallax effect

- (void)updateOffsets {
    CGFloat yOffset   = _tableView.contentOffset.y;
    CGFloat xOffset   = _transparentScroller.contentOffset.x;
    CGFloat threshold = ImageHeight - WindowHeight;
    
    if (yOffset > -threshold && yOffset < 0) {
        _imageScroller.contentOffset = CGPointMake(xOffset, floorf(yOffset / 2.0));
    } else if (yOffset < 0) {
        _imageScroller.contentOffset = CGPointMake(xOffset, yOffset + floorf(threshold / 2.0));
    } else {
        _imageScroller.contentOffset = CGPointMake(xOffset, yOffset);
    }
}

#pragma mark - View Layout

- (void)layoutImages {
    CGFloat imageWidth   = _imageScroller.frame.size.width;
    CGFloat imageYOffset = floorf((WindowHeight  - ImageHeight) / 2.0);
    CGFloat imageXOffset = 0.0;
    
    for (UIImageView *imageView in _imageViews) {
        imageView.frame = CGRectMake(imageXOffset, imageYOffset, imageWidth, ImageHeight);        
        imageXOffset   += imageWidth;
    }
    
    _imageScroller.contentSize = CGSizeMake([_imageViews count]*imageWidth, self.view.bounds.size.height);
    _imageScroller.contentOffset = CGPointMake(0.0, 0.0);
    
    _transparentScroller.contentSize = CGSizeMake([_imageViews count]*imageWidth, WindowHeight);
    _transparentScroller.contentOffset = CGPointMake(0.0, 0.0);
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    
    _imageScroller.frame        = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    _transparentScroller.frame  = CGRectMake(0.0, 0.0, bounds.size.width, WindowHeight);
    
    _tableView.backgroundView   = nil;
    _tableView.frame            = bounds;
    
    [self layoutImages];
    [self updateOffsets];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { return 1;  }
    else              { return 26; }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { return WindowHeight; }
    else                        { return 10.0;         }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier   = @"RBParallaxTableViewCell";
    static NSString *windowReuseIdentifier = @"RBParallaxTableViewWindow";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!cell) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier] autorelease];
            cell.backgroundColor             = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:_transparentScroller];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier] autorelease];
            cell.contentView.backgroundColor = [UIColor blueColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
            
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
}

#pragma mark - Dealloc

- (void)dealloc {
    RB_SAFE_RELEASE(_imageViews);
    RB_SAFE_RELEASE(_imageScroller);
    RB_SAFE_RELEASE(_transparentScroller);
    RB_SAFE_RELEASE(_tableView);
    
    [super dealloc];
}

@end
