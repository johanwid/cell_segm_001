function testing_003
    clc
    
    % reads image and converts to grayscale
    someImage = imread('\\Mac\Home\Documents\Rice\ML\Images\Example_1c.jpg');
    gsImage = rgb2gray(someImage);
    
    % subtracts foreground from background to find cells
    backGround = imopen(gsImage, strel('disk', 35));
    figure
    foreGround = gsImage - backGround;
    resultImage = imadjust(foreGround);
    % imshow(resultImage);
    
    % using gradient magnitude for segmentation and outlines cells
    hY = fspecial('sobel');
    hX = hY';
    iY = imfilter(double(resultImage), hY, 'replicate');
    iX = imfilter(double(resultImage), hX, 'replicate');
    grandmag = sqrt(iX.^2 + iY.^2);
    % imshow(grandmag, [])
    
    % using structuring elements to create disk approximation of cell
    structEl = strel('disk', 3, 4);
    img = imopen(resultImage, structEl);
    % imshow(img)
    
    % convert to BW (no gray)
    bwImage = im2bw(img);
    imshow(bwImage)