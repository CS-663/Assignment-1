function foregroundMask = myForegroundMask(image, thPercent)
% image(uint8), thresholdPercent(double) -> foregroundMask(logical)
% output an array of same size as image where element is 1 iff image
% element's intensity is greater than threshold percentage of 
% (maxIntensity - minIntensity).
% Only works with monochrome images
    image = double(image);
    maxIntensity = max(max(image));
    minIntensity = min(min(image));
    thIntensity = thPercent * 0.01 * (maxIntensity - minIntensity) ...
        + minIntensity;
    foregroundMask = image > thIntensity;
end
