
% Ruaa Manasrah
% Bilal Hoor
% Waad Makhamrah
path = 'C:\Users\Bilal\Desktop\PCA Project\';
dinfo = dir(path+"*.pgm");
size_dinfo = size(dinfo);
number_of_images = size_dinfo(1);
db_names = {dinfo.name};

images = [];
for i = 1: number_of_images
  full_img_path = fullfile(path, dinfo(i).name);
  img = imread(full_img_path);
  images = [ images, img(:)];
end
%Normalization
images = double(images);
means = sum(images, 2)/number_of_images; 
%stds = std(images,0,2);
normalized_images = images - double(means); 
normalized_images = normalized_images.';

%Covriance Matrix %cov(normalized_images')
[V2,D2] = eig(normalized_images * normalized_images');
V = normalized_images' * V2 * inv(D2^0.5);
V = real(V);

D2=diag(sort(diag(D2),'descend')); % make diagonal matrix out of sorted diagonal values of input D
[c, ind]=sort(diag(D2),'descend'); % store the indices of which columns the sorted eigenvalues come from
V3=V(:,ind); % arrange the columns in this order
%trunc_V3= V3(:,1:90);

%Projected / Transformed Data
X_projected = normalized_images * V3; 

%TEST 
test_img = imread('testdata/subject07.wink.pgm');
test_img_normalized = double(test_img(:)) - means;
transformed_v_test = test_img_normalized'*V3;
dif = abs(transformed_v_test - X_projected);
sum_dif = sum(dif, 2);
[M,I] = min(sum_dif);
name_ = db_names(I)
name_ = cell2mat(name_);

%plotting images
subplot(121)
imshow(test_img);
title('Tested Face');
subplot(122)
full_img_path_ = fullfile(path, name_);
Im2 = imread(full_img_path_);
imshow(Im2);
title('Recognized Face');

