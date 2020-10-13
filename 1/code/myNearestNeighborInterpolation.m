function [out] = myNearestNeighborInterpolation(im,out_dims)
    %// Get some necessary variables first
    in_rows = size(im,1);
    in_cols = size(im,2);
    out_rows = out_dims(1);
    out_cols = out_dims(2);

    %// Let S_R = R / R'        
    S_R = in_rows / out_rows;
    %// Let S_C = C / C'
    S_C = in_cols / out_cols;

    %// Define grid of co-ordinates in our image
    %// Generate (x,y) pairs for each point in our image
    [cf, rf] = meshgrid(1 : out_cols, 1 : out_rows);

    %// Let r_f = r'*S_R for r = 1,...,R'
    %// Let c_f = c'*S_C for c = 1,...,C'
    rf = rf * S_R;
    cf = cf * S_C;

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
    
    index_min=0;
    
    for idx = 1 : size(im, 3)
        for i=1:out_rows
            for j=1:out_cols
                d1 = sqrt(delta_R(i,j)^2 + delta_C(i,j)^2);
                d2 = sqrt((1-delta_R(i,j))^2 + delta_C(i,j)^2);
                d3 = sqrt(delta_R(i,j)^2 + (1-delta_C(i,j))^2);
                d4 = sqrt((1-delta_R(i,j))^2 + (1-delta_C(i,j))^2);
                dist = [d1 d2 d3 d4];
                for k=1:4
                    if dist(k) == min(dist)
                        index_min=k;
                        break;
                    end
                end
                switch index_min
                    case 1
                        out(i, j, idx) = im(r(i,j),c(i,j),idx);
                    case 2
                        out(i, j, idx) = im(r(i,j),c(i,j) + 1,idx);
                    case 3
                        out(i, j, idx) = im(r(i,j) + 1,c(i,j),idx);
                    case 4
                        out(i, j, idx) = im(r(i,j) + 1,c(i,j) + 1,idx);
                end
                
            end
        end
    end
end

