function [y_pred, pred_len] = main(X, spLabel, m, cluster_n, r, iter_num,alpha,k1,beta)

k =k1;  % 邻居数

A = initA(X, spLabel, m);
Z = updateZ(X, A, k);
W = initW(X, A, Z, r);
U = initU(cluster_n, m);  % c*m


for iter1 = 1:iter_num  
    Z = updateZ(X, A, k, W,beta);   
    [U,  S] = fcm_mine(W, A,cluster_n);
    W = updateW(X, A, Z, U', S,  alpha, r);
    A = updateA(X, Z, S, U',alpha); 
end

F = Z * U';
[~, y_pred] = max(F, [], 2);
pred_len = length(unique(y_pred));
end
