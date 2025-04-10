function [hv] = approximate_hypervolume_ms(F, ub, samples)
    % F为M个目标函数值组成的向量，且F中所有解都是非支配的；
    % ub为每个目标函数的最大值；(上限参考点)
    % samples为用于蒙特卡罗近似的样本数量(默认值:100000)；
    % hv为F的超体积（或勒贝格度量）
    if (nargin < 2), ub = (max(F,[],2)); end  % ub输出的是种群中最大目标值
	if (nargin < 3), samples = 10000; end  % 

    [M, l] = size(F); % l为种群数量，即M个目标函数值;M为F的目标函数值的个数；
	samples = 100000;
	lb = min(F')';   %’--转置 %lb输出的是种群中最小目标值
    
	F_samples = repmat(lb,1,samples) + rand(M,samples) .* repmat((ub - lb),1,samples);%
	is_dominated_count = 0;
	for i = 1:samples
		for j = 1:l
			if (dominates(F(:,j), F_samples(:,i))) % A优于B--0;B优于A--1  
				is_dominated_count = is_dominated_count + 1; % 代表样本中优于最优解集的数量
				break;
			end
		end
	end
	hv = prod(ub - lb) * (is_dominated_count / samples);
end
% [hv] = approximate_hypervolume_ms(F, ub, samples)
%
% Computes the hypervolume (or Lebesgue measure) of the M x l
% matrix F of l vectors of M objective function values by means
% of a Monte-Carlo approximation method.
%
% IMPORTANT:
%   Considers Minimization of the objective function values!
%
% Input:
% - F              - An M x l matrix where each of the l columns 
%                    represents a vector of M objective function values
%                    (note that this function assumes that all 
%                    solutions of F are non-dominated).
% - ub             - Optional: Upper bound reference point (default:
%                    the boundary point containing the maximum of F
%                    for each objective).
% - samples        - Optional: The number of samples used for the Monte-
%                    Carlo approximation (default: 100000).
%
% Output:
% - hv             - The hypervolume (or lebesgue measure) of F.
%
% Author: Johannes W. Kruisselbrink
% Last modified: March 17, 2011
