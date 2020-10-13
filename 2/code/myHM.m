function imgOut = myHM(imgIn, imgRef)
    cdfIn = cumsum(imhist(imgIn)) / numel(imgIn);
    cdfRef = cumsum(imhist(imgRef)) / numel(imgRef);
    % match(index) is imgOut_intensities to be mapped at pixels of imgIn
    % where intensity is (index - 1)
    match = zeros(256, 1);
    for indx = 1:256
        [~, ix] = min(abs(cdfIn(indx) - cdfRef));
        match(indx) = ix - 1;
    end
    imgOut = uint8(match(double(imgIn)+1));
end