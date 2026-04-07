
function [XM1,XM2,XMA,Anchor] = getXm(X,label)
%GETXM 此处显示有关此函数的摘要
%  对x进行超像素分割后对每个超像素内进行均值滤波 此处显示详细说明
%label:超像素标签
    data_col=X;
    [n,p]=size(data_col);
    XM1=zeros(n,p);
    XM2=zeros(n,p);
    XMA=zeros(n,p);
    %统计所取区域的类别及分布
    gt_col=label;
    gt_cla=unique(gt_col);
    gt_num = length(gt_cla);
    Anchor=zeros(gt_num,p);
   
    %%%%%%%%%%%%%%默认k=5
    gk_b = 7;
     clear X;


gamma0 = 0.5; % 你可以根据需要调整gamma0的值

for i = 1:gt_num
   % 获取当前超像素块的数据
        indix = find(gt_col == gt_cla(i));
        datai = data_col(indix, :);

        % 检查是否有大小为 0 的数据
        if isempty(datai)
            continue;  % 跳过大小为 0 的数据块
        end

        [ni, mi] = size(datai);

        % 均值滤波处理
         k = round(1/2 * ni);
   
        IDX = knnsearch(datai, datai, 'k', k);
        data_wmf = zeros(ni, mi);

    % for nk = 1:ni
    %     % 获取最近邻的数据点
    %     k = round(1/2 * ni); % 邻居点的个数
    %     IDX = knnsearch(datai, datai(nk, :), 'k', k);
    %     knndata = datai(IDX, :);
    % 
    %     % 计算权重 vk
    %     distances = vecnorm(datai(nk, :) - knndata, 2, 2).^2;
    %     weights = exp(-gamma0 * distances)';
    % 
    %     % 计算加权均值滤波
    %     weighted_sum = sum(weights' .* knndata, 1);
    %     normalization_factor = sum(weights);
    %     data_wmf(nk, :) =  weighted_sum / normalization_factor;
    % 
    % 
    % end
    

        for nk = 1:ni
            knndata = datai(IDX(nk, :), :);
            data_wmf(nk, :) = sum(knndata, 1) / k;
        end
        XM1(indix, :) = data_wmf;
    
        % 计算锚点 - 选择密度最高的点
        % 使用核密度估计计算每个点的密度
%         density = zeros(ni, 1);
%         for nk = 1:ni
%             knndata = datai(IDX(nk, :), :);
%             density(nk) = sum(sum((knndata - mean(knndata)).^2, 2));
%         end
%         [~, max_density_idx] = min(density);  % 寻找密度最低的点（密度峰值）
%     
%         Anchor(i, :) = datai(max_density_idx, :);  % 选取密度最高的点作为锚点
% 
% 

        % 计算锚点
           Anchor(i, :) = sum(datai, 1) / ni;






        % 图拉普拉斯正则化处理
        options.k = gk_b;
        SB = constructW(datai', options);
        B_bar = SB + speye(mi);
        d1 = sum(B_bar);
        d_sqrt1 = 1.0 ./ sqrt(d1);
        d_sqrt1(d_sqrt1 == Inf) = 0;
        DHB = diag(d_sqrt1);
        DHB = sparse(DHB);
        B_n = DHB * sparse(B_bar) * DHB;
        XM2(indix, :) = datai * B_n;

end

 
end

% 返回经过均值滤波和图拉普拉斯正则化处理后的数据 XM1 和 XM2，以及锚点 Anchor。



