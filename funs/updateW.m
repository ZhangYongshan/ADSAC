
function newW = updateW(X, A, Z, U, S,  alpha, r)
% 更新 W 详细过程
  
St = X * X';  % 计算自相关矩阵
H2 = X * Z * A';  % 计算 H2
H3 = H2 + H2';  % 对称化 H2
P = St - H3 + A * diag(sum(Z)) * A';  % 计算 P
P = (P + P') / 2;  % 确保 P 对称


Q1 = A * U * S';  % 计算 Q1
Q2 = Q1 + Q1';  % 对称化 Q1
Q = A * diag(sum(U, 2)) * A' - Q2 + S * diag(sum(U)) * S';  % 计算 Q
Q = (Q + Q') / 2;  % 确保 Q 对称
Q = Q * alpha;  % 正则化 Q

T = P + Q;  % 合并 P 和 Q
T = (T + T') / 2;  % 确保 T 对称
H = St \ T;  % 解决特征值问题

W = eig1(H, r, 0, 0);  % 计算特征值
W = real(W);  % 确保 W 为实数
newW = W * diag(1 ./ sqrt(diag(W' * W)));  % 归一化

end
