%%%% This script has three principal functions:
%% 1) Stimulus creation
%Given an input of screen variables, creates circular gabor patches (4 deg, 2 cycles/deg = 8 cycles, vertically oriented)
%at center of screen -  new one generated every 1/60 seconds - every gabor
%patch is named as g(#previous + 1) - so the first one is g1, the 102nd is
%g102, etc
%% 2) Noise creation
% Noise is created on top of stimulus - its noise-like properties (pseudo-signal-hood) are
% calculated and 
%% 3) Stimulus saving
%Every gabor patch's psychophysical properties are output to an excel file

%% Standard screen-setup
% Clear the workspace and the screen
sca;
close all;
clearvars;
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1); %http://docs.psychtoolbox.org/SyncTrouble

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen (should be equal to the highest number,
% usually 1)
screenNumber = max(screens);

%% INPUT Prompt to define Variables - most standard vars are already inputted but can be changed
prompt = {'Task name', 'Subject''s number', 'age', 'gender', 'group', 'Num of Trials', 'Resolution-x', 'Resolution-y', 'Screen Height', 'Screen Width', 'Distance from Screen', 'Noise Smoothing Dimension', 'Gabor Contrast'};
 defaults = {'SSNAP_', '00_',            '2_',     'F_',   'control_' ,      '6',        '1920',          '1080',         '19.5',          '34.5',            '70',                '0.083',                        '0.1'    };
answer = inputdlg(prompt, 'SSNAP task', 1, defaults);
 [output, subid, subage, gender, group, nTrials, screenresolutionx1, screenresolutiony1, screenheight1, screenwidth1, distancefromscreen1, smoothingdimension1, gaborsigma1] = deal(answer{:});
%% Initial Output Save File Created - used to check for overwrite error before proceeding
 outputname = [output gender subid group subage '.xlsx']; %names the file

%checks to see if the created file already exists
if exist(outputname)==2 % check to avoid overiding an existing file
    fileproblem = input('You goof, that file already exists! File cannot be overwritten. Abort and rename');
    if isempty(fileproblem) | fileproblem==3
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end

foldername = strcat('C:\Users\MCLabAdmin\Documents\MATLAB\SSNAP Coding\', output, gender, subid, group, subage);
mkdir(foldername);

%% Variables
%Screen variables
screenresolutionx = str2num(screenresolutionx1); %screen resolution x axis, retrieved from input
screenresolutiony = str2num(screenresolutiony1); %screen resolution y axis, retrieved from input
screenheight = str2num(screenheight1); %screen height in cm
screenwidth = str2num(screenwidth1); %screen width in cm
distancefromscreen = str2num(distancefromscreen1); %distance from screen in cm
ypixtopix = screenresolutiony/screenheight; %the distance between the center of pixels in the y-axis
xpixtopix = screenresolutionx/screenwidth; %the distance between the center of pixels in the x-axis
cmtopixel = (ypixtopix + xpixtopix)/2; %the cm to pixel conversion constant, outputs pixel (eg. "55.5" means 1 linear cm is equivalent to 55.5 pixels arranged linearly)

%Stimulus variables
stimulusdiameter_vad = 4; %diameter of stimulus in visual angle degrees
stimulusdiameter_rad = 4/(180/pi); %diameter of stimulus in visual angle radia
stimulusdiameter_cm = (2*distancefromscreen)*atan(stimulusdiameter_rad/2); %size of stimulus in cm, converted from stimulussize_vad
stimulusdiameter_pixelrough = stimulusdiameter_cm * cmtopixel; %the pixel diameter of our stimulus 
pixels = round(stimulusdiameter_pixelrough); %lots of functions need an integer input so we round it off

spatfreq_vad = 2;%spatial frequency: 2 cycles per degree of visual angle
spatfreq_pixels = spatfreq_vad/(pixels/stimulusdiameter_vad);%cycles per pixel; same as above, but per pixel. Pixel count depends on vad
spatwavelength_pixels = (spatfreq_pixels^(-1)); %number of pixels per cycle

lambda = spatwavelength_pixels; %lambda
%gaborfield = gabor(lambda,orientation); %technically a "field" of gabors since we have four orientations

% sigma = pixels / 7;
% theta = 0; %orientations
% contrast = 1;
% gamma = 1.0; %spatial aspect ratio
% 


% noise variables
gaborsigma = str2num(gaborsigma1);

%Boundary variables



%Timing, block and trial variables
trialNumber = str2num(nTrials);

interTrialInterval = .5; %time interval in seconds between trials
nTrialsPerBlock = 10; %number of trials per block
numSecs = 1; %duration of a frame

matrixcount = 0;
noisesigma = 0.1;

%% Set window priorities, window coordinates, and define colours
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black); %PTB notices the command 'OpenWindow' and creates two things:
% a window ID "10" and the dimensions and location of the window [L T R B]
% in pixels = [0 0 1920 1080]
[xCenter, yCenter] = RectCenter(windowRect); %defines the point of origin(x,y) as the center of the window (rectangular)

