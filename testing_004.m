function testing_004
    % after eroding, refill cell so that it is its original size
    % might be possible with watershed method
    % figure out a way to implement separation by brightness comparison
    clc
    
    % reads image and converts to grayscale
    someImage = imread('\\Mac\Home\Documents\Rice\LAB\Images\Example_1c.jpg');
    % someImage = imread('\\Mac\Home\Documents\Rice\LAB\Images\Provided Images\Export_PYK2_555_RFP_10x_ 2.tif');
    [rows columns numberOfColorChannels] = size(someImage);
    if numberOfColorChannels > 1
        bwImage = rgb2gray(someImage);
    else
        bwImage = someImage; % It's already gray.
    end
    
    % subtracts foreground from background to find cells
    backGround = imopen(bwImage, strel('disk', 35));
    figure
    foreGround = bwImage - backGround;
    resultImage = imadjust(foreGround);
    
    % using structuring elements and erosion 
    % to create approximations of cells
    structEl = offsetstrel('ball', 8, 0);
    imgEro = imerode(resultImage, structEl);
    
    % adjusts contrast to see more cells
    imgBaC = imadjust(imgEro, [0; 0.005], [0.8; 0]);
        % notes on imadjust:
        % a: decrease contrast, b: increase contrast
        % c: increase brightness, d: decrease brightness
            % success with: c = .8, increasing from b = .01 removes cells
    % imshow(imgBAC)
    
    % binarize/filter image and create complement
        % complement changes white background & black cells
        % to black background and white cells
    imgBIN = imbinarize(imgBaC);
    % Aziza's version of ML does not support imbinarize
        % workaround:
        % level = graythresh(imgBaC);
        % imgBIN = im2bw(imgBaC, level);
        % imshow(imgBIN)
    
    imgCOM = imcomplement(imgBIN);
    imgBaW  = im2bw(imgCOM);

    % find connected components
    bw = imgBaW;
    bw = bwareaopen(bw, 40);
    % the number selects which cell to isolate
    imshow(bw)
    connectedComponents = bwconncomp(bw, 8);
    % bwconncomp find sconnected components (read: objects)
    % in binary image
    grain = false(size(bw));
    grain(connectedComponents.PixelIdxList{103}) = true;
    
    % color label individual cells 
    labeled = labelmatrix(connectedComponents);
    RGB_label = label2rgb(labeled, @prism, 'c', 'shuffle');
        % the second entry '@___' can be changed for more colors
    imshow(RGB_label)
    
    % number label individual cells
    L = labeled;
    s = regionprops(L, 'Centroid');
    % imshow(RGB_label)
    hold on
    for k = 1:numel(s)
        c = s(k).Centroid;
        text(c(1), c(2), sprintf('%d', k), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle');
    end
    
    % isolates one cell
    soleCell = false(size(bw));
    soleCell(connectedComponents.PixelIdxList{103}) = true;
    % 103: the cell in quadrant 1 with a hole in the middle
    % imshow(soleCell);
