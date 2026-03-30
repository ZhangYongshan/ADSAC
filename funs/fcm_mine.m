
function [U_new,  S] = fcm_mine( W, A, cluster_n)

data_matrix=W'*A;

idx = kmeans(data_matrix', cluster_n, 'Replicates', 5);  % 进行 k-means 聚类，'Replicates' 用于指定初始聚类中心的重复次
% S=W*S';
    % 初始化聚类中心矩阵S
    S = zeros(cluster_n, size(A, 1));  % 聚类中心矩阵，大小为 (cluster_n x 特征数)
    
    % 对于每个簇，计算聚类中心（即该簇所有样本点的均值）
    for k = 1:cluster_n
        cluster_points = A(:, idx == k);  % 获取第k个簇的所有样本
        S(k, :) = mean(cluster_points, 2);  % 计算该簇样本点的均值，作为聚类中心
    end
% 更新U_new为硬隶属度矩阵
S=S';
U_new = sparse(idx, 1:length(idx), 1, cluster_n, length(idx));
U_new = full(U_new);  % 转换为密集矩阵
end



