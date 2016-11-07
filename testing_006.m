function testing_006
    % anything below/around br = 250 (eventually part of GUI)
    clc
    
    img = imread('\\Mac\Home\Documents\Rice\LAB\Images\Provided Images\Export_PYK2_555_RFP_10x_ 2.jpg');
    [rows columns numberOfColorChannels] = size(img);
    if numberOfColorChannels > 1
        bwImg = rgb2gray(img);
    else
        bwImg = img; % It's already gray.
    end

    % adImg = imadjust(bwImg, [0; 0.005], [0.8; 0]);
    adImg = imadjust(bwImg, [0; 0.010 ], [0.5; 0]);
    coImg = imcomplement(adImg);
    
    reImg = imregionalmax(coImg);
    re2Img = imregionalmax(bwImg);
    % in future, maybe use coImg and subtract from adImg
    % in order to access background cells
    
    brImg01 = bwImg > 2;
    % erode brImg01 before subtraction 
    brImg02 = bwImg > 1;
    brImgDf = brImg02 - brImg01;
    % http://blogs.mathworks.com/steve/2006/06/02/cell-segmentation/
   
    nwImg = brImgDf - re2Img;
    % using re2img instead of reimg gets rid of large white masses
    
    
    
    % converting cytoplasm to gray
    br_val = 100;
    % 255 = white, 1 = black, range in between
    cyto = br_val * uint8(brImg01);
    
    nwImggs = 255 * uint8(nwImg);
    
    cyt_mem = cyto + nwImggs;
    
    backGround = imopen(bwImg, strel('disk', 35));
    figure
    foreGround = bwImg - backGround;
    resultImage = imadjust(foreGround);
    
    structEl = offsetstrel('ball', 8, 0);
    imgEro = imerode(resultImage, structEl);
    
    
    % use bwareaopen to remove unnecessary pixels
    
    re3Img = imregionalmax(imgEro);
    re3Imggs = 255 * uint8(re3Img);
    

    
    % topography-esque - nope
    brImg03 = bwImg > 5;
    
    full_cell = cyt_mem + re3Imggs;
    % imshow(full_cell)
    
    brImgDfgs = 255 * uint8(brImgDf);
    cyt_nuc_mem = brImgDfgs + full_cell;
    
    
    
     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    % cell segmentation attempt
    
    img_eq = adapthisteq(full_cell);

    bw = im2bw(img_eq, graythresh(img_eq));
    bw2 = imfill(bw, 'holes');
    bw3 = imopen(bw2, ones(5, 5));
    bw4 = bwareaopen(bw3, 40);
    bw4_perim = bwperim(bw4);
    overlay1 = imoverlay(img_eq, bw4_perim, [.3 1 .3]);
    % imshow(overlay1)
    
    
    mask_em = imextendedmax(img_eq, 30);
    
    mask_em = imclose(mask_em, ones(5,5));
    mask_em = imfill(mask_em, 'holes');
    mask_em = bwareaopen(mask_em, 40);
    overlay2 = imoverlay(img_eq, bw4_perim | mask_em, [.3 1 .3]);
    
    % imshow(overlay2)
    
     
    
    % injecting code from testing_004
    % did not work as it just used conn_comp to find cells
    % can be used on nucleus (re3Img) for finding area
    
    bw = re3Img;
    bw = bwareaopen(bw, 40);
    % the number selects which cell to isolate
    
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
    
    graindata = regionprops(connectedComponents, 'Area');
    allAreas = [graindata.Area]; 
    
    meanValue = mean(allAreas(:));
    
    display(meanValue); % = 298.515
    
    fleshed_out = xor(bwareaopen(re3Img, 0), bwareaopen(re3Img, 800));
    
    % imshow(255*uint8(fleshed_out) + cyt_mem)
    
    % https://www.mathworks.com/matlabcentral/answers/46398-removing-objects-which-have-area-greater-and-lesser-than-some-threshold-areas-and-extracting-only-th
    % look at ismember function to iterate over cells with certain area
    