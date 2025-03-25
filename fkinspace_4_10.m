clear; clc;

% Home Configuration (M)
M = [[1,0,0,3.73]; 
    [0,1,0,0]; 
    [0,0,1,2.73]; 
    [0,0,0,1]];

% Slist (각 열이 하나의 Screw Vector가 되도록 수정, 전치 필요)
Slist = [[0,0,0,0,0,0]; 
        [0,1,1,1,0,0]; 
        [1,0,0,0,0,1]; 
        [0,0,1,-0.73,0,0]; 
        [-1,0,0,0,0,-3.73]; 
        [0,1,2.73,3.73,1,0]];
%Slist = Slist'; % 6×n 형태로 변경

% 조인트 각도 (Theta 리스트)
thetalist = [-pi/2; pi/2; pi/3; -pi/4; 1; pi/6];

% FKinSpace 실행
T = FKinSpace(M, Slist, thetalist);

% 결과 출력
disp('End-Effector의 최종 위치:');
disp(T);
