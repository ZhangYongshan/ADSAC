% function [A] = initA(X, spLabel, m)
% view_num = get_viewnum;
% A = cell(1,view_num);
% for v = 1:view_num
%     A{v} = initA_detail(X{v}, spLabel,m);
% end
% end
% 
% function [means] = initA_detail(X, label, m)
% % X: d by n label表示每个像素属于哪一个超像素
% Class = unique(label);
% 
% means = zeros(size(X,1), m);
% for i=1:length(Class)
%     sub_idx = (label==Class(i));
%     means(:,i) = mean(X(:,sub_idx),2);
% end
% means(isnan(means)) = 0;
% end

function [means] = initA(X, label, m)
% X: d by n, label 表示每个像素属于哪一个超像素
Class = unique(label);

means = zeros(size(X, 1), m);
for i = 1:length(Class)
    sub_idx = (label == Class(i));
    means(:, i) = mean(X(:, sub_idx), 2);
end
means(isnan(means)) = 0;
end
