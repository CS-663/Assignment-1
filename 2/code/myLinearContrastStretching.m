function imgOut = myLinearContrastStretching(imgIn)
% Image Input(uint8) -> Image Output(uint8)
% linear mapping, [minIntensity, maxIntensity] to [0, 255]
% imgOut = 255 * (imgIn - minIntensity)/(maxIntensity - minIntensity) 
% provided maxIntensity ~= minIntensity
    imgIn = double(imgIn);
    maxIntensity = max(max(imgIn));
    minIntensity = min(min(imgIn));
    diff = maxIntensity - minIntensity;
    imgOut = imgIn;
    if ndims(diff) == 3
        for x = 1:3
            tempDiff = diff(1,1,x);
            tempMinInt = minIntensity(1,1,x);
            if tempDiff ~= 0
                imgOut(:,:,x) = (255/ tempDiff)*(imgIn(:,:,x)-tempMinInt);
            end
        end
    elseif diff ~= 0
        imgOut = (255/diff) * (imgIn - minIntensity);
    end
    imgOut = uint8(imgOut);
end