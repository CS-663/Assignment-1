%% MyMainScript

tic;

%% Down Sampling %%

shrinkimg=imread("../data/circles_concentric.png");
shrinkedimgby2=myShrinkImageByFactorD(shrinkimg,2);
shrinkedimgby3=myShrinkImageByFactorD(shrinkimg,3);
subplot(3,1,1)
imshow(shrinkimg),axis equal tight on;
title("Input Image");
colorbar;
subplot(3,1,2)
imshow(shrinkedimgby2),axis equal tight on;
title("Shrinked Image by factor 2");
colorbar;
subplot(3,1,3)
imshow(shrinkedimgby3),axis equal tight on;
title("Shrinked Image by factor 3");
colorbar;
imwrite(shrinkedimgby2,"../images/outputSrinkImageBy2.png");
imwrite(shrinkedimgby3,"../images/outputSrinkImageBy3.png");

%% Bilinear %%

enlargeimg=im2double(imread("../data/barbaraSmall.png"));
M=size(enlargeimg,1);
N=size(enlargeimg,2);
finM=3*M-2;
finN=2*N-1;
enlargedimg=myImageResize(enlargeimg,[finM, finN]);
figure
subplot(1,2,1), imshow(enlargeimg), axis equal tight on;
title("Input Image");
colorbar;
subplot(1,2,2), imshow(enlargedimg), axis equal tight on;
title("Enlarged Image by Bilinear Interpolation");
colorbar;
daspect([(M * finN)/(N * finM), 1, 1]);
imwrite(enlargedimg,"../images/outputBilinear.png");

%% Nearest Neighbour  %%

enlargeimg=im2double(imread("../data/barbaraSmall.png"));
M=size(enlargeimg,1);
N=size(enlargeimg,2);
finM=3*M-2;
finN=2*N-1;
enlargedimg=myNearestNeighborInterpolation(enlargeimg,[finM, finN]);
figure
subplot(1,2,1), imshow(enlargeimg), axis equal tight on;
title("Input Image");
colorbar;
subplot(1,2,2), imshow(enlargedimg), axis equal tight on;
title("Enlarged Image by Nearest-Neighbour Interpolation");
colorbar;
daspect([(M * finN)/(N * finM), 1, 1]);
imwrite(enlargedimg,"../images/outputNearestNeighbour.png");

%% Bicubic %%

enlargeimg=im2double(imread("../data/barbaraSmall.png"));
M=size(enlargeimg,1);
N=size(enlargeimg,2);
finM=3*M-2;
finN=2*N-1;
enlargedimg=myBicubicInterpolation(enlargeimg,[finM, finN]);
figure
subplot(1,2,1), imshow(enlargeimg), axis equal tight on;
title("Input Image");
colorbar;
subplot(1,2,2), imshow(enlargedimg), axis equal tight on;
title("Enlarged Image by Bicubic Interpolation");
colorbar;
daspect([(M * finN)/(N * finM), 1, 1]);
imwrite(enlargedimg,"../images/outputBicubic.png");

%% Image Rotate %%

[rotateimg]= im2double(imread("../data/barbaraSmall.png"));
angle= -30;
rotatedimg = myImageRotation(rotateimg, angle); 
figure
subplot(1,2,1), imshow(rotateimg), axis equal tight on;
title("Input Image");
colorbar;
subplot(1,2,2), imshow(rotatedimg), axis equal tight on;
title("Rotated Image by Bilinear Interpolation");
colorbar;
imwrite(rotatedimg,"../images/outputImageRotate.png");

toc;

%% End of Code %%