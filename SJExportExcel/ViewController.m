//
//  ViewController.m
//  SJExportExcel
//
//  Created by mac on 2020/8/18.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "ViewController.h"
#import "SJExcelViewController.h"
#import <Masonry/Masonry.h>
#import "xlsxwriter.h"
#import "SJExcelModel.h"
#import "SJAddViewController.h"
#import "SJHomeViewCell.h"
#import <objc/runtime.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *muDataArray;
@property (nonatomic, assign) int rowNum; // 已加载到的行数
@property (nonatomic,strong) UIButton *footerBtn;
//@property (nonatomic,strong) SJExcelModel *excelModel;
@end

static lxw_workbook  *workbook;
static lxw_worksheet *worksheet;

static lxw_format *contentformat; // 文本内容的样式
static lxw_format *moneyformat; // 金钱内容的样式

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initData{

    for (int i=0 ; i<2; i++) {
//        NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
//        [muDict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"ID"];
//        [muDict setObject:@"2020-08-19" forKey:@"time"];
//        [muDict setObject:@"张三" forKey:@"name"];
//        [muDict setObject:@"15829319987" forKey:@"phone"];
//        [self.muDataArray addObject:muDict];

        SJExcelModel *model = [[SJExcelModel alloc]init];
        model.ID = [NSString stringWithFormat:@"%d",i];
        model.time = @"2020-08-19";
        model.name = @"张三";
        model.phone = @"12345678910";
        model.money = @"5.00";
        
        [self.muDataArray addObject:model];
        
    }
}

- (void)initUI{
    
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.editButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.editButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.editButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    self.navigationItem.rightBarButtonItems = @[editItem,addItem];
    
    [self.view addSubview:self.tableView];
}

- (void)saveToFileWithString:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *time = [formatter stringFromDate:[NSDate date]];

    NSFileManager *fileManger = [[NSFileManager alloc]init];
    NSData *fileData = [str dataUsingEncoding:NSUTF16StringEncoding];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingFormat:@"/%@.xlsx",time];
    NSLog(@"文件路径：\n%@",filePath);
    [fileManger createFileAtPath:filePath contents:fileData attributes:nil];
}

