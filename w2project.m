% Read image from folder
image = imread('keys_and_pens.jpeg');

% Size of image (4032x3024x3)
size(image);

% Resizing the image to 1/8 of the original
resized = imresize(image,1/8,'nearest');

% Cropping red pen from the resized color picture
pen = resized(80:100,40:290);

% Size of resized image, 1/8 of original (504x378x3)
size(resized);

% Red channel
red_channel = image(:,:,1);

% Resizing
red_resized = imresize(red_channel, 1/8, 'nearest');

% Cropping the upper part where is the red pen
red_pen = red_resized(80:100, 40:290);

% Amount of linear equations is 19*249=4731
% System matrix for the red channel (left side of the equation Ax=B)
[row0,col0]= size(red_pen);
row = row0-2;
col = col0-2;
A = FD_Laplace(row,col);

% Right side of the equation Ax=B
% code from Moodle, part of poisson.m, not my own implementation
% Borrowed code starts here
% Values for the edges
vec_t = red_pen(1,2:(end-1)); % Top
vec_b = red_pen(end,2:(end-1)); % bottom
vec_l = red_pen(2:(end-1),1); % left
vec_r = red_pen(2:(end-1),end); % right

% right side of equation
b = zeros(row*col,1);
for iii= 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii==1
            b(ind) = b(ind)+vec_t(jjj);
        end
        if iii==row
            b(ind) = b(ind)+vec_b(jjj);
        end
        if jjj==1
            b(ind) = b(ind)+vec_l(iii);
        end
        if jjj==col
            b(ind) = b(ind)+vec_r(iii);
        end     
    end
end
% Borrowed code ends here

% Calculating
% x = inv(A)*b; below is faster operator
x = A\b;
% x is a columnvector (pystyvektori)

% inpainted part
result = red_pen;
result(2:(end-1),2:(end-1)) = reshape(x, [row,col]);

% This shows the edited image where the red pen is removed
% Showing other color channels and images are commented out, but if
% intressed they can be removed
figure;
im2 = red_resized;
im2(80:100,40:290) = result;
imshow(im2)

% Original picture of the red channel
%figure;
%imshow(red_channel)


% Now same for the green channel (get channel, resize, crop, make a matrix)
green_channel = image(:,:,2);
green_resized = imresize(green_channel, 1/8, 'nearest');
red_pen_green = green_resized(80:100,40:290);
[row0, col0] = size(red_pen_green);
row = row0-2;
col = col0-2;
A = FD_Laplace(row,col);

% Right side of the equation Ax=B
% code from Moodle, part of poisson.m, not my own implementation
% Borrowed code starts here
% Values for the edges
vec_t = red_pen_green(1,2:(end-1)); % Top
vec_b = red_pen_green(end,2:(end-1)); % bottom
vec_l = red_pen_green(2:(end-1),1); % left
vec_r = red_pen_green(2:(end-1),end); % right

% right side of equation
b = zeros(row*col,1);
for iii= 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii==1
            b(ind) = b(ind)+vec_t(jjj);
        end
        if iii==row
            b(ind) = b(ind)+vec_b(jjj);
        end
        if jjj==1
            b(ind) = b(ind)+vec_l(iii);
        end
        if jjj==col
            b(ind) = b(ind)+vec_r(iii);
        end     
    end
end
% Borrowed code ends here

x = A\b;
result2 = red_pen_green;
result2(2:(end-1),2:(end-1)) = reshape(x, [row,col]);

% This shows the edited image where the red pen is removed in green channel
%figure;
imgreen = green_resized;
imgreen(80:100,40:290) = result2;
%imshow(imgreen)

% Original picture of the green channel
%figure;
%imshow(green_channel)


% Same for the blue channel as to the other channels
blue_channel = image(:,:,3);
blue_resized = imresize(blue_channel, 1/8, 'nearest');
red_pen_blue = blue_resized(80:100,40:290);
[row0, col0] = size(red_pen_blue);
row = row0-2;
col = col0-2;
A = FD_Laplace(row,col);

% Right side of the equation Ax=B
% code from Moodle, part of poisson.m, not my own implementation
% Borrowed code starts from here
% Values for the edges
vec_t = red_pen_blue(1,2:(end-1)); % Top
vec_b = red_pen_blue(end,2:(end-1)); % bottom
vec_l = red_pen_blue(2:(end-1),1); % left
vec_r = red_pen_blue(2:(end-1),end); % right

% right side of equation
b = zeros(row*col,1);
for iii= 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii==1
            b(ind) = b(ind)+vec_t(jjj);
        end
        if iii==row
            b(ind) = b(ind)+vec_b(jjj);
        end
        if jjj==1
            b(ind) = b(ind)+vec_l(iii);
        end
        if jjj==col
            b(ind) = b(ind)+vec_r(iii);
        end     
    end
end
% Borrowed code ends here

x = A\b;
result3 = red_pen_blue;
result3(2:(end-1),2:(end-1)) = reshape(x, [row,col]);

% This shows the edited image where the red pen is removed in blue channel
% figure;
imblue = blue_resized;
imblue(80:100,40:290) = result3;
% imshow(imblue)

% Original picture of the blue channel
% figure;
% imshow(blue_channel)

%figure;
resized(80:100,40:290,1) = result;
resized(80:100,40:290,2) = result2;
resized(80:100,40:290,3) = result3;
imshow(resized)

% Writing images
% First is the colored image where the red pen is removed
imwrite(resized, 'edited.jpg')
% Then the red channel image where the pen is removed
imwrite(im2, 'edited_red.jpg')

% Copied code from the Moodle page.
% Code and comments under this is not implemented by me.

% Construct an FD matrix approximating the 2D
% Laplace operator with the infamous "five-point stencil."
% We assume that the difference h=1;
%
% Samuli Siltanen Dec 2015

function A = FD_Laplace(row,col)

% Initialize the result

A = 4*speye(row*col);

% Loop over the rows of A

for iii = 1:row
    for jjj = 1:col
        ind = (jjj-1)*row+iii;
        if iii>1
            A(ind,ind-1) = -1;
        end
        if iii<row
            A(ind,ind+1) = -1;
        end
        if jjj>1
            A(ind,ind-row) = -1;
        end
        if jjj<col
            A(ind,ind+row) = -1;
        end
    end
    if mod(iii,round(row/10))==0
        disp([iii row])
    end
end

end