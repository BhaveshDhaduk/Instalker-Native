//
//  MediaViewController.m
//  Instalker
//
//  Created by umut on 29/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "MediaViewController.h"
#import "MediaCollectionViewCell.h"
#import "BigImageViewController.h"

@interface MediaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.delegate=self;
    _collectionView.dataSource = self;
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Media List"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCollectionViewCell *cell = (MediaCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BigImageViewController *imageVC = [[BigImageViewController alloc]initWithNibName:@"BigImageViewController" bundle:[NSBundle mainBundle]];
    imageVC.media = cell.media;
    //    [self.navigationController presentViewController:imageVC animated:YES completion:nil];
    [self.navigationController presentViewController:imageVC animated:YES completion:nil];

    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _arrayLikedMedias.count/3+1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger sectionCount = _arrayLikedMedias.count/3 + 1;
    if (sectionCount-1 == section) {
        
        return _arrayLikedMedias.count - ((sectionCount-1)*3);
        
    }else
    {
        return 3;
    }

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mediaCell" forIndexPath:indexPath];
    if (cell) {
        
        @try {
            long row = (long)(indexPath.row);
            long section = (long)(indexPath.section);
            NSInteger index = (section * 3) + row;
            
            cell.media = (InstagramMedia *)[_arrayLikedMedias objectAtIndex:index];
            [cell configureImageViewSelfURL];
        }
        @catch (NSException *exception) {
           
        }
        @finally {
        }
        NSLog(@"indexpath Row : %ld",(long)indexPath.row);
        NSLog(@"section :%ld",(long)indexPath.section);
        NSLog(@"index %@",indexPath);
    }
    return cell;
}

@end
