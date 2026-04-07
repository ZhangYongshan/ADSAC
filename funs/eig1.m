%% 计算拉普拉斯矩阵A的前c个特征值以及对应的特征向量
% 输入：
%       A - 拉普拉斯矩阵
%       c - 聚类数目
%       isMax - 0:将特征值由小到大排序 1:将特征值由大到小排序
%       isSym
%
%输出：
%       eigvec - 前c个特征向量
%       eigval - 前c个特征值
%       eigval_full - 所有特征值（已排序）
%
function [eigvec, eigval, eigval_full] = eig1(A, c, isMax, isSym)
%% 判断参数
if nargin < 2
    c = size(A,1);
    isMax = 1;
    isSym = 1;
elseif c > size(A,1)
    c = size(A,1);
end

if nargin < 3
    isMax = 1;
    isSym = 1;
end

if nargin < 4
    isSym = 1;
end

if isSym == 1
    A = max(A,A'); % 返回从 A 或 A' 中提取的最大元素的数组。
end

%% 计算特征值和特征向量
[v,d] = eig(A); % 计算 A 的特征值（对角矩阵）和右特征向量（矩阵）。
d = diag(d);  % 获得矩阵d的对角线元素，即A的特征值
%d = real(d);
% 排序
if isMax == 0
    [d1, idx] = sort(d); % 对特征值由小到大排序
else
    [d1, idx] = sort(d,'descend'); % 对特征值由大到小排序
end;
% 取前c个
idx1 = idx(1:c); % 前c个下标
eigval = d(idx1); % 前c个特征值
eigvec = v(:,idx1); % 前c个特征向量 num * c

eigval_full = d(idx); %% 排序之后的所有特征值