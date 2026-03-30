function [X_temp] = findConstruct(X,index,k)
    if index==0
        index=X;
    end
    if k>=size(X,1)
        k=size(X,1)-1;
    end
    [n,m] = size(X);
    X_temp = zeros(n,m);
    [~,idx2] = pdist2(index, index, 'euclidean','Smallest',k+1);
    idx2 = idx2';
    
    for i=1:n
        temp_x = X(idx2(i,:),:);
        X_temp(i,:) = mean(temp_x);

    end
end