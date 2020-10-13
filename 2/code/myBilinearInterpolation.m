function [out] = myBilinearInterpolation(im, rf, cf)

    in_rows = size(im,1);
    in_cols = size(im,2);
    out_rows = size(rf, 1);
    out_cols = size(rf, 2);
    
    %// Let r = floor(rf) and c = floor(cf)
    r = floor(rf);
    c = floor(cf);

    %// Any values out of range, cap
    r(r < 1) = 1;
    c(c < 1) = 1;
    r(r > in_rows - 1) = in_rows - 1;
    c(c > in_cols - 1) = in_cols - 1;

    %// Let delta_R = rf - r and delta_C = cf - c
    delta_R = rf - r;
    delta_C = cf - c;

    out = zeros(out_rows, out_cols, size(im, 3));
    out = cast(out, class(im));
    
    for idx = 1 : size(im, 3)
        for i=1:out_rows
            for j=1:out_cols
                out(i, j, idx)=im(r(i, j), c(i, j), idx)*(1-delta_R(i, j))*(1-delta_C(i, j)) + ...
                          im(r(i, j), c(i, j)+1, idx)*(delta_R(i, j))*(1-delta_C(i, j)) + ...
                          im(r(i, j)+1, c(i, j), idx)*(1-delta_R(i, j))*(delta_C(i, j)) + ...
                          im(r(i, j)+1, c(i, j)+1, idx)*(delta_R(i, j))*(delta_C(i, j));
            end
        end
    end
end

