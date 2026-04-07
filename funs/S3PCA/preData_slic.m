function [X, labels] = preData_slic(data3D, num_Pixel)
%% HSI data preprocessing (SLIC superpixel segmentation)
% Input:
%   data3D:    3D cube, HSI data.
%   num_Pixel: number of desired superpixels
% Output:
%   X:      2D matrix, each column is a pixel
%   labels: superpixel labels

data = data3D;  % 单模态情况下直接使用 data3D

X = data3D; 
[M, N, B] = size(data);  % M, N: 空间尺寸; B: 光谱通道数

% ---------- Step 1: 归一化 ----------
Y_scale = scaleForSVM(reshape(data, M*N, B));  % 每个光谱维度归一化
Y = reshape(Y_scale, M, N, B);

% ---------- Step 2: PCA降维到1维 (用于生成灰度图做分割) ----------
p = 1;
[Y_pca] = pca(Y_scale, p);
img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));

% ---------- Step 3: SLIC 超像素分割 ----------
% MATLAB 自带函数 superpixels
% num_Pixel 表示希望生成的超像素数量
[labels, ~] = superpixels(img, num_Pixel, 'Compactness', 10);

labels = double(labels);   % 转换为 double
labels = labels + 1;       % 确保从 1 开始

% ---------- Step 4: 输出数据 ----------
X = reshape(X, M * N, B);  % 重塑为二维矩阵
X = X';                    % 转置：列为像素

end
