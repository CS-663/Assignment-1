function [outputImage] = myShrinkImageByFactorD(inputImage,factorD)
    outputImage=[];
    for i=factorD:factorD:size(inputImage,1)
        temp=[];
        for j=factorD:factorD:size(inputImage,2)
            temp = [temp, inputImage(i,j)];
        end
        outputImage = [outputImage;temp];
    end
end

