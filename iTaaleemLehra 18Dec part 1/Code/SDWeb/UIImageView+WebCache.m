/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [activity startAnimating];
    [activity setFrame:CGRectMake((self.frame.size.width/2)-12, (self.frame.size.height/2)-12, 25, 25)];
    activity.hidesWhenStopped = YES;
    [self addSubview:activity];
    [activity release];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        // the image is cached -> remove activityIndicator from view
        for (UIView *v in [self subviews])
        {
            if ([v isKindOfClass:[UIActivityIndicatorView class]])
            {
                [activity removeFromSuperview];
            }
        }
    }

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}


- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            // NSLog(@"-didFinishWithImage-");
            [((UIActivityIndicatorView*)v) stopAnimating];
            [v removeFromSuperview];
        }
    }
    
//    [UIView beginAnimations:@"fadeAnimation" context:NULL];
//    [UIView setAnimationDuration:0.6];
//    self.alpha = 0;
    self.image = image;
//    self.alpha=1;
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
//    [UIView commitAnimations];
}

@end
