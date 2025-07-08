clc;clear all;close all;
% 模拟数据：新算法MDA和3个对比算法在5个测试函数上的30次运行结果
% 假设最小化问题：值越小越好
load F1.mat;
% 新算法 (MDA) 的性能数据 (12函数 × 30次运行)
mda_perf(1,:)=Afitness(1,:);
% 对比算法性能数据 (6算法 × 12函数 × 30次运行)
algorithms_perf(1:6,1,:)=Afitness(2:end,:);
load F2.mat;
mda_perf(2,:)=Afitness(1,:);
algorithms_perf(1:6,2,:)=Afitness(2:end,:);
load F3.mat;
mda_perf(3,:)=Afitness(1,:);
algorithms_perf(1:6,3,:)=Afitness(2:end,:);
load F4.mat;
mda_perf(4,:)=Afitness(1,:);
algorithms_perf(1:6,4,:)=Afitness(2:end,:);
load F5.mat;
mda_perf(5,:)=Afitness(1,:);
algorithms_perf(1:6,5,:)=Afitness(2:end,:);
load F6.mat;
mda_perf(6,:)=Afitness(1,:);
algorithms_perf(1:6,6,:)=Afitness(2:end,:);
load F7.mat;
mda_perf(7,:)=Afitness(1,:);
algorithms_perf(1:6,7,:)=Afitness(2:end,:);
load F8.mat;
mda_perf(8,:)=Afitness(1,:);
algorithms_perf(1:6,8,:)=Afitness(2:end,:);
load F9.mat;
mda_perf(9,:)=Afitness(1,:);
algorithms_perf(1:6,9,:)=Afitness(2:end,:);
load F10.mat;
mda_perf(10,:)=Afitness(1,:);
algorithms_perf(1:6,10,:)=Afitness(2:end,:);
load F11.mat;
mda_perf(11,:)=Afitness(1,:);
algorithms_perf(1:6,11,:)=Afitness(2:end,:);
load F12.mat;
mda_perf(12,:)=Afitness(1,:);
algorithms_perf(1:6,12,:)=Afitness(2:end,:);

% 计算Cliff's Delta并执行Holm校正
[delta, p, p_adj, sig] = cliffs_delta_with_holm(mda_perf, algorithms_perf, 'alpha', 0.05, 'minimize', true);

% 显示详细结果
fprintf('\n===== 详细结果 =====\n');
for func = 1:size(delta,1)
    fprintf('\n函数 %d:\n', func);
    fprintf('算法\tCliff''s Delta\t原始p值\t校正p值\t显著性\n');
    for algo = 1:size(delta,2)
        fprintf('%d\t%8.4f\t%8.4f\t%8.4f\t', algo, delta(func,algo), p(func,algo), p_adj(func,algo));
        
        if sig(func,algo) == 1
            fprintf('↑ (MDA显著优于)\n');
        elseif sig(func,algo) == -1
            fprintf('↓ (MDA显著劣于)\n');
        else
            fprintf('≈ (无显著差异)\n');
        end
    end
end

% 创建结果表格
fprintf('\n===== 论文结果表格 =====\n');
fprintf('函数\\算法\t');
for algo = 1:size(delta,2)
    fprintf('算法%d\t', algo);
end
fprintf('\n');

for func = 1:size(delta,1)
    fprintf('F%d\t\t', func);
    for algo = 1:size(delta,2)
        fprintf('%.4f%s\t', delta(func,algo), get_sign_symbol(sig(func,algo)));
    end
    fprintf('\n');
end

fprintf('\n符号说明: ↑ - MDA显著优于, ↓ - MDA显著劣于, ≈ - 无显著差异\n');
fprintf('(所有检验均使用Holm校正，α=0.05)\n');

% 辅助函数：获取显著性符号
function symbol = get_sign_symbol(value)
    if value == 1
        symbol = '↑';
    elseif value == -1
        symbol = '↓';
    else
        symbol = '≈';
    end
end