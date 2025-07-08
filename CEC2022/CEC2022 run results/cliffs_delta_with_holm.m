function [delta_values, p_values, p_adj, significance] = cliffs_delta_with_holm(proposed_algorithm, other_algorithms, varargin)
% CLIFFS_DELTA_WITH_HOLM 计算Cliff's Delta效应量并执行Holm多重比较校正
%
% 输入：
%   proposed_algorithm - 新算法在各测试函数上的性能值 (n_functions × n_runs 矩阵)
%   other_algorithms   - 其他算法性能值 (n_algorithms × n_functions × n_runs 数组)
%   'alpha'            - 显著性水平 (默认0.05)
%   'minimize'         - 是否最小化问题 (默认true，值越小越好)
%
% 输出：
%   delta_values - Cliff's Delta效应量 (n_functions × n_algorithms)
%   p_values     - Wilcoxon检验原始p值 (n_functions × n_algorithms)
%   p_adj        - Holm校正后的p值 (n_functions × n_algorithms)
%   significance - 显著性标记 (n_functions × n_algorithms)
%                  1: 新算法显著优于
%                 -1: 新算法显著劣于
%                  0: 无显著差异

% 解析输入参数
p = inputParser;
addParameter(p, 'alpha', 0.05, @(x) x>0 && x<1);
addParameter(p, 'minimize', true, @islogical);
parse(p, varargin{:});
alpha = p.Results.alpha;
minimize_problem = p.Results.minimize;

% 获取维度信息
[n_functions, n_runs] = size(proposed_algorithm);
[n_algorithms, ~, ~] = size(other_algorithms);

% 初始化结果矩阵
delta_values = zeros(n_functions, n_algorithms);
p_values = zeros(n_functions, n_algorithms);
p_adj = zeros(n_functions, n_algorithms);
significance = zeros(n_functions, n_algorithms);

% 对每个测试函数和每个算法计算效应量和p值
for func_idx = 1:n_functions
    prop_data = proposed_algorithm(func_idx, :);
    
    % 存储当前函数的所有p值用于Holm校正
    func_p_values = zeros(1, n_algorithms);
    
    for algo_idx = 1:n_algorithms
        comp_data = squeeze(other_algorithms(algo_idx, func_idx, :))';
        
        % 计算Cliff's Delta
        [delta, p_val] = calculate_cliffs_delta(prop_data, comp_data, minimize_problem);
        
        delta_values(func_idx, algo_idx) = delta;
        p_values(func_idx, algo_idx) = p_val;
        func_p_values(algo_idx) = p_val;
    end
    
    % 对当前函数的所有比较进行Holm校正
    [~, ~, ~, adj_p] = bonf_holm(func_p_values, alpha);
    p_adj(func_idx, :) = adj_p;
    
    % 根据校正后的p值确定显著性
    for algo_idx = 1:n_algorithms
        if p_adj(func_idx, algo_idx) < alpha
            if minimize_problem
                if delta_values(func_idx, algo_idx) < 0
                    significance(func_idx, algo_idx) = 1; % 新算法显著优于
                else
                    significance(func_idx, algo_idx) = -1; % 新算法显著劣于
                end
            else
                if delta_values(func_idx, algo_idx) > 0
                    significance(func_idx, algo_idx) = 1; % 新算法显著优于
                else
                    significance(func_idx, algo_idx) = -1; % 新算法显著劣于
                end
            end
        else
            significance(func_idx, algo_idx) = 0; % 无显著差异
        end
    end
end

% 显示结果摘要
fprintf('\n===== 统计结果摘要 =====\n');
fprintf('测试函数数量: %d\n', n_functions);
fprintf('比较算法数量: %d\n', n_algorithms);
fprintf('每次运行次数: %d\n', n_runs);
fprintf('显著性水平: %.3f\n', alpha);

% 修复的三元运算符问题 - 使用条件语句替代
if minimize_problem
    problem_type = '最小化';
else
    problem_type = '最大化';
end
fprintf('问题类型: %s\n', problem_type);

