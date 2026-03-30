% function W = initW(X,A,Z,r)
% view_num = get_viewnum;
% W = cell(1,view_num);
% for v = 1:view_num
%     W{v} = initW_detail(X{v},A{v},Z,r{v});
% end
% end
% 
% function newW = initW_detail(X,A,Z,r)
% St = X*X';
% H2 = X*Z*A';
% H3 = H2+H2';
% Q = St - H3 + A*diag(sum(Z))*A';
% Q = (Q+Q')/2;
% H = St\Q;
% W = eig1(H,r,0,0);
% W = real(W); % gpu环境下才要这句话
% newW = W*diag(1./sqrt(diag(W'*W)));
% end

function W = initW(X, A, Z, r)
% 初始化权重矩阵 W
% X: 输入数据
% A: 聚类中心
% Z: 隶属度矩阵
% r: 降维目标维数

% 单模态情况，直接调用 initW_detail
W = initW_detail(X, A, Z, r);
end

function newW = initW_detail(X, A, Z, r)
% 初始化权重矩阵的具体实现
St = X * X';  % 计算自相关矩阵
H2 = X * Z * A';  % 计算 H2
H3 = H2 + H2';  % 对称化 H2
Q = St - H3 + A * diag(sum(Z)) * A';  % 计算 Q
Q = (Q + Q') / 2;  % 确保 Q 对称
H = St \ Q;  % 解线性方程
W = eig1(H, r, 0, 0);  % 计算特征向量
W = real(W);  % 转换为实数（在 GPU 环境下需要）
newW = W * diag(1 ./ sqrt(diag(W' * W)));  % 归一化权重
end
