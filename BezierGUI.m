classdef BezierGUI < handle
    properties (Access = private)
        Fig
        MainAxes
        Controls
        ControlManager
    end
    
    methods (Access = public)
        function obj = BezierGUI()
            obj.createMainWindow();
            obj.createControls();
            obj.setupCallbacks();
        end
        
        function delete(obj)
            if ishandle(obj.Fig)
                delete(obj.Fig);
            end
        end
        function ax = getMainAxes(obj)
            ax = obj.MainAxes;
        end
        
        function setControlManager(obj, calculator, drawer)
            obj.ControlManager = BezierControlManager(calculator, drawer);
        end
    end
    
    methods (Access = private)
        function createMainWindow(obj)
            obj.Fig = figure('Name', '베지어 곡선 에디터', ...
                'Position', [100 100 1200 800], ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none', ...
                'ToolBar', 'none');
            
            obj.MainAxes = axes('Parent', obj.Fig, ...
                'Position', [0.25 0.1 0.7 0.85]);
            hold(obj.MainAxes, 'on');
            grid(obj.MainAxes, 'on');
            axis(obj.MainAxes, 'equal');
            xlabel('X 축');
            ylabel('Y 축');
        end
        
        function createControls(obj)
            panel = uipanel('Parent', obj.Fig, ...
                'Position', [0.02 0.1 0.2 0.85], ...
                'Title', '입력 설정');
            
            obj.Controls = struct();
            obj.createInputControls(panel);
        end
        
        function createInputControls(obj, panel)
            % 제어점 테이블
            uicontrol('Parent', panel, ...
                'Style', 'text', ...
                'Position', [10 500 160 20], ...
                'String', '외부 곡선 제어점:');
            
            obj.Controls.PointsTable = uitable('Parent', panel, ...
                'Position', [10 350 160 150], ...
                'ColumnName', {'X', 'Y'}, ...
                'ColumnEditable', [true true], ...
                'ColumnWidth', {75 75}, ...
                'Data', [0 0; 1 1; 2 0; 3 1]);
            
            % 제어점 업데이트 버튼
            obj.Controls.UpdatePointsButton = uicontrol('Parent', panel, ...
                'Style', 'pushbutton', ...
                'Position', [10 310 160 30], ...
                'String', '제어점 업데이트', ...
                'Callback', @obj.updatePointsCallback);
            
            % 차수 입력
            uicontrol('Parent', panel, ...
                'Style', 'text', ...
                'Position', [10 270 120 20], ...
                'String', '베지어 곡선 차수 (n≥3):');
            
            obj.Controls.Degree = uicontrol('Parent', panel, ...
                'Style', 'edit', ...
                'Position', [10 240 120 25], ...
                'String', '3');
            
            % X1 입력
            uicontrol('Parent', panel, ...
                'Style', 'text', ...
                'Position', [10 200 120 20], ...
                'String', '첫 번째 x 좌표:');
            
            obj.Controls.X1 = uicontrol('Parent', panel, ...
                'Style', 'edit', ...
                'Position', [10 170 120 25], ...
                'String', '1');
            
            % X2 입력
            uicontrol('Parent', panel, ...
                'Style', 'text', ...
                'Position', [10 130 120 20], ...
                'String', '두 번째 x 좌표:');
            
            obj.Controls.X2 = uicontrol('Parent', panel, ...
                'Style', 'edit', ...
                'Position', [10 100 120 25], ...
                'String', '3');
            
            % 버튼들
            obj.Controls.DrawButton = uicontrol('Parent', panel, ...
                'Style', 'pushbutton', ...
                'Position', [10 60 120 30], ...
                'String', '곡선 그리기', ...
                'Callback', @obj.drawButtonCallback);
            
            obj.Controls.ResetButton = uicontrol('Parent', panel, ...
                'Style', 'pushbutton', ...
                'Position', [10 20 120 30], ...
                'String', '초기화', ...
                'Callback', @obj.resetButtonCallback);
        end
        
        function setupCallbacks(obj)
            set(obj.Fig, 'WindowButtonDownFcn', @obj.mouseDownCallback);
            set(obj.Fig, 'WindowButtonUpFcn', @obj.mouseUpCallback);
            set(obj.Fig, 'WindowButtonMotionFcn', @obj.mouseMotionCallback);
        end
        
        function drawButtonCallback(obj, ~, ~)
            try
                n = str2double(get(obj.Controls.Degree, 'String'));
                x1 = str2double(get(obj.Controls.X1, 'String'));
                x2 = str2double(get(obj.Controls.X2, 'String'));
                
                if n < 3
                    error('차수는 3 이상이어야 합니다.');
                end
                if x1 >= x2
                    error('첫 번째 x좌표는 두 번째 x좌표보다 작아야 합니다.');
                end
                
                % 차수에 맞는 초기 제어점 생성
                x = linspace(0, 5, n + 1);
                y = sin(x);
                initialPoints = [x', y'];
                set(obj.Controls.PointsTable, 'Data', initialPoints);
                
                obj.ControlManager.initializeCurves(n, x1, x2);
                
            catch e
                errordlg(e.message, '입력 오류');
            end
        end
        
        function updatePointsCallback(obj, ~, ~)
            try
                data = get(obj.Controls.PointsTable, 'Data');
                n = str2double(get(obj.Controls.Degree, 'String'));
                
                % 제어점 개수 검증
                if size(data, 1) ~= n + 1
                    error(['제어점 개수가 올바르지 않습니다.\n', ...
                        '현재 차수 ', num2str(n), '에 대해 ', ...
                        num2str(n+1), '개의 제어점이 필요합니다.']);
                end
                
                obj.ControlManager.updateOuterPoints(data);
            catch e
                errordlg(e.message, '입력 오류');
            end
        end
        
        function resetButtonCallback(obj, ~, ~)
            obj.ControlManager.reset();
            set(obj.Controls.Degree, 'String', '3');
            set(obj.Controls.X1, 'String', '1');
            set(obj.Controls.X2, 'String', '3');
            set(obj.Controls.PointsTable, 'Data', [0 0; 1 1; 2 0; 3 1]);
        end
        
        function mouseDownCallback(obj, ~, ~)
            point = get(obj.MainAxes, 'CurrentPoint');
            obj.ControlManager.startDrag(point(1, 1:2));
        end
        
        function mouseUpCallback(obj, ~, ~)
            obj.ControlManager.endDrag();
        end
        
        function mouseMotionCallback(obj, ~, ~)
            point = get(obj.MainAxes, 'CurrentPoint');
            obj.ControlManager.moveControlPoint(point(1, 1:2));
        end
    end
end