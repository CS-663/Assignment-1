function [out] = myImageResize(im,out_dims)
    
    in_rows = size(im,1);
    in_cols = size(im,2);
    out_rows = out_dims(1);
    out_cols = out_dims(2);

        
    S_R = in_rows / out_rows;
    S_C = in_cols / out_cols;

%     S_R = (in_rows - 1) / (out_rows - 1);
%     S_C = (in_cols - 1) / (out_cols - 1);
 

    %// Define grid of co-ordinates in our image
    %// Generate (x,y) pairs for each point in our image
    [cf, rf] = meshgrid(1 : out_cols, 1 : out_rows);

%     [cf, rf] = meshgrid(1 : S_C : out_cols, 1 : S_R : out_rows);

    %// Let r_f = r'*S_R for r = 1,...,R'
    %// Let c_f = c'*S_C for c = 1,...,C'
    rf = rf * S_R;
    cf = cf * S_C;
    
    out = myBilinearInterpolation(im,rf,cf);
end
    

