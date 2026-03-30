function [Zs, Zt, As, At,Yt1 ] = upDISA(Xs, Xt, Ys, Yt0, options,Xt1)
num= options.num;
alpha2 = options.alpha2;

gama=options.gama;


mu2 = options.mu2;
m = size(Xs,1);
ns = size(Xs,2);
nt = size(Xt,2);
class = unique(Ys);
C = length(class);

  %%%%%%%%%计算类内散度矩阵sw和类间散度矩阵sb%%%%


        [Ms, Mt, Mst, Mts] = constructMMD(ns,nt,Ys,Yt0,C);
        Ts = Xs*Ms*Xs';
        Tt = Xt*Mt*Xt';
        Tst = Xs*Mst*Xt';
        Tts = Xt*Mts*Xs';

        Hs = eye(ns)-1/(ns)*ones(ns,ns);
        Ht = eye(nt)-1/(nt)*ones(nt,nt);

        X = [zeros(m,ns) zeros(m,nt); zeros(m,ns) Xt];    
        H = [zeros(ns,ns) zeros(ns,nt); zeros(nt,ns) Ht];%baraye inke aabad kone

Wt = constructW(Xt');
DCol = full(sum(Wt,2));%WT1
Dt = spdiags(DCol,0,speye(size(Wt,1)));
Lt = Dt - Wt;

e1 = double((Ys == Ys')); 
e2 = 1 - e1;
e2(1:ns+1:end) = 1;  % 设置对角线元素为 1
DCol = full(sum(e1,2));%WT1
Dt = spdiags(DCol,0,speye(size(e1,1)));
L1 = (Dt - e1);
DCol = full(sum(e2,2));%WT1
Dt = spdiags(DCol,0,speye(size(e2,1)));
L2 = (Dt - e2);

l1=nchoosek(num, 2)*C;
l2=nchoosek(C, 2)*num*num;
ps2=10000*Xs*L2*Xs'/l2;
ps1=10000*Xs*L1*Xs'/l1;
P1=zeros(2*m,2*m);
P1(1:m,1:m)=ps2;

pt1=Xt*Lt*Xt';
P2=X*H*X';

         Smax = 0.5*P2+mu2*P1;
         Smin = [gama*Ts+mu2*ps1, gama*Tst ; ...
               gama*Tts,  gama*Tt+0.5*eye(m)+alpha2*pt1];

            [W,~] = eigs(Smax, Smin+1e-1*eye(2*m), 20, 'LM');

        As = W(1:m, :);
        At = W(m+1:end, :); 

        Zs = As'*Xs;

        Zt = At'*Xt;
        Zt1 = At'*Xt1;

    Mdl = fitcknn(Zs', Ys, 'NumNeighbors', 10);
    
    % 对目标数据进行预测
    Yt1 = predict(Mdl, Zt1');


end
