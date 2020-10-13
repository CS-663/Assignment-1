% 0 < winSizeFrac < 1, 0 < histTh < 1
function imgOut = myCLAHE(img, winSizeFrac, histTh)
    roundToOdd = @(x) 2*floor(x/2) + 1;
    [imH, imW, ~] = size(img);
    maxWinSz = roundToOdd(winSizeFrac * [imH, imW]);
    % outputs (image grid around pixel (i,j), relative_i, relative_j)
    function [imO,re_i, re_j] = imgGrid(i, j)
        h = maxWinSz(1);
        w = maxWinSz(2);
        imO = img(max(1, i - floor(h/2)):min(imH, i + floor(h/2)), ...
                  max(1, j - floor(w/2)):min(imW, j + floor(w/2)), :);
        re_i = min(i, floor(h/2) + 1);
        re_j = min(j, floor(w/2) + 1);
    end
    % Transform given histogram by clipping values above threshold
    function histO = thHist(histIn, thValue)
        clippedValues = sum(histIn(histIn > thValue));
        histO = histIn + floor(clippedValues/256);
        remain = mod(clippedValues, 256);
        remainValues = [ones(remain,1); zeros(256-remain,1)];
        histO = histO + remainValues;
    end
    % pixel location as input and output itensity values at that location 
    % after CLAHE
    function intensO = intensCLAHE(i_Im, j_Im)
        [imI, re_i, re_j] = imgGrid(i_Im, j_Im);
        pdf = thHist(imhist(imI,256), histTh * numel(imI));
        cdf=cumsum(pdf);
        minint=min(min(cdf));
        cdf = round(255*(cdf-minint)./(numel(imI)-minint));
        cdf = [0; cdf];
        intensO = uint8(cdf(double(imI(re_i, re_j,:)) + 1));
    end
    imgOut = img;
    for i = 1:imH
        for j = 1:imW
            imgOut(i,j,:) = intensCLAHE(i, j);
        end
    end
end