- (void)addClick:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
     UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

     UIAlertAction *sexColumn = [UIAlertAction actionWithTitle:@"列" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [weakSelf addColumn];
     }];
     UIAlertAction *sexRows = [UIAlertAction actionWithTitle:@"行" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [weakSelf addRows];
     }];
    
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
     [alertController addAction:sexColumn];
     [alertController addAction:sexRows];
     [alertController addAction:cancelAction];
     [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addColumn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入标题和内容" preferredStyle:UIAlertControllerStyleAlert];
                                          
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *titleTextField = alertController.textFields.firstObject;
        UITextField *connectTextField = alertController.textFields.lastObject;
        NSLog(@"%@,%@",titleTextField.text,connectTextField.text);
        
        //添加属性
        NSString *pinyin = [titleTextField.text transFormChinese];
        [SJExcelModel addPropertWithPropertyName:pinyin];
        
        unsigned int outCount, i;
         objc_property_t *properties = class_copyPropertyList([SJExcelModel class], &outCount);
         for (i = 0; i < outCount; i++) {
             objc_property_t property = properties[i];
             fprintf(stdout, "mytest %s %s\n", property_getName(property), property_getAttributes(property));
         }


        for (int i=0; i<self.muDataArray.count; i++) {
            SJExcelModel *model = [self.muDataArray objectAtIndex:i];
            //属性赋值或修改
            [SJExcelModel setPropertWithPropertyName:pinyin value:connectTextField.text model:model];
            [self.muDataArray removeObjectAtIndex:i];
            [self.muDataArray insertObject:model atIndex:i];
        }

        [self.tableView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入标题";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
        
    }];
  
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)addRows{
    SJAddViewController *addVC = [[SJAddViewController alloc]init];
    addVC.muDataArray = self.muDataArray;
    addVC.addDataBlock = ^(SJExcelModel * _Nonnull model) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
         NSInteger row = self.muDataArray.count;
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
         [indexPaths addObject: indexPath];
         //必须向tableView的数据源数组中相应的添加一条数据
         [self.muDataArray addObject:model];
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
         [self.tableView endUpdates];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)editClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.isSelected) {
        self.addButton.userInteractionEnabled = NO;
        [self.addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.footerBtn.userInteractionEnabled = NO;
        self.footerBtn.backgroundColor = [UIColor grayColor];
    }else{
        self.addButton.userInteractionEnabled = YES;
        [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.footerBtn.userInteractionEnabled = YES;
        self.footerBtn.backgroundColor = [UIColor purpleColor];
    }
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - 生成Excel文件保存到沙盒
- (void)createExcelFormClick{
    // 生成excel
    [self createXlsxFileWith:self.muDataArray];
    
    SJExcelViewController *excelVC = [[SJExcelViewController alloc]init];
    [self.navigationController pushViewController:excelVC animated:YES];
}

- (void)createXlsxFileWith:(NSMutableArray *)dataArray{
    self.rowNum = 0;

    // 文件保存的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]; // 这里也可以储存在NSDocumentDirectory
    NSString *filename = [documentPath stringByAppendingPathComponent:@"sks.xlsx"];
    NSLog(@"== filename_path:%@", filename);
    workbook  = workbook_new([filename UTF8String]); // 创建新xlsx文件，路径需要转成c字符串
    worksheet = workbook_add_worksheet(workbook, [@"测试报表sheet" cStringUsingEncoding:NSUTF8StringEncoding]); // 创建sheet（多sheet页就add多个）
    
    [self setupFormat];
    
    [self createTrafficForm:dataArray];
    
    workbook_close(workbook);
}

// 单元格样式
- (void)setupFormat{
    contentformat = workbook_add_format(workbook);
    format_set_font_size(contentformat, 15);
    format_set_border(contentformat, LXW_BORDER_THIN);
    
    moneyformat = workbook_add_format(workbook);
    format_set_font_size(moneyformat, 15); // 字体大小
    format_set_border(moneyformat, LXW_BORDER_THIN); // 边框（四周）
    format_set_num_format(moneyformat, "0.00"); // 格式
    format_set_align(moneyformat, LXW_ALIGN_VERTICAL_CENTER); // 垂直居中
    /* 其他属性
    format_set_bold(moneyformat); // 加粗
    format_set_font_color(moneyformat, LXW_COLOR_RED); // 颜色
    format_set_align(moneyformat, LXW_ALIGN_CENTER); // 水平居中
    format_set_align(moneyformat, LXW_ALIGN_VERTICAL_CENTER); // 垂直居中
    format_set_top(moneyformat, LXW_BORDER_THIN); // 上边框
    format_set_left(moneyformat, LXW_BORDER_THIN); // 左边框
    format_set_bottom(moneyformat, LXW_BORDER_THIN); // 下边框
    format_set_right(moneyformat, LXW_BORDER_THIN); // 右边框
     */
}

- (void)createTrafficForm:(NSArray *)dataArray{
    [self setupFormContent:dataArray];
}

- (void)setupFormContent:(NSArray *)dataArray{
    SJExcelModel *model = [dataArray lastObject];
    NSArray *keysArray = [model getAllProperties];
    for (int i=0; i<keysArray.count; i++) {
        worksheet_set_column(worksheet, i, i, 30, NULL); // D列宽度（0:起始列 0:终始列 25:列宽）
        worksheet_write_string(worksheet, self.rowNum, i, [[keysArray objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding], contentformat);
    }
    
    for (int j = 0; j < dataArray.count; j++) {
        ++self.rowNum;
        SJExcelModel *model = dataArray[j];
        for (int m=0; m<keysArray.count; m++) {
            NSString *key = [keysArray objectAtIndex:m];
            NSString *value = [SJExcelModel getPropertWithPropertyName:key model:model];
            worksheet_write_string(worksheet, self.rowNum, m, [value cStringUsingEncoding:NSUTF8StringEncoding], contentformat);
        }
    }
    
//    // 设置列宽
//    worksheet_set_column(worksheet, 0, 0, 25, NULL); // D列宽度（0:起始列 0:终始列 25:列宽）
//    worksheet_set_column(worksheet, 1, 2, 35, NULL); // B、C两列宽度（1:起始列 2:终始列 30:列宽）
//    worksheet_set_column(worksheet, 3, 3, 25, NULL); // D列宽度（3:起始列 3:终始列 25:列宽）
//    worksheet_set_column(worksheet, 4, 4, 25, NULL); // D列宽度（4:起始列 4:终始列 25:列宽）
//    worksheet_write_string(worksheet, self.rowNum, 0, "ID", contentformat);
//    worksheet_write_string(worksheet, self.rowNum, 1, "日期", contentformat);
//    worksheet_write_string(worksheet, self.rowNum, 2, "姓名", contentformat);
//    worksheet_write_string(worksheet, self.rowNum, 3, "电话", contentformat);
//    worksheet_write_string(worksheet, self.rowNum, 4, "金额", contentformat);
//
//    for (int i = 0; i < dataArray.count; i++) {
//        SJExcelModel *model = dataArray[i];
//        worksheet_write_string(worksheet, ++self.rowNum, 0, [model.ID cStringUsingEncoding:NSUTF8StringEncoding], contentformat);
//        worksheet_write_string(worksheet, self.rowNum, 1, [model.time cStringUsingEncoding:NSUTF8StringEncoding], contentformat);
//        worksheet_write_string(worksheet, self.rowNum, 2,  [model.name cStringUsingEncoding:NSUTF8StringEncoding], contentformat);
//        worksheet_write_string(worksheet, self.rowNum, 3,  [model.phone cStringUsingEncoding:NSUTF8StringEncoding], contentformat);
//        worksheet_write_number(worksheet, self.rowNum, 4, [model.money doubleValue], moneyformat);
//    }
//
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.muDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    SJHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SJHomeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        SJExcelModel *model = [self.muDataArray objectAtIndex:indexPath.row];
        cell.excelModel = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SJExcelModel *model = [self.muDataArray objectAtIndex:indexPath.row];
    NSArray *keyArray = [model getAllProperties];
    return keyArray.count*20 + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,100)];

    UIButton *footerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3*2, 50)];
    footerBtn.center = footerView.center;
    [footerBtn setTitle:@"生成Excel表单" forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    footerBtn.layer.cornerRadius = 25;
    footerBtn.layer.masksToBounds  = YES;
    footerBtn.backgroundColor = [UIColor purpleColor];
    footerBtn.userInteractionEnabled = YES;
    [footerBtn addTarget:self action:@selector(createExcelFormClick) forControlEvents:UIControlEventTouchUpInside];
    self.footerBtn = footerBtn;
    [footerView addSubview:footerBtn];
    
    return footerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     //判断编辑样式（删除或插入）
     if (editingStyle == UITableViewCellEditingStyleDelete){
      //必须要先删除数据源

         [self.muDataArray removeObjectAtIndex:indexPath.row];
         [self.tableView beginUpdates];
          //接着删除单元格（参数是数组，可能删除多行）
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
          //删除完后要刷新tableView
         [self.tableView endUpdates];
        
     }else if (editingStyle == UITableViewCellEditingStyleInsert){//插入模式
         
         NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
         NSInteger row = self.muDataArray.count;
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
         [indexPaths addObject: indexPath];
         //必须向tableView的数据源数组中相应的添加一条数据
         NSDictionary *dict = @{
                               @"time": @"2020-06-04",
                               @"name": @"李四",
                               @"phone": @"12345678910", // 测试尾数是0的场景
                               @"money": @"5.00" // 测试尾数是.00的场景
                               };
         [self.muDataArray addObject:dict];
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
         [self.tableView endUpdates];
         
         
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.muDataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray *)muDataArray{
    if (!_muDataArray) {
        _muDataArray = [NSMutableArray array];
    }
    return _muDataArray;
}

@end
