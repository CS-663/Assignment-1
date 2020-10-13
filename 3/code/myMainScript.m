%% MyMainScript

tic;
%% Your code here
    img = imread('../data/hall.jpg');
    img = rgb2gray(img);
    histogram_equalization(img);
    histogram_equalization_mod(img, calculate_a(img));
    plot_img(img, 'Normal');
toc;

%Implementing Original Histogram Equalization
function histogram_equalization(img)
    [height, width] = size(img);
    hist = zeros(256,1);
    for i = 1:height
        for j = 1:width
            hist(img(i, j)) = hist(img(i, j)) + 1;
        end
    end
    p_r = hist/(height*width);
    s = zeros(256, 1);
    temp = 0;
    for i = 1:256
        temp = temp + p_r(i);
        s(i) = int16(256*temp);
    end
    
    for i = 1:height
        for j = 1:width
            img(i, j) = s(img(i, j));
        end
    end
    plot_img(img, 'Histogram Equalization');
end

%Implementing the modified histogram equalization
function histogram_equalization_mod(img, a)
    [height, width] = size(img);
    hist = zeros(256,1);
    for i = 1:height
        for j = 1:width
            hist(img(i, j)) = hist(img(i, j)) + 1;
        end
    end
    hist1 = hist(1:a);
    hist2 = hist(a+1:256);
    p_r1 = hist1/(height*width);
    p_r2 = hist2/(height*width);
    s1 = zeros(a, 1);
    s2 = zeros(256-a, 1);
    
    temp = 0;
    for i = 1:a
        temp = temp + p_r1(i);
        s1(i) = int16(a*temp);
    end
    
    temp = 0;
    for i = 1:(256-a)
        temp = temp + p_r2(i);
        s2(i) = int16((256-a)*temp);
    end
    
    for i = 1:height
        for j = 1:width
            if img(i,j)<=a
                img(i,j)=s1(img(i,j));
            else
                img(i,j)=s2(img(i,j)-a);
            end
        end
    end
    plot_img(img, 'Modified');
end

%This function calculates the appropriate median values
function a = calculate_a(img)
    [height, width] = size(img);
    hist = zeros(256,1);
    for i = 1:height
        for j = 1:width
            hist(img(i, j)) = hist(img(i, j)) + 1;
        end
    end
    p_r = hist/(height*width);
    temp = 0;
    for i = 1:256
        temp = temp + p_r(i);
        if temp>=0.5
            a=i;
            break;
        end
    end
    
end

function plot_img(img, name)
    figure('Name', name)
    %subplot(1,2,1)
    imshow(img)
    %imsave
    %subplot(1,2,2)
    %imhist(img)
end