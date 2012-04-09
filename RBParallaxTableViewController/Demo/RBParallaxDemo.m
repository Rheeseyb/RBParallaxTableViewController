//
//  RBParallaxDemo.m
//  RBParallaxTableViewController
//
//  Created by @RheeseyB on 09/04/2012.
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

#import "RBParallaxDemo.h"
#import "RBParallaxTableVC.h"
#import "RBParallaxScrollerTableVC.h"

@implementation RBParallaxDemo

#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"RBParallaxDemo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Standard Background Image";
    } else {
        cell.textLabel.text = @"Scrollable Background Image";
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *nextView = nil;
    
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"demo1"],
                       [UIImage imageNamed:@"demo2"],
                       [UIImage imageNamed:@"demo3"],
                       [UIImage imageNamed:@"demo4"],
                       nil];
    
    if (indexPath.row == 0) {
        nextView = [[[RBParallaxTableVC alloc] initWithImage:[images objectAtIndex:0]] autorelease];
        nextView.title = @"Standard";
    } else {
        nextView = [[[RBParallaxScrollerTableVC alloc] initWithImages:images] autorelease];
        nextView.title = @"Scrollable";
    }
    
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
