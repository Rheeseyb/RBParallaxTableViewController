//
//  RBParallaxTableVC.m
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


#import "RBParallaxTableVC.h"

@implementation RBParallaxTableVC

static CGFloat HeaderHeight = 200.0;

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
        _backgroundView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_backgroundView addSubview:_imageView];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self.view addSubview:_backgroundView];
        [self.view addSubview:_tableView];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect  bounds      = self.view.bounds;
    CGFloat imageHeight = _imageView.frame.size.height;
    CGFloat imageOffset = floorf((HeaderHeight - imageHeight) / 2.0);
    
    _imageView.frame      = CGRectMake(0.0, imageOffset, bounds.size.width, imageHeight);    
    _backgroundView.frame = bounds;
    _tableView.frame      = bounds;
}

#pragma mark - Table View Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"RBParallaxTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat threshold = _imageView.frame.size.height - HeaderHeight;
    
    if (offset.y > -threshold && offset.y < 0) {
        _backgroundView.contentOffset = CGPointMake(offset.x, floorf(offset.y / 2.0));
    } else if (offset.y < 0) {
        _backgroundView.contentOffset = CGPointMake(offset.x, offset.y + floorf(threshold / 2.0));
    } else {
        _backgroundView.contentOffset = offset;
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    RB_SAFE_RELEASE(_backgroundView);
    RB_SAFE_RELEASE(_imageView);
    RB_SAFE_RELEASE(_tableView);
    
    [super dealloc];
}

@end
