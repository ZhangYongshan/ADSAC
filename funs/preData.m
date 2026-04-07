
function [X, labels] = preData(data3D, num_Pixel)
%% HSI data preprocessing
% Input:
%       data3D: 3D cube, HSI data.
% Output:
%       X:      new data, 2D matrix. each column is a pixel labels:
%       superpixel labels num_Pixel: the number of superpixel
data = data3D;  % 单模态情况下直接使用 data3D

X = data3D; 
[M,N,B]=size(data );%获取输入图像的尺寸，M 和 N 是图像的高度和宽度，B 是光谱通道数。
Y_scale=scaleForSVM(reshape(data,M*N,B));%将高光谱图像数据重塑为二维矩阵，并进行归一化，然后再重塑回三维矩阵。scaleForSVM 是假设的一个预处理函数
Y=reshape(Y_scale,M,N,B);
p = 1;
[Y_pca] = pca(Y_scale, p);%对归一化后的数据进行PCA降维，降到1维。
img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));%将PCA降维后的数据重塑为二维图像，并进行归一化和类型转换，以便后续处理。
% ERS super-pixel segmentation.
labels = mex_ers(double(img), num_Pixel);

labels = labels + 1;  % 调整标签，使其从1开始

X = reshape(X, M * N, B);  % 重塑数据
% 
X = X';  % 转置以适应输出格式

end
