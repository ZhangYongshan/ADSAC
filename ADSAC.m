clear; close all; clc;

%% ===================== 路径设置 =====================
addpath(genpath('funs'));
addpath('.\cross-scene-dataset');

%% ===================== 数据集参数配置 =====================
dataType = 'Loukia'; % 可选: 'PaviaU' | 'PaviaC' | 'Houston13' | 'Houston18' | 'Dioni' | 'Loukia'

switch dataType

    case 'PaviaU'
        load paviaU_7gt;    gt2D   = map;
        load paviaU;        data3D = ori_data;  data_s = data3D;
        load paviaC;        data_t = ori_data;
        load paviaC_7gt;    gt_t   = map;

        gt_t = gt_t(:);
        [H, W, D] = size(data_t);
        projDim        = 51;
        iter           = 5;
        k1             = 32;
        alpha          = 1;
        options.alpha2 = 0.01;
        options.num    = 100;
        options.gama   = 0.02;
        options.mu2    = 0.00001;

    case 'PaviaC'
        load paviaC_7gt;    gt2D   = map;
        load paviaC;        data3D = ori_data;  data_s = data3D;
        load paviaU;        data_t = ori_data;
        load paviaU_7gt;    gt_t   = map;

        gt_t = gt_t(:);
        [H, W, D] = size(data_t);
        projDim        = 34;
        iter           = 10;
        k1             = 32;
        alpha          = 0.8;
        options.num    = 120;
        options.gama   = 0.02;
        options.mu2    = 0.01;
        options.alpha2 = 0.1;
          case 'Houston13'
        load Houston13_7gt;     gt2D   = map;
        load Houston13;         data3D = ori_data;  data_s = data3D;
        load Houston18_7gt.mat; gt_t   = map;
        load Houston18.mat;     data_t = ori_data;

        gt_t = gt_t(:);
        [H, W, D] = size(data_t);
        projDim        = 24;
        iter           = 15;
        k1             = 32;
        alpha          = 1;
        options.alpha2 = 1;
        options.num    = 160;
        options.gama   = 0.02;
        options.mu2    = 1;

    case 'Houston18'
        load Houston18_7gt;     gt2D   = map;
        load Houston18;         data3D = ori_data;  data_s = data3D;
        load Houston13_7gt.mat; gt_t   = map;
        load Houston13.mat;     data_t = ori_data;

        gt_t = gt_t(:);
        [H, W, D] = size(data_t);
        projDim        = 40;
        iter           = 5;
        k1             = 15;
        alpha          = 1.3;
        options.mu2    = 1;
        options.num    = 100;
        options.gama   = 0.04;
        options.alpha2 = 1;
       
    case 'Dioni'
        load Dioni_gt_out68;    gt2D   = map;
        load Dioni;             data3D = ori_data;  data_s = data3D;
        load Loukia.mat;        data_t = ori_data;
        load Loukia_gt_out68.mat; gt_t = map;

        gt_t = gt_t(:);
        [H, W, D] = size(data_t);
        projDim        = 60;
        iter           = 10;
        k1             = 5;
        alpha          = 1;
        options.alpha2 = 0.1;
        options.num    = 180;
        options.gama   = 0.05;
        options.mu2    = 1;

    case 'Loukia'
        load Loukia_gt_out68;   gt2D   = map;
        load Loukia;            data3D = ori_data;  data_s = data3D;
        load Dioni.mat;         data_t = ori_data;
        load Dioni_gt_out68.mat; gt_t  = map;

        gt_t = gt_t(:);
        [H, W, D] = size(data_t);
        projDim        = 60;
        iter           = 5;
        k1             = 5;
        alpha          = 1.3;
        options.alpha2 = 1;
        options.num    = 120;
        options.gama   = 0.04;
        options.mu2    = 0.1;
end

%% ===================== 源域聚类 =====================
beta = 0;

gt    = double(gt2D(:));
ind   = find(gt);
c     = length(unique(gt(ind)));

tic;
[X, spLabel]          = preData(data3D, 300);
[y_pred, pred_length] = main(X, spLabel(:), 300, c, projDim, iter, alpha, k1, beta);
num_classes           = length(unique(y_pred));
time = toc;

%% ===================== 目标域超像素分割与锚点提取 =====================
data_t           = reshape(data_t, [H, W, D]);
labels_t         = cubseg(data_t, 15000);

data_t           = reshape(data_t, [], D);
[Xm_t, XmB, XmA, Anchor_t] = getXm(data_t, labels_t);
Xt_da            = Anchor_t;

%% ===================== 域适应分类 =====================
tic;

data_s      = reshape(data_s, [], D);
vote_matrix = zeros(size(gt_t, 1), num_classes);

% 从源域随机选取训练样本
[Xs, Ys] = select_training_datagd(data_s, y_pred, options.num);

% 训练 KNN 分类器，对目标域锚点进行初始标签预测
knnModel = fitcknn(Xs, Ys, 'NumNeighbors', 10);
Yt0      = predict(knnModel, Xt_da);

% 域不变子空间对齐（DISA）
[Zs, Zt, A, Att, Yt1_pred] = upDISA(Xs', Xt_da', Ys, Yt0, options, data_t');

% 投票统计
for j = 1:length(Yt1_pred)
    vote_matrix(j, Yt1_pred(j)) = vote_matrix(j, Yt1_pred(j)) + 1;
end

% 根据投票确定最终标签
[~, Yt1]         = max(vote_matrix, [], 2);
Yt1_reshaped     = reshape(Yt1, [H, W]);
Yt1_updated      = update_labels_with_neighbors(Yt1_reshaped, vote_matrix, num_classes);
Yt1_updated1     = Yt1_updated(:);

time1 = toc;

%% ===================== 目标域评估 =====================
ind  = find(gt_t);
gnd  = gt_t(ind);
resall = Yt1_updated1(ind);

[results] = evaluate_results_clustering(resall, gnd);
%% ===================== 输出结果 =====================
fprintf('Source clustering time : %.4f s\n', time);
fprintf('Domain adaptation time : %.4f s\n', time1);
fprintf('\n--- Evaluation Results ---\n');
fprintf('ACC    : %.4f\n', results(1));
fprintf('Kappa  : %.4f\n', results(2));
fprintf('NMI    : %.4f\n', results(3));
fprintf('Purity : %.4f\n', results(4));
fprintf('ARI    : %.4f\n', results(5));
fprintf('Fscore : %.4f\n', results(6));