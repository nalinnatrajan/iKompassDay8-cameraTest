//
//  ViewController.m
//  cameraTest
//
//  Created by Nalin Natrajan on 15/3/15.
//  Copyright (c) 2015 Nalin Natrajan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property UIImage *image;

@property NSURL *videoURL;

- (IBAction)onCameraButtonPressed:(id)sender;

- (IBAction)onSaveButtonPressed:(id)sender;

- (IBAction)onSharedButtonPressed:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image = nil;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCameraButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Load photo from gallery", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    
}

- (IBAction)onSaveButtonPressed:(id)sender {
    if(self.image){
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        self.image = nil;
        return;
    }
}

- (IBAction)onSharedButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Social Share" delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"Email", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self loadPhoto];
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [self shareOnTwitter];
                break;
            case 1:
                [self shareOnFacebook];
                break;
            case 2:
                [self shareViaEmail];
                break;
        }
    }
}

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.image = info[UIImagePickerControllerEditedImage];
        self.imageView.image = self.image;
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        //NSURL *url = info[UIImagePickerControllerMediaURL];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo: (void *)contextInfo{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:@"Failed to save media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    self.image = nil;
}

-(void)takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate =(id)self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = true;
        [self presentViewController:imagePicker animated:true completion:nil];
    }
}

-(void)loadPhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = (id)self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = true;
        [self presentViewController:imagePicker animated:true completion:nil];
    }
}

-(void)shareOnTwitter{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetController setInitialText:@"Some nice shots of Singapore!"];
        [tweetController addImage:self.image];
        [self presentViewController:tweetController animated:true completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Support for Twitter is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)shareOnFacebook{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *postController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [postController setInitialText:@"Some nice shots of Singapore!"];
        [postController addImage:self.image];
        [self presentViewController:postController animated:true completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Support for Facebook is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)shareViaEmail{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Go use Twitter or Facebook!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
@end
