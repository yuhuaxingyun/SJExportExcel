//
//  SJAddViewController.m
//  SJExportExcel
//
//  Created by mac on 2020/8/19.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "SJAddViewController.h"
#import "SJAddViewCell.h"

@interface SJAddViewController ()<UITableViewDelegate,UITableViewDataSource,SJAddViewCellDelegate>
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *muDict;
@end

@implementation SJAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *keysarray = [[SJExcelModel new] getAllProperties];
    for (int i=0;i<keysarray.count;i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%@", [keysarray objectAtIndex:i]] forKey:@"key"];
        [dict setValue:@"" forKey:@"value"];
        [self.dataArray addObject:dict];
    }
    
    [self initUI];
}

- (void)initUI{
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self.view addSubview:self.tableView];
}

- (void)saveClick{
    SJExcelModel *excelModel = [[SJExcelModel alloc]initWithDictionary:self.muDict error:nil];
    for (NSString *key in [self.muDict allKeys]) {
        NSArray *keysArray = [excelModel getAllProperties];
        if ([keysArray containsObject:key]) {
            [SJExcelModel setPropertWithPropertyName:key value:[self.muDict objectForKey:key] model:excelModel];
        }
    }

    if (excelModel) {
        self.addDataBlock(excelModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AddCell";
    SJAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SJAddViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSMutableDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
        cell.key = dict[@"key"];
        cell.value = dict[@"value"];
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (void)inputTextFieldText:(NSString *)text addViewCell:(nonnull SJAddViewCell *)addViewCell{
    
    NSArray *keysArray = [[SJExcelModel new] getAllProperties];
    NSString *tagKey = [keysArray objectAtIndex:addViewCell.tag];
    for (NSString *key in keysArray) {
        if ([key isEqualToString:tagKey]) {
            [self.muDict setObject:text forKey:key];

        }
    }
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)muDict{
    if (!_muDict) {
        _muDict = [NSMutableDictionary dictionary];
    }
    return _muDict;
}

@end
