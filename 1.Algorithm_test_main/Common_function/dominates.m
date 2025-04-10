function d = dominates(fA, fB)
% [d] = dominates(fA, fB)
% 比较两种解A和B的目标函数值fA和fB。返回A是否优于B。
	d = false;
	for i = 1:length(fA)
		if (fA(i) > fB(i))
			d = false;
			return
		elseif (fA(i) < fB(i))
			d = true;
		end
	end
end
