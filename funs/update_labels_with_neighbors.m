function Yt1_updated = update_labels_with_neighbors(Yt1_reshaped, vote_matrix,num_classes)
    % Yt1_reshaped: 预测标签的二维数组 (H x W)
    % vote_matrix: 每个像素对应的投票矩阵 (N x 7)，其中 N = H * W
    % 返回值: Yt1_updated 是更新后的预测标签二维数组 (H x W)
    
    [H, W] = size(Yt1_reshaped);  % 获取二维数组的大小
    Yt1_updated = Yt1_reshaped;   % 初始化更新后的标签矩阵
    
    % 遍历每一个像素
    for i = 1:H
        for j = 1:W
            % 初始化当前像素的投票矩阵总和
            vote_sum = zeros(1, num_classes);
            
            % 遍历 3x3 邻域 (包括自己)，累加邻域的 vote_matrix
            for di = -1:1
                for dj = -1:1
                    % 检查邻域是否在图像边界内
                    if i+di > 0 && i+di <= H && j+dj > 0 && j+dj <= W
                        % 获取邻域像素在 vote_matrix 中的索引
                        idx = sub2ind([H, W], i+di, j+dj);
                        
                        % 累加邻域的投票矩阵
                        vote_sum = vote_sum + vote_matrix(idx, :);
                    end
                end
            end
            
            % 根据投票矩阵的和选择得票最多的标签
            [~, max_vote_label] = max(vote_sum);
            
            % 更新当前像素的标签
            Yt1_updated(i, j) = max_vote_label;
        end
    end
end