%set priority levels
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

ifi = Screen('GetFlipInterval', window); %interframe-interval


%% Creates boundary for Gabor Stimulus
BoundaryColor = [0 0 1];
BoundaryThickness = 6; %six pixels thick
BoundarybRect = [0 0 (pixels * 1.1) (pixels * 1.1)];
% BoundarymaxDiameter = max(BoundarybRect) * 1.01; %sets the maxDiameter (makes it circular)
BoundaryRect = CenterRectOnPointd(BoundarybRect, xCenter, yCenter); %set the center of the stimulus 
%diameter 4 degrees to the left of the centre of the fixation circle



%% INITIAL DATA SETUP
data = {'ID', 'Trial_Number', 'Psi', 'Pixels', 'nOscillations', 'Theta', 'Noise Contrast', 'Gabor Contrast'};
% Sync us and get a time stamp

 
%% Time variables
waitframes = 4;
vbl = Screen('Flip',window);
ifi = Screen('GetFlipInterval', window);
numFrames = round(numSecs/ifi); %number of frames to be used during a single draw
 
% Animation loop
for frame = 1:trialNumber
%% Draws stimuli to screen

 %Makes the properties a matrix (can be inserted into cell array)
    psi = rand * 2*pi; %defined locally 
      


%% Creates noise matrix, 
nMatrix = wgn(pixels, pixels, 0); %generates an m-by-n matrix of white Gaussian noise. p specifies the power of y in decibels relative to a watt. The default load impedance is 1 ohm. - power of y is the same as its variance
c = max([abs(min(min(nMatrix))) max(max(nMatrix))]);
nMatrix = nMatrix ./ c; %restricts N to [-1,1]
smoothingdimension_vad = str2num(smoothingdimension1);
smoothingdimension_pixel = round((2*distancefromscreen)*atan((smoothingdimension_vad/(180/pi)/2)) * cmtopixel); %converts visual angle to pixel
if mod(smoothingdimension_pixel,2) == 0
    smoothingdimension_pixel = smoothingdimension_pixel + 1; %smoothing dimension must be odd to ensure a center  element
end


nMatrix = imgaussfilt(nMatrix, noisesigma, 'FilterSize', smoothingdimension_pixel);


% noisetex = Screen('MakeTexture', window, makecircle(nMatrix)); %builds a texture from the noise matrix

%% Creates a Gabor matrix, uses that to build a stimulus in center field
nOscillations = 8;

if rand > 0.5
    theta = 90;
else
    theta = 0;
end
%theta = 90;

n = dwntrast(nMatrix, noisesigma);

g = dwntrast((sinwav(pixels,nOscillations,theta,psi) / 2),gaborsigma);

non_normal_dirtysig = n - mean(n(:)) + g - mean(g(:));
s = non_normal_dirtysig + 0.5;

%% Build texture
backgroundOffset = [0.5 0.5 0.5 0.0]; %RGBA values - all zeroes is black
disableNorm = 1; %%??
preContrastMultiplier = 200; %%???
%gabortex = Screen('MakeTexture', window, g); %uses this matrix to build a texture
%propertiesMat = [psi*180, spatfreq_pixels, sigma, contrast, gamma, 0, 0, 0];


%% Creates a noisy-signal matrix - noise and signal are added together

specialtex1 = Screen('MakeTexture', window, makecircle(s)); %builds the actual texture we want to present


%% Draws to screen for a given frame
    
    %Screen('DrawTexture', window, gabortex, [], [], theta, [], [], [], [],...
    % kPsychDontDoRotation, propertiesMat'); %draws only Gabor - only change per draw should be phase
   %Screen('DrawTexture', window, noisetex, [], [], theta, [], [], [], [],...
    % kPsychDontDoRotation, propertiesMat'); %draws white noise 
   
    Screen('DrawTexture', window, specialtex1);
    Screen('FrameOval', window, BoundaryColor, BoundaryRect, BoundaryThickness); %draws frame, frame should not change

%% Saves the frame-by-frame data ("local data") to an aggregate data file ("data") for later output
    

    localdata = {outputname, trialNumber - 5, psi, pixels, nOscillations, theta, noisesigma, gaborsigma};
    data = [data; localdata];
    vbl = Screen('Flip', window, vbl + (waitframes) * ifi); %
    trialNumber = trialNumber + 1;  
    matrixcount = matrixcount + 1;  
    %for every new draw, redefine this variable
    
    cd(foldername)
    matrixname = strcat('non_normal_dirtysig', num2str(matrixcount), '.mat');
    save(matrixname,'non_normal_dirtysig', '-v7.3')
    cd('C:\Users\MCLabAdmin\Documents\MATLAB\SSNAP Coding')

end
%% Uploads data to Output file
%First step is to make a cell array of all relevant details.

cd(foldername)
xlswrite(outputname,data);
cd('C:\Users\MCLabAdmin\Documents\MATLAB\SSNAP Coding')
%% Termination sequence
% Wait for a key press
KbStrokeWait;
% Clear the screen
sca;

