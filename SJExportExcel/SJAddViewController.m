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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘回收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//移除通知
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    SJExcelModel *excelModel = [self.muDataArray lastObject];
    for (int i=0; i<excelModel.propertyName.count; i++) {
        SJPropertyModel *model = [excelModel.propertyName objectAtIndex:i];
        SJPropertyModel *propertyModel = [[SJPropertyModel alloc]init];
        propertyModel.propertyName = [NSString stringWithFormat:@"%@",model.propertyName];
        propertyModel.header = [NSString stringWithFormat:@"%@",model.header];
        propertyModel.connect = @"";
        propertyModel.boardType = 1;
        [self.dataArray addObject:propertyModel];
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}

- (void)saveClick{
    
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSString *key in self.muDict) {
        for (int i=0; i<self.dataArray.count; i++) {
            SJPropertyModel *propertyModel = [self.dataArray objectAtIndex:i];
            if ([propertyModel.propertyName isEqualToString:key]) {
                propertyModel.connect = [self.muDict objectForKey:key];
                [muArray addObject:propertyModel];
            }
        }
    }
    if (muArray.count < self.dataArray.count) {
        [self alertControllerWithTitle:@"提示" message:@"表头对应的值不能为空"];

    }else{
        SJExcelModel *excelModel = [[SJExcelModel alloc]init];
        excelModel.propertyName = muArray;
        if (excelModel) {
            self.addDataBlock(excelModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - Event
 //点击事件
- (void)hideKeyBoard{
    [self.view endEditing:YES];
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
        SJPropertyModel *propertyModel = [self.dataArray objectAtIndex:indexPath.row];
        cell.propertyModel = propertyModel;
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
    [self.muDict setObject:text forKey:addViewCell.propertyModel.propertyName];
}

#pragma mark - NSNotification
//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    NSMutableArray *textFields = [NSMutableArray array];
    NSArray *array = [self.tableView visibleCells];
    for (int i=0; i<array.count; i++) {
        SJAddViewCell *cell = [array objectAtIndex:i];
        [textFields addObject:cell.infoField];
    }
    //将需要上移的控件存在这个数组
    UIView *focusView = nil;
    for (UITextField *view in textFields) {
        if ([view isFirstResponder]) {
            focusView = view;
            break;
        }
    }
    if (focusView) {
        //获取键盘弹出的时间
        double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //获取键盘上端Y坐标
    
        CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        //获取输入框下端相对于window的Y坐标
        CGRect rect = [focusView convertRect:focusView.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
        CGPoint tmp = rect.origin;
        CGFloat inputBoxY = tmp.y + focusView.frame.size.height;
        //计算二者差值
        CGFloat ty = keyboardY - inputBoxY;
        NSLog(@"position keyboard: %f, inputbox: %f, ty: %f", keyboardY, inputBoxY, ty);
        //差值小于0，做平移变换
        [UIView animateWithDuration:duration animations:^{
            if (ty < 0) {
                self.view.transform = CGAffineTransformMakeTranslation(0, ty);
            }
        }];
    }
}
 
 
//键盘回收
- (void)keyboardWillHide:(NSNotification *)notification{
    //获取键盘弹出的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //还原
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
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
