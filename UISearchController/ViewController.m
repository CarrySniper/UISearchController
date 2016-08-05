//
//  ViewController.m
//  UISearchController
//
//  Created by 思久科技 on 16/8/4.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import "ViewController.h"
#import "MyModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 添加到self.navigationItem.titleView中
    self.navigationItem.titleView = self.searchController.searchBar;
    
    // 添加到self.view中
    [self.view addSubview:self.tableView];
    
    // 随机取A-G中的3个字母拼接成字符串
    NSArray *letterArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
    
    _dataArray = [NSMutableArray array];
    
    // 纯字符串数组
    /*
    for (int i = 0; i < 50; i++) {
        int x = arc4random() % 7;
        int y = arc4random() % 7;
        int z = arc4random() % 7;
        NSString *string = [NSString stringWithFormat:@"%@%@%@", letterArray[x], letterArray[y], letterArray[z]];
        [_dataArray addObject:string];
    }
    */
    
    // Model数组
    for (int i = 0; i < 50; i++) {
        int x = arc4random() % 7;
        int y = arc4random() % 7;
        int z = arc4random() % 7;
        NSString *string = [NSString stringWithFormat:@"%@%@%@", letterArray[x], letterArray[y], letterArray[z]];
        
        MyModel *model = [[MyModel alloc]init];
        model.idString = [NSString stringWithFormat:@"%0.2i", i+1];
        model.nameString = string;
        [_dataArray addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [_searchArray count];
    }else{
        return [_dataArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    id obj = _dataArray[0];
    if ([obj isKindOfClass:[NSString class]]) {
        // 纯字符串数组
        if (self.searchController.active) {
            cell.textLabel.text = _searchArray[indexPath.row];
        }else{
            cell.textLabel.text = _dataArray[indexPath.row];
        }
    }else{
        // Model数组
        if (self.searchController.active) {
            MyModel *model = _searchArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@   %@", model.idString, model.nameString];
        }else{
            MyModel *model = _dataArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@   %@", model.idString, model.nameString];
        }
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *selectStr;
    id obj = _dataArray[0];
    if ([obj isKindOfClass:[NSString class]]) {
        // 纯字符串数组
        if (self.searchController.active) {
            selectStr = _searchArray[indexPath.row];
        }else{
            selectStr = _dataArray[indexPath.row];
        }
    }else{
        // Model数组
        if (self.searchController.active) {
            MyModel *model = _searchArray[indexPath.row];
            selectStr = [NSString stringWithFormat:@"id=%@ name=%@", model.idString, model.nameString];
        }else{
            MyModel *model = _dataArray[indexPath.row];
            selectStr = [NSString stringWithFormat:@"id=%@ name=%@", model.idString, model.nameString];
        }
    }
    NSLog(@"选择：%@", selectStr);
}

#pragma mark - UISearchController UISearchControllerDelegate
// These methods are called when automatic presentation or dismissal occurs. They will not be called if you present or dismiss the search controller yourself.
- (void)willPresentSearchController:(UISearchController *)searchController {
    
}
- (void)didPresentSearchController:(UISearchController *)searchController {
    
}
- (void)willDismissSearchController:(UISearchController *)searchController {
    
}
- (void)didDismissSearchController:(UISearchController *)searchController {
    
}

// Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
- (void)presentSearchController:(UISearchController *)searchController {
    
}

#pragma mark - UISearchController UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [self filterPredicateWithSearchString:[searchController.searchBar text]];
    
    [self.tableView reloadData];
}

#pragma mark - NSPredicate匹配方法
- (void)filterPredicateWithSearchString:(NSString *)searchString{
    /*
     比较运算符>,<,==,>=,<=,!=
     数组包含   [NSPredicate predicateWithFormat:@"SELF in %@",array];
     @"name LIKE[cd] '*er*'"        *代表通配符,Like也接受[cd].
     @"name CONTAIN[cd] 'ang'"      包含某个字符串
     @"name BEGINSWITH[c] 'sh'"     以某个字符串开头
     @"name ENDSWITH[d] 'ang'"      以某个字符串结束
     
     [c]不区分大小写；[d]不区分发音符号即没有重音符号；[cd]既不区分大小写，也不区分发音符号。
     */
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    id obj = _dataArray[0];
    if ([obj isKindOfClass:[NSString class]]) {
        // 纯字符串数组
        _searchArray = [NSMutableArray arrayWithArray:[_dataArray filteredArrayUsingPredicate:preicate]];
    }else{
        // Model数组
        [_searchArray removeAllObjects];
        if (!_searchArray) {
            _searchArray = [NSMutableArray array];
        }
        for (int i = 0; i < _dataArray.count; i++) {
            MyModel *model = _dataArray[i];
            NSString *content = model.nameString;   // 匹配内容为 model.nameString，这个根据自己需求匹配
            if ([preicate evaluateWithObject:content]) {
                [_searchArray addObject:_dataArray[i]];
            }
        }
    }
}


#pragma mark - 实例化
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.5)];
        footView.backgroundColor = tableView.separatorColor;
        tableView.tableFooterView = footView;
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView = tableView;
    }
    return _tableView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.delegate = self;
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = NO;        //是否添加半透明覆盖层
        searchController.hidesNavigationBarDuringPresentation = NO;    //是否隐藏导航栏
        
        // 这里还可以自定义searchController.searchBar。UISearchBar的属性都可以设置
        searchController.searchBar.placeholder = @"自定义搜索提示";
        
        _searchController = searchController;
    }
    return _searchController;
}

@end
