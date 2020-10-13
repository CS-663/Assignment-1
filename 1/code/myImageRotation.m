function [output] = myImageRotation(img, angle)
    
    angle = -angle;
    
    rowCenter = floor(size(img,1) / 2);
    colCenter = floor(size(img,2) / 2);

    [x, y] = meshgrid(1:size(img,2), 1:size(img,1));
    
    x_wrt_Center = x - colCenter;
    y_wrt_Center = rowCenter - y;
    
    x_wrt_CenterRotated = [];
    y_wrt_CenterRotated = [];
    
    for i = 1:size(img,1)
        xtemp = [];
        ytemp = [];
        for j = 1:size(img,2)
            xtemp = [xtemp, x_wrt_Center(i,j) * cosd(angle) - y_wrt_Center(i,j) * sind(angle)];
            ytemp = [ytemp, x_wrt_Center(i,j) * sind(angle) + y_wrt_Center(i,j) * cosd(angle)];
        end
        x_wrt_CenterRotated = [x_wrt_CenterRotated; xtemp];
        y_wrt_CenterRotated = [y_wrt_CenterRotated; ytemp];
    end
    
    xRotated = x_wrt_CenterRotated + colCenter;
    yRotated = rowCenter - y_wrt_CenterRotated;
    
    output = myBilinearInterpolation(img, yRotated, xRotated);
    
    for channel = 1:size(img,3)    
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                if (xRotated(i,j) < 1 || xRotated(i,j) > size(img,2) || yRotated(i,j) < 1 || yRotated(i,j) > size(img,1))
                    output(i, j, channel) = 0;
                end
            end
        end
    end
end

