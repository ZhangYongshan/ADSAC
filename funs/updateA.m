
function [A] = updateA(X, Z, S, U, alpha)

A = cell(1, 1);  % 只需要一个视角
A1 =alpha  * S * U' +  X * Z;  
A2 = diag(sum(Z)) +alpha *   diag(sum(U, 2));  
A2 = (A2 + A2') / 2;  % 确保 A2 对称
A = A1 / A2;  % 更新 A

end
