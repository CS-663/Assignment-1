function [out] = myBicubicInterpolation(im,out_dims)
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


    out = zeros(out_rows, out_cols, size(im, 3));
    out = cast(out, class(im));
    
    for channel = 1:size(im,3)
        for i=1:out_rows
            for j=1:out_cols
                A = [];
                A = [A; p(r(i,j),c(i,j))];
                A = [A; p(r(i,j),c(i,j) + 1)];
                A = [A; p(r(i,j) + 1,c(i,j))];
                A = [A; p(r(i,j) + 1,c(i,j) + 1)];
                
                A = [A; pdx(r(i,j),c(i,j))];
                A = [A; pdx(r(i,j),c(i,j) + 1)];
                A = [A; pdx(r(i,j) + 1,c(i,j))];
                A = [A; pdx(r(i,j) + 1,c(i,j) + 1)];
                
                A = [A; pdy(r(i,j),c(i,j))];
                A = [A; pdy(r(i,j),c(i,j) + 1)];
                A = [A; pdy(r(i,j) + 1,c(i,j))];
                A = [A; pdy(r(i,j) + 1,c(i,j) + 1)];
                
                A = [A; pdxy(r(i,j),c(i,j))];
                A = [A; pdxy(r(i,j),c(i,j) + 1)];
                A = [A; pdxy(r(i,j) + 1,c(i,j))];
                A = [A; pdxy(r(i,j) + 1,c(i,j) + 1)];
                
                b = [im(r(i,j),c(i,j),channel);
                     im(r(i,j),c(i,j) + 1,channel);
                     im(r(i,j) + 1,c(i,j),channel);
                     im(r(i,j) + 1,c(i,j) + 1,channel);
                     finDiffx(r(i,j),c(i,j),im,channel);
                     finDiffx(r(i,j),c(i,j) + 1,im,channel);
                     finDiffx(r(i,j) + 1,c(i,j),im,channel);
                     finDiffx(r(i,j) + 1,c(i,j) + 1,im,channel);
                     finDiffy(r(i,j),c(i,j),im,channel);
                     finDiffy(r(i,j),c(i,j) + 1,im,channel);
                     finDiffy(r(i,j) + 1,c(i,j),im,channel);
                     finDiffy(r(i,j) + 1,c(i,j) + 1,im,channel);
                     finDiffxy(r(i,j),c(i,j),im,channel);
                     finDiffxy(r(i,j),c(i,j) + 1,im,channel);
                     finDiffxy(r(i,j) + 1,c(i,j),im,channel);
                     finDiffxy(r(i,j) + 1,c(i,j) + 1,im,channel)]  ;
                   
                 x = linsolve(A,b);
                 
                 out(i, j, channel) = p(rf(i,j),cf(i,j)) * x;
            end
        end
    end
end

function [P] = p(x, y)
    P=[];
   for i=1:4
       for j=1:4
           P = [P, (x^(i-1))*(y^(j-1))];
       end
   end
end

function [Px] = pdx(x, y)
   Px=[];
   for i=1:4
       for j=1:4
           Px = [Px, ((i-1)*x^(i-2))*(y^(j-1))];
       end
   end
end

function [Py] = pdy(x, y)
   Py=[];
   for i=1:4
       for j=1:4
           Py = [Py, (x^(i-1))*(j-1)*(y^(j-2))];
       end
   end
end

function [Pxy] = pdxy(x, y)
   Pxy=[];
   for i=1:4
       for j=1:4
           Pxy = [Pxy, (i-1)*(x^(i-2))*(j-1)*(y^(j-2))];
       end
   end
end

function [intensity_x] = finDiffx(x,y,im,channel)
    if x==1 | y==1 | x==size(im,1) | y==size(im,2)
        intensity_x = im(x,y,channel);
    else
        intensity_x = 0.5 * (im(x+1,y,channel) - im(x-1,y,channel));
    end
end

function [intensity_y] = finDiffy(x,y,im,channel)
    if x==1 | y==1 | x==size(im,1) | y==size(im,2)
        intensity_y = im(x,y,channel);
    else
        intensity_y = 0.5 * (im(x,y+1,channel) -im(x,y-1,channel));
    end
end
function [intensity_xy] = finDiffxy(x,y,im,channel)
    if x==1 | y==1 | x==size(im,1) | y==size(im,2)
        intensity_xy = im(x,y,channel);
    else
        intensity_xy = 0.25 * ((im(x+1,y+1,channel) + im(x-1,y-1,channel)) - (im(x-1,y+1,channel) + im(x+1,y-1,channel)));
    end
end