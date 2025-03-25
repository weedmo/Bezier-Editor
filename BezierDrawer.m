classdef BezierDrawer < handle
    properties (Access = private)
        MainAxes
        Calculator
        OuterBezier
        InnerBezier
        ControlPointsPlot
        
        OUTER_LINE_STYLE = 'b-'
        INNER_LINE_STYLE = 'r-'
        OUTER_CONTROL_STYLE = 'ro-'
        INNER_CONTROL_STYLE = 'mo-'
        LINE_WIDTH = 2
        CONTROL_LINE_WIDTH = 1
        POINT_MARKER_SIZE = 10
    end
    
    methods (Access = public)
        function obj = BezierDrawer(ax, calculator)
            obj.MainAxes = ax;
            obj.Calculator = calculator;
        end
        
        function drawBezierCurve(obj, controlPoints, curveType)
            t = linspace(0, 1, 1000);
            points = obj.Calculator.calculateBezierPoints(controlPoints, t);
            
            switch curveType
                case 'outer'
                    obj.OuterBezier = plot(obj.MainAxes, points(:,1), points(:,2), ...
                        obj.OUTER_LINE_STYLE, 'LineWidth', obj.LINE_WIDTH);
                    obj.ControlPointsPlot = plot(obj.MainAxes, controlPoints(:,1), ...
                        controlPoints(:,2), obj.OUTER_CONTROL_STYLE, ...
                        'LineWidth', obj.CONTROL_LINE_WIDTH);
                case 'inner'
                    obj.InnerBezier = plot(obj.MainAxes, points(:,1), points(:,2), ...
                        obj.INNER_LINE_STYLE, 'LineWidth', obj.LINE_WIDTH);
                    plot(obj.MainAxes, controlPoints(:,1), controlPoints(:,2), ...
                        obj.INNER_CONTROL_STYLE, 'LineWidth', obj.CONTROL_LINE_WIDTH);
            end
        end
        
        function plotPointAndSlope(obj, x, y, slope)
            plot(obj.MainAxes, x, y, 'g*', 'MarkerSize', obj.POINT_MARKER_SIZE);
            xRange = [-0.5, 0.5] + x;
            yRange = slope * (xRange - x) + y;
            plot(obj.MainAxes, xRange, yRange, 'g--', 'LineWidth', 1);
        end
        
        function updateInnerBezier(obj, points, controlPoints)
            if ishandle(obj.InnerBezier)
                set(obj.InnerBezier, 'XData', points(:,1), 'YData', points(:,2));
            end
            
            innerControlLines = findobj(obj.MainAxes, 'Color', 'm');
            if ~isempty(innerControlLines)
                set(innerControlLines, 'XData', controlPoints(:,1), ...
                    'YData', controlPoints(:,2));
            end
        end
        
        function clearPlots(obj)
            cla(obj.MainAxes);
            hold(obj.MainAxes, 'on');
            grid(obj.MainAxes, 'on');
        end
        
        function updateLegend(obj)
            legend(obj.MainAxes, {'외부 베지어 곡선', '외부 제어점', ...
                '좌 접점', '좌 접선', '우 접점', '우 접선', ...
                '내부 베지어 곡선', '내부 제어점'}, ...
                'Location', 'eastoutside', ...
                'FontSize', 10);
        end
    end
end