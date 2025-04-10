function final_maker = nsga2_mutation_maker_points(c1_maker)
[N,~] = size(c1_maker);
% n_points = ceil(rand(5));
n_points = 2;
muta_point = rand(1,n_points);
L = sort(muta_point);
L_c = ceil(L*N); % 变异位置
final_maker = c1_maker;
for j3 = 1:n_points
    final_maker(L_c(j3),1) = ~c1_maker(L_c(j3),1);
end