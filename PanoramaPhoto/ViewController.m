//
//  ViewController.m
//  PanoramaPhoto
//
//  Created by 苹果 on 2016/11/18.
//  Copyright © 2016年 苹果. All rights reserved.
//

#import "ViewController.h"
#import "CVWrapper.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController * picker;
@property (strong, nonatomic) NSMutableArray * photos;
@property (strong, nonatomic) UIActivityIndicatorView * activity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark actions
- (IBAction)takePictureButtonMethod:(UIButton *)sender {
    [self.photos removeAllObjects];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        [self presentViewController:self.picker animated:YES completion:nil];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"sorry" message:@"camera is not available" delegate:nil cancelButtonTitle:@"got it" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)combineButtonMethod:(UIButton *)sender {
    if (!self.photos.count) {
        return;
    }
    sender.enabled = NO;
    [self.activity startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * image = [CVWrapper processWithArray:self.photos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            [self.activity stopAnimating];
            sender.enabled = YES;
        });
    });
}

- (void)dismissCamera{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePicture{
    [self.picker takePicture];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * smallImage = [CVWrapper imageWithImage:image Scale:0.1];
    [self.photos addObject:smallImage];
}

#pragma mark setter
- (UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        UIToolbar * tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-55, self.view.frame.size.width, 55)];
        tool.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissCamera)];
        UIBarButtonItem * blank = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(takePicture)];
        [tool setItems:[NSArray arrayWithObjects:done,blank,add, nil]];
        self.picker.cameraOverlayView = tool;
        self.picker.showsCameraControls = NO;
        self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    return _picker;
}

- (UIActivityIndicatorView *)activity{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center = self.view.center;
        [self.view addSubview:_activity];
    }
    return _activity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
