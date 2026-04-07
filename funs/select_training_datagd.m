function [train_data, train_labels] = select_training_datagd(data3D, predict_label, num_points)
    % 获取数据的尺寸

    % 找到唯一的聚类标签
    unique_labels = unique(predict_label);  % 获取所有唯一标签

    % 初始化训练数据和标签
    train_data = [];
    train_labels = [];
    
    % 遍历每个聚类
    for i = 1:length(unique_labels)
        cluster_label = unique_labels(i);

        % 找到当前聚类的所有数据点
        cluster_indices = find(predict_label == cluster_label);
        cluster_data = data3D(cluster_indices, :);

        % 如果数据点少于num_points，直接使用所有数据点
        if length(cluster_indices) <= num_points
            selected_data = cluster_data;
            selected_labels = repmat(cluster_label, size(cluster_data, 1), 1);
        else
            % 确定步长，固定地从每个聚类中选取num_points个数据点
            step = floor(length(cluster_indices) / num_points);
            selected_indices = cluster_indices(1:step:end);  % 每隔step个点选择一个
            
            % 确保选出的数量满足num_points
            if length(selected_indices) > num_points
                selected_indices = selected_indices(1:num_points);  % 如果超过num_points，截取前num_points个
            elseif length(selected_indices) < num_points
                % 如果少于num_points，重复选择直到满足
                selected_indices = repmat(selected_indices, 1, ceil(num_points / length(selected_indices)));
                selected_indices = selected_indices(1:num_points);
            end
            
            % 获取选中的数据
            selected_data = data3D(selected_indices, :);
            selected_labels = repmat(cluster_label, num_points, 1);
        end

        % 添加到训练数据和标签中
        train_data = [train_data; selected_data];
        train_labels = [train_labels; selected_labels];
    end
end

