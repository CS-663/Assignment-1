%% MyMainScript
colormap = parula(256);
formatComplete = 'Completed part (%s)\n';
% info of images 1 to 6 formatted in columns of (imgNum, imageDirectory, 
% colored)
imgTable = readtable('imageInfo.csv');
load imgCells_e;

%% a) Foreground Mask
tic;

img7 = imread("../data/statue.png");
foregroundMask7 = myForegroundMask(img7, 30);
maskedImg7 = uint8(double(img7) .* foregroundMask7);

% Output figures
figure('Name', 'Part (a)');
subplot(2,2,1), imshow(img7);
axis equal tight on;
title('Original Image');
colorbar;
subplot(2,2,2), imshow(foregroundMask7);
axis equal tight on;
title('foreground Mask');
colorbar;
subplot(2,2,3), imshow(maskedImg7);
axis equal tight on;
title('Masked Image');
colorbar;
impixelinfo;

fprintf(formatComplete, 'a');
toc;
%% b) Linear Contrast Stretching
tic;

for num = [1 2 3 5 6]
    img = imread(cell2mat(imgTable.Dir(num))); 
    imgOut = myLinearContrastStretching(img); 

    figure('Name', sprintf('Part (b) Image %d', num));
    subplot(1,2,1), imshow(img);
    axis equal tight on;
    title('Original');
    colorbar;
    subplot(1,2,2), imshow(imgOut);
    axis equal tight on;
    title('Output');
    colorbar;
    impixelinfo;
end
% application on maskedImg7
figure('Name', sprintf('Part (b) Image %d', 7));
subplot(1,2,1), imshow(maskedImg7);
axis equal tight on;
title('Original');
colorbar;
subplot(1,2,2), imshow(myLinearContrastStretching(maskedImg7));
axis equal tight on;
title('Output');
colorbar;
impixelinfo;

fprintf(formatComplete, 'b');
toc;
%% c) Histogram equalization
tic;

for num1 = [1 2 3 5 6]
    img = imread(cell2mat(imgTable.Dir(num1))); 
    imgOut = myHE(img); 
    figure('Name', sprintf('Part (c) Image %d', num1));
    subplot(1,2,1), imshow(img);
    axis equal tight on;
    title('Original');
    colorbar;
    subplot(1,2,2), imshow(imgOut);
    axis equal tight on;
    title('Output');
    colorbar;
    impixelinfo;
end
%Application on maskedImg7
figure('Name', sprintf('Part (c) Image %d', 7));
subplot(1,2,1), imshow(maskedImg7);
axis equal tight on;
title('Original');
colorbar;
subplot(1,2,2), imshow(myHE(maskedImg7));
axis equal tight on;
title('Output');
colorbar;
impixelinfo;

fprintf(formatComplete, 'c');
toc;
%% d) Histogram Matching
tic;
imgInRet = imread('../data/retina.png');
imgRefRet = imread('../data/retinaRef.png');
imgHistMatchRet = imhistmatch(imgInRet, imgRefRet);

figure('Name', 'Part (d)');
subplot(2,2,1), imshow(imgInRet);
axis equal tight on;
title('Original Image');
colorbar;
subplot(2,2,2), imshow(imgRefRet);
axis equal tight on;
title('Reference Image');
colorbar;
subplot(2,2,3), imshow(imgHistMatchRet);
axis equal tight on;
title('Histogram Matched Image');
colorbar;
impixelinfo;

fprintf(formatComplete, 'd');
toc;

%% e) CLAHE
tic;
orgWinSize = 0.4; orgHistTh = 0.6;
lowWinSize = 0.1; highWinSize = 0.9;

%% setup image files (Warning!! takes long time)
% contains (img, clahe, lowWinClahe, highwinClahe, halfThClahe) in columns
% of all 6 images spread across row
imgCells_e = cell(6,5); 
for num2 = [1 2 3 6]
    img = imread(cell2mat(imgTable.Dir(num2)));
    imgCells_e{num2,1} = img;
    imgCells_e{num2,2} = myCLAHE(img, orgWinSize, orgHistTh); % clahe
    imgCells_e{num2,3} = myCLAHE(img, lowWinSize, orgHistTh);
    imgCells_e{num2,4} = myCLAHE(img, highWinSize, orgHistTh);
    imgCells_e{num2,5} = myCLAHE(img, orgWinSize, orgHistTh/2);
end
save imgCells_e;
%% output images
for num2 = [1 2 3 6]
    figure('Name', sprintf('Part (e) Image %d', num2));
    subplot(3,2,1), imshow(imgCells_e{num2,1});
    axis equal tight on;
    title('Original');
    colorbar;
    subplot(3,2,2), imshow(imgCells_e{num2,2});
    axis equal tight on;
    title(sprintf('CLAHE, winSize = %f, thHist = %f', orgWinSize, ...
        orgHistTh));
    colorbar;
    subplot(3,2,3), imshow(imgCells_e{num2,3});
    axis equal tight on;
    title(sprintf('CLAHE, winSize = %f, thHist = %f', lowWinSize, ...
        orgHistTh));
    colorbar;
    subplot(3,2,4), imshow(imgCells_e{num2,4});
    axis equal tight on;
    title(sprintf('CLAHE, winSize = %f, thHist = %f', highWinSize, ...
        orgHistTh));
    colorbar;
    subplot(3,2,5), imshow(imgCells_e{num2,5});
    axis equal tight on;
    title(sprintf('CLAHE, winSize = %f, thHist = %f', orgWinSize, ...
        orgHistTh/2));
    colorbar;
    impixelinfo;
end

fprintf(formatComplete, 'e');
toc;