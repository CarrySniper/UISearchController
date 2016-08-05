//
//  ViewController.h
//  UISearchController
//
//  Created by 思久科技 on 16/8/4.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UITableViewDelegate, UITableViewDataSource              ——UITableView代理
 *  UISearchControllerDelegate, UISearchResultsUpdating     ——UISearchController代理
 */
@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>
{
    NSMutableArray *_dataArray;     // 数据源数组
    NSMutableArray *_searchArray;   // 搜索结果数组
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;

@end

