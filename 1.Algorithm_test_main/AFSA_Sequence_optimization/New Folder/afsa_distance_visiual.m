function [distance_result]=afsa_distance_visiual(swam_current,visual_swam)
    x1 = swam_current(:,7);% 
    x2 = visual_swam(:,7);% 
    N = size(swam_current,1);
    distance_result=0;
    for ii1=1:N
        part1=x1(ii1,1);
        part2=x2(ii1,1);    
        if part1~=part2
            distance_result=distance_result+1; 
        end
    end
end