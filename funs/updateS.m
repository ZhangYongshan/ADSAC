function [S] = updateS(A, U)
% 更新中心矩阵 S
% A: 中心矩阵
% U: 模糊隶属度矩阵

% 直接处理单一视角数据
S = A{1} * U / diag(sum(U));  % 计算 S

end
