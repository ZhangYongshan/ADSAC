function [Z] = updateZ(X, anchor, k, W, beta)
%% 构建锚点图 Z，考虑正则化参数 beta
% 输入:
%       X: 数据矩阵, d by n
%       anchor: 锚点矩阵, d by m
%       k: 邻居数
%       W: 投影矩阵（可选）
%       beta: 正则化参数（beta=0 时退化为初始版本）
% 输出:
%       Z: 锚点图矩阵, n by m
%%
if nargin < 5
    beta = 0; % 默认 beta = 1
end
if nargin < 4
    [~, num] = size(X);
    [~, numAnchor] = size(anchor);
    % 初始化距离矩阵
    distX = pdist2(X', anchor').^2;  % 计算 X 和 anchor 之间的距离
else
    % 使用 W 变换 X 和 anchor
    [~, num] = size(W' * X);
    [~, numAnchor] = size(W' * anchor);
    distX = pdist2((W' * X)', (W' * anchor)') .^ 2;
end

Z = zeros(num, numAnchor);

% 找到每个点的 k+1 个最近邻
[~, idx] = sort(distX, 2);
id = idx(:, 1:k+1);
indices = sub2ind(size(distX), repmat((1:num)', [1, k+1]), id);
di = distX(indices);

% 根据 beta 的值选择计算方式
if beta == 0

    Z(indices) = (di(:, k+1) - di) ./ (k * di(:, k+1) - sum(di(:, 1:k), 2) + eps);
else
 
    for i = 1:num
        d_i = di(i, 1:k);      % 前 k 个最近邻的距离
        d_k1 = di(i, k+1);     % 第 k+1 个距离
        
        % 计算权重（分子和分母均加入 beta 的影响）
        numerator = d_k1 - d_i + (beta / k);
        denominator = k * d_k1 - sum(d_i) + beta;
        Z_i = numerator ./ denominator;
        
        % 强制非负并归一化
        Z_i(Z_i < 0) = 0;
        Z_i = Z_i / sum(Z_i);
        
        % 更新 Z 矩阵
        Z(i, id(i, 1:k)) = Z_i;
    end
end
end