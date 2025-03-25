classdef BezierCalculator < handle
    methods (Access = public)
        function points = calculateBezierPoints(~, controlPoints, t)
            n = size(controlPoints, 1) - 1;
            points = zeros(length(t), 2);
            
            for i = 1:length(t)
                basis = BezierCalculator.calculateBernsteinBasis(n, t(i));  % static 메서드로 호출
                points(i,:) = basis * controlPoints;
            end
        end
        
        function [y, slope] = findPointAndSlope(~, x, bezierPoints)
            [~, idx] = min(abs(bezierPoints(:,1) - x));
            y = bezierPoints(idx,2);
            
            % 기울기 계산
            if idx > 1 && idx < size(bezierPoints,1)
                slope = (bezierPoints(idx+1,2) - bezierPoints(idx-1,2)) / ...
                       (bezierPoints(idx+1,1) - bezierPoints(idx-1,1));
            else
                if idx == 1
                    slope = (bezierPoints(2,2) - bezierPoints(1,2)) / ...
                           (bezierPoints(2,1) - bezierPoints(1,1));
                else
                    slope = (bezierPoints(end,2) - bezierPoints(end-1,2)) / ...
                           (bezierPoints(end,1) - bezierPoints(end-1,1));
                end
            end
        end
    end
    
    methods (Static)  % static 메서드로 변경
        function basis = calculateBernsteinBasis(n, t)
            basis = zeros(1, n+1);
            for j = 0:n
                basis(j+1) = nchoosek(n,j) * t^j * (1-t)^(n-j);
            end
        end
    end
end