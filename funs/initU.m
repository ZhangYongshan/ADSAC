% function U  = initU(cluster_n, data_n)
% rng(10); 
% U = rand(cluster_n, data_n);
% col_sum = sum(U);
% U = U./col_sum(ones(cluster_n, 1), :);
% end
% 
function U = initU(cluster_n, data_n)
% 初始化模糊隶属度矩阵 U
% cluster_n: 聚类数量
% data_n: 数据点数量

rng('default')   % 设置随机种子
U = rand(cluster_n, data_n);  % 生成随机矩阵
col_sum = sum(U);  % 计算每列的和
U = U ./ col_sum(ones(cluster_n, 1), :);  % 归一化，使每列的和为 1
end