% 计算整体优势统计
total_comparisons = n_functions * n_algorithms;
better_count = sum(significance(:) == 1);
worse_count = sum(significance(:) == -1);
tie_count = sum(significance(:) == 0);

fprintf('\n----- 整体比较结果 -----\n');
fprintf('新算法显著优于: %.1f%% (%d/%d)\n', better_count/total_comparisons*100, better_count, total_comparisons);
fprintf('新算法显著劣于: %.1f%% (%d/%d)\n', worse_count/total_comparisons*100, worse_count, total_comparisons);
fprintf('无显著差异: %.1f%% (%d/%d)\n', tie_count/total_comparisons*100, tie_count, total_comparisons);

% 效应量分布分析
delta_all = delta_values(:);
negligible = sum(abs(delta_all) < 0.147);
small = sum(abs(delta_all) >= 0.147 & abs(delta_all) < 0.33);
medium = sum(abs(delta_all) >= 0.33 & abs(delta_all) < 0.474);
large = sum(abs(delta_all) >= 0.474);

fprintf('\n----- Cliff''s Delta 效应量分布 -----\n');
fprintf('微不足道 (|δ| < 0.147): %.1f%%\n', negligible/total_comparisons*100);
fprintf('小效应 (0.147 ≤ |δ| < 0.33): %.1f%%\n', small/total_comparisons*100);
fprintf('中等效应 (0.33 ≤ |δ| < 0.474): %.1f%%\n', medium/total_comparisons*100);
fprintf('大效应 (|δ| ≥ 0.474): %.1f%%\n', large/total_comparisons*100);

end

function [delta, p_val] = calculate_cliffs_delta(A, B, minimize_problem)
% 计算两组数据的Cliff's Delta和Wilcoxon p值

% 确保输入为行向量
A = A(:)';
B = B(:)';

% 获取样本大小
m = length(A);
n = length(B);

% 初始化计数器
wins = 0;    % A > B 的次数
losses = 0;  % A < B 的次数

% 比较所有可能的配对
for i = 1:m
    for j = 1:n
        if A(i) > B(j)
            wins = wins + 1;
        elseif A(i) < B(j)
            losses = losses + 1;
        end
    end
end

% 计算Cliff's Delta
delta = (wins - losses) / (m * n);

% 根据问题类型调整方向
% 注意：delta计算本身不需要调整，解释时考虑方向即可

% 计算Wilcoxon秩和检验p值
[p_val, ~] = ranksum(A, B);

end

function [h, crit_p, adj_ci_cv, adj_p] = bonf_holm(pvalues, alpha)
% Holm-Bonferroni校正实现
%
% 输入：
%   pvalues - p值向量
%   alpha   - 显著性水平
%
% 输出：
%   h       - 是否拒绝原假设 (1=拒绝, 0=不拒绝)
%   crit_p  - 临界p值
%   adj_ci_cv - 调整后的置信区间临界值
%   adj_p   - 调整后的p值

m = length(pvalues);
if m == 0
    error('pvalues向量为空');
end

% 对p值进行排序
[sorted_p, sort_ids] = sort(pvalues);

% 初始化调整后的p值
adj_p = zeros(1, m);
adj_p_temp = sorted_p .* (m:-1:1);  % 乘以剩余检验数量

% 确保调整后的p值不大于1
adj_p_temp = min(adj_p_temp, 1);

% 取累积最大值确保单调性
for i = 1:m
    if i == 1
        adj_p_temp(i) = adj_p_temp(i);
    else
        adj_p_temp(i) = max(adj_p_temp(i), adj_p_temp(i-1));
    end
end

% 恢复原始顺序
adj_p(sort_ids) = adj_p_temp;

% 确定拒绝哪些原假设
h = adj_p < alpha;

% 计算临界p值
crit_p = alpha ./ (m:-1:1);
crit_p = min(crit_p, 1); % 确保不大于1

% 计算调整后的置信区间临界值 (可选)
adj_ci_cv = norminv(1 - alpha ./ (2*(m:-1:1)));
end