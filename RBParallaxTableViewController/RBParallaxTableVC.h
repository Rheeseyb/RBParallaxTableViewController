//
//  RBParallaxTableView.h
//  RBParallaxTableViewController
//
//  Created by @RheeseyB on 01/02/2012.
//  Copyright (c) 2012 Rheese Burgess. All rights reserved.
//

@interface RBParallaxTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIScrollView *_backgroundView;
    UIImageView  *_imageView;
    UITableView  *_tableView;
}

@end
