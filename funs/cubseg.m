function labels = cubseg(data,cc)

[M,N,B]=size(data);
Y_scale=scaleForSVM(reshape(data,M*N,B));
p = 1;
[Y_pca] = pca(Y_scale, p);
img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));
K=cc;

labels = superpixels(double(img),K);
labels = labels + 1; % Because the first segmentation label is zero.

end
% function [labels,vu] = cubseg(indian_pines,cc,gt)%这段代码的目的是对给定的高光谱图像 indian_pines 进行分割，并返回分割后的标签。它使用了边缘检测、PCA 降维、超级像素分割等方法。
% %这是函数的定义，其中 indian_pines 是输入的高光谱图像数据，cc 是期望的超级像素数量。
% [M,N,B]=size(indian_pines);%获取输入图像的尺寸，M 和 N 是图像的高度和宽度，B 是光谱通道数。
% Y_scale=scaleForSVM(reshape(indian_pines,M*N,B));%将高光谱图像数据重塑为二维矩阵，并进行归一化，然后再重塑回三维矩阵。scaleForSVM 是假设的一个预处理函数
% % Y_scale = reshape(indian_pines,M*N,B);
% Y=reshape(Y_scale,M,N,B);
% p = 1;
% [Y_pca] = pca(Y_scale, p);%对归一化后的数据进行PCA降维，降到1维。
% % Y_pca = mean(Y_scale,2);
% img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));%将PCA降维后的数据重塑为二维图像，并进行归一化和类型转换，以便后续处理。
% 
% [Ratio]=Edge_ratio3(img);%调用 Edge_ratio3 函数计算图像的边缘比率。
% 
% % sigma=0.05;
% K=cc;
% grey_img = im2uint8(mat2gray(Y(:,:,30)));
% labels = superpixels(double(img),K);%设置超级像素数量 K，将第30个光谱通道转换为灰度图，并使用 mex_ers 函数进行超级像素分割，得到分割标签。
% 
% 
%   % 计算每个超级像素块的中心位置
%     stats = regionprops(labels, 'Centroid');
%     vu = cat(1, stats.Centroid); % 将中心坐标存储在 vu 矩阵中
% vu = vu(:, [2, 1]); % 交换第一列和第二列
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%
% 
% 
% [height width] = size(grey_img);
% [bmap] = seg2bmap(labels,width,height);
% 
% 
% %%%%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%
% 
% 
% % bmapOnImg = img;
% % idx = find(bmap>0);
% % timg = grey_img;
% % timg(idx) = 255;
% % bmapOnImg(:,:,2) = timg;
% % bmapOnImg(:,:,1) = grey_img;
% % bmapOnImg(:,:,3) = grey_img;%生成分割边界图，并将其叠加到灰度图上。
% % 
% % figure;
% % imshow(bmapOnImg,[]);
% % imwrite(grey_img,'bmapOnImg.bmp')
% % title('superpixel boundary map');
% %   % 保存图像
% %     imwrite(bmapOnImg, 'bmapOnImg.bmp');
% end

function [Ratio]=Edge_ratio3(img)%这是辅助函数 Edge_ratio3 的定义。它对输入图像进行边缘检测，计算边缘像素数与总像素数的比率。
 [m,n] = size(img);
%  img =  rgb2gray(img);
 BW = edge(img,'log');
%  figure,imshow(BW)
 ind = find(BW~=0);
 Len = length(ind);
 Ratio = Len/(m*n);
end
% 
% function [labels, vu] = cubseg(indian_pines, cc, gt)
%     % 读取输入图像的尺寸
%     [M, N, B] = size(indian_pines);
% gt=gt;
%     % 进行数据归一化处理
%     Y_scale = scaleForSVM(reshape(indian_pines, M*N, B));
%     Y = reshape(Y_scale, M, N, B);
% 
%     % PCA降维
%     p = 1;
%     [Y_pca] = pca(Y_scale, p);
% 
%     % PCA结果归一化处理
%     img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));
% 
%     % 超级像素分割
%     K = cc;
%     grey_img = im2uint8(mat2gray(Y(:,:,30)));
%     labels = superpixels(double(img), K);
% 
%     % 计算每个超级像素块的中心位置
%     stats = regionprops(labels, 'Centroid');
%     vu = cat(1, stats.Centroid);
%     vu = vu(:, [2, 1]); % 交换第一列和第二列
% 
%     % 生成分割边界图
%     [height, width] = size(grey_img);
%     [bmap] = seg2bmap(labels, width, height);
% 
%     % 创建全白背景图像
%     boundary_img = uint8(255 * ones(height, width, 3)); % 白色背景
% 
%     % 将边界线设置为黑色
%     boundary_img(repmat(bmap > 0, [1, 1, 3])) = 0; % 黑色边界
% 
%     % 将 gt 为非0元素位置的像素标记为红色
%     red_mask = gt > 0;
%     boundary_img(:,:,1) = max(boundary_img(:,:,1), uint8(red_mask) * 255); % 红色通道
%     boundary_img(:,:,2) = min(boundary_img(:,:,2), uint8(~red_mask) * 255); % 绿色通道
%     boundary_img(:,:,3) = min(boundary_img(:,:,3), uint8(~red_mask) * 255); % 蓝色通道
% 
%     % 显示边界图
%     figure;
%     imshow(boundary_img, []);
%     title('Superpixel Boundary Map with Red Highlights for gt Non-zero Elements');
% end
% 
% function [Ratio] = Edge_ratio3(img)
%     % 边缘检测并计算边缘像素比率
%     [m, n] = size(img);
%     BW = edge(img, 'log');
%     ind = find(BW ~= 0);
%     Len = length(ind);
%     Ratio = Len / (m * n);
% end
