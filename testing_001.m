function testing_001
    % notes: rbg label system
    % label the nucleus
    clc
    
    % choose image
    img = imread('\\Mac\Home\Documents\Rice\LAB\Images\Provided Images\Example_1c.jpg');
    
    % convert to grayscale and increase brigthness and contrast
    imgGRA = rgb2gray(img);
    imgBaC = imadjust(imgGRA, [0; 0.005], [0.8; 0]);
        % a: decrease contrast, b: increase contrast
        % c: increase brightness, d: decrease brightness
            % success with: c = .8, increasing from b = .01 removes cells
    %imshow(imgBAC)
    
    % binarize/filter image and create complement
        % complement changes white background & black cells
        % to black background and white cells
    imgBIN = imbinarize(imgBaC);
    imgCOM = imcomplement(imgBIN);
    imgBaW  = im2bw(imgCOM);
    imshow(imgBaW)
    
    % applying adaptive histogram equalization
    % imgBaW16 = im2uint16(imgBaW);
    % imgBaWHEQ = adapthisteq(imgBaW16);
    
    % place a perimeter around original image
    img001 = imfill(imgBaW, 'holes');
    img002 = imopen(img001, ones(5,5));
    img003 = bwareaopen(img002, 40);
    imgPER = bwperim(img003);                       % perimeter applied
    imgOVL = imoverlay(imgBaW, imgPER, 'red');   % per app'd as overlay
    % imshow(imgOVL)
    
    % utilizing imfindcircles
    % [centers, radii] = imfindcircles(imgBaW, [16 35], 'Sensitivity', .9355);
        % smallest radius allowed: 16; largest: 35
    % img2 = imread('\\Mac\Home\Documents\Rice\ML\Images\Example_LContrasted.jpg');
    % imshow(img2)
    % viscircles(centers, radii, 'DrawBackgroundCircle', false);
    
    % structuring elements used
    
    