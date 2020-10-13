function imagemod = myHE(img)
    pdf = imhist(img,256);
    cdf=cumsum(pdf);
    minint=min(min(cdf));
    cdf = round(255*(cdf-minint)./(numel(img)-minint));
    cdf = [0; cdf];
    imagemod=uint8(cdf(double(img) + 1));
end
