classdef BezierEditor < handle
    properties (Access = private)
        GUI
        Calculator
        Drawer
    end
    
    methods (Access = public)
        function obj = BezierEditor()
            % 계산기 초기화
            obj.Calculator = BezierCalculator();
            
            % GUI 먼저 생성 (MainAxes 포함)
            obj.GUI = BezierGUI();
            
            % Drawer는 GUI의 MainAxes를 받아서 초기화
            obj.Drawer = BezierDrawer(obj.GUI.getMainAxes(), obj.Calculator);
            
            % GUI에 Calculator와 Drawer 전달
            obj.GUI.setControlManager(obj.Calculator, obj.Drawer);
        end
    end
end