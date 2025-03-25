classdef BezierControlManager < handle
    properties (Access = private)
        Calculator
        Drawer
        DraggedPointIdx = []    
        InnerControlPoints      
        OuterControlPoints
        OuterSlopes            
        X1
        X2
        N
        OuterY1
        OuterY2
    end
    
    methods (Access = public)
        function obj = BezierControlManager(calculator, drawer)
            obj.Calculator = calculator;
            obj.Drawer = drawer;
            obj.OuterControlPoints = [];
            obj.InnerControlPoints = [];
            obj.OuterSlopes = [];
        end
        
        function initializeCurves(obj, n, x1, x2)
            obj.N = n;
            obj.X1 = x1;
            obj.X2 = x2;
            
            % 이전 그래프 지우기
            obj.Drawer.clearPlots();
            
            % 초기 제어점 설정
            obj.setInitialControlPoints();
            obj.drawOuterCurve();
            obj.createInnerCurve();
        end
        
        function startDrag(obj, point)
            if isempty(obj.InnerControlPoints)
                return;
            end
            
            distances = sum((obj.InnerControlPoints - repmat(point, size(obj.InnerControlPoints, 1), 1)).^2, 2);
            [minDist, idx] = min(distances);
            
            if minDist < 0.1
                obj.DraggedPointIdx = idx;
            end
        end
        
        function endDrag(obj)
            obj.DraggedPointIdx = [];
        end
        
        function moveControlPoint(obj, point)
            if isempty(obj.DraggedPointIdx)
                return;
            end
            
            newPoint = obj.constrainControlPoint(point);
            if ~isempty(newPoint)
                obj.InnerControlPoints(obj.DraggedPointIdx,:) = newPoint;
                obj.updateInnerCurve();
            end
        end
        
        function updateOuterPoints(obj, points)
            % 제어점 개수 검증
            if size(points, 1) ~= obj.N + 1
                error('제어점의 개수가 올바르지 않습니다. %d개의 제어점이 필요합니다.', obj.N + 1);
            end
            
            % 이전 그래프 지우기
            obj.Drawer.clearPlots();
            
            obj.OuterControlPoints = points;
            obj.drawOuterCurve();
            obj.createInnerCurve();
        end
        
        function reset(obj)
            obj.InnerControlPoints = [];
            obj.OuterControlPoints = [];
            obj.OuterSlopes = [];
            obj.DraggedPointIdx = [];
            obj.Drawer.clearPlots();
        end
    end
    
    methods (Access = private)
        function setInitialControlPoints(obj)
            x = linspace(0, 5, obj.N + 1);
            y = sin(x);
            obj.OuterControlPoints = [x', y'];
        end
        
        function drawOuterCurve(obj)
            t = linspace(0, 1, 1000);
            bezierPoints = obj.Calculator.calculateBezierPoints(obj.OuterControlPoints, t);
            
            [y1, slope1] = obj.Calculator.findPointAndSlope(obj.X1, bezierPoints);
            [y2, slope2] = obj.Calculator.findPointAndSlope(obj.X2, bezierPoints);
            
            obj.OuterY1 = y1;
            obj.OuterY2 = y2;
            obj.OuterSlopes = [slope1, slope2];
            
            obj.Drawer.drawBezierCurve(obj.OuterControlPoints, 'outer');
            obj.Drawer.plotPointAndSlope(obj.X1, y1, slope1);
            obj.Drawer.plotPointAndSlope(obj.X2, y2, slope2);
        end
        
        function createInnerCurve(obj)
            obj.InnerControlPoints = obj.calculateInnerControlPoints();
            obj.Drawer.drawBezierCurve(obj.InnerControlPoints, 'inner');
            obj.Drawer.updateLegend();
        end
        
        function updateInnerCurve(obj)
            t = linspace(0, 1, 1000);
            points = obj.Calculator.calculateBezierPoints(obj.InnerControlPoints, t);
            obj.Drawer.updateInnerBezier(points, obj.InnerControlPoints);
        end
        
        function points = calculateInnerControlPoints(obj)
            points = zeros(obj.N + 1, 2);
            
            % 끝점들 설정
            points(1,:) = [obj.X1, obj.OuterY1];
            points(end,:) = [obj.X2, obj.OuterY2];
            
            % 간격 계산
            d = (obj.X2 - obj.X1) / obj.N;
            
            % 두 번째 제어점 (첫 번째 접점에서의 기울기 방향)
            points(2,:) = [obj.X1 + d, obj.OuterY1 + obj.OuterSlopes(1) * d];
            
            % 마지막에서 두 번째 제어점 (두 번째 접점에서의 기울기 방향)
            points(end-1,:) = [obj.X2 - d, obj.OuterY2 - obj.OuterSlopes(2) * d];  % 부호 수정
            
            % 중간 제어점들 설정
            for i = 3:obj.N-1
                t = (i-2)/(obj.N-3);
                points(i,:) = (1-t)*points(2,:) + t*points(end-1,:);
            end
        end
        
        function newPoint = constrainControlPoint(obj, point)
            if isempty(point)
                newPoint = [];
                return;
            end
            
            idx = obj.DraggedPointIdx;
            n = size(obj.InnerControlPoints, 1) - 1;
            
            if idx == 1 || idx == n+1
                % 첫 번째와 마지막 제어점은 고정
                newPoint = obj.InnerControlPoints(idx,:);
            elseif idx == 2
                % 두 번째 제어점은 첫 번째 기울기를 따라 움직임
                x1 = obj.InnerControlPoints(1,1);
                y1 = obj.InnerControlPoints(1,2);
                slope = obj.OuterSlopes(1);
                dx = point(1) - x1;
                newPoint = [point(1), y1 + slope * dx];
            elseif idx == n
                % 마지막에서 두 번째 제어점은 마지막 기울기를 따라 움직임
                x2 = obj.InnerControlPoints(end,1);
                y2 = obj.InnerControlPoints(end,2);
                slope = obj.OuterSlopes(2);
                dx = point(1) - x2;
                newPoint = [point(1), y2 + slope * dx];
            else
                % 나머지 중간 제어점들은 자유롭게 이동
                newPoint = point;
            end
        end
        
    end
end