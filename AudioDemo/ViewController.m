//
//  ViewController.m
//  AudioDemo
//
//  Created by Simon on 24/2/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disable Stop/Play button when the application launches
    [_stopButton setEnabled:NO];
    [_playButton setEnabled:NO];
    
    // Set up the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                             NSUserDomainMask,
                                                                                             YES)lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL
                                            settings:recordSetting
                                               error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
        [_recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [_recorder pause];
        [_recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [_stopButton setEnabled:YES];
    [_playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [_recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender {
    if (!_recorder.recording) {
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:_recorder.url error:nil];
        [_player setDelegate:self];
        [_player play];
    }
}

#pragma mark - DELEGATE METHODS
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag
{
    [_recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [_stopButton setEnabled:NO];
    [_playButton setEnabled:YES];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
