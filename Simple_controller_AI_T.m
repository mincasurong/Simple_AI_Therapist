% This source code is related to a simple controller of AI-therapist
% The results of this study is submitted to IEEE transactions on neural
% systems and rehabilitation engineering (SCIE))
% Made by M.S. Chang in Sogang university, South Korea.
% 2017~2020

clear all; close all; clc;

% Choose input below
% 1. Trunk angle in sagittal and 2. frontal, 3. feedback error of left knee joint, and 4. right knee joint 
inputs = [8 2 3 2]; 
%% Mandani fuzzy logic is established
fis = mamfis('Name','SimpleAIT');

%% Input variables
fis = addInput(fis,[0 10],'Name','Trunk_Sagittal');
fis = addInput(fis,[-10 10],'Name','Trunk_Frontal');
fis = addInput(fis,[0 10],'Name','Feedbackerror_left');
fis = addInput(fis,[0 10],'Name','Feedbackerror_right');

%% Gaussian membership function based on expert's knowledge
fis = addMF(fis,'Trunk_Sagittal','gaussmf',[0.92571582465255 0],'Name','Low');
fis = addMF(fis,'Trunk_Sagittal','gaussmf',[0.908 2.22248677248677],'Name','Mid');
fis = addMF(fis,'Trunk_Sagittal','gaussmf',[2.79512253851401 8],'Name','High');

fis = addMF(fis,'Trunk_Frontal','gaussmf',[2.31550287848893 -6.93],'Name','Low');
fis = addMF(fis,'Trunk_Frontal','gaussmf',[1.46268942191084 0.037],'Name','Mid');
fis = addMF(fis,'Trunk_Frontal','gaussmf',[2.46932449342998 7],'Name','High');

fis = addMF(fis,'Feedbackerror_left','gaussmf',[1.60873772018449 0.0212],'Name','Low');
fis = addMF(fis,'Feedbackerror_left','gaussmf',[1.52 4.29978835978836],'Name','Mid');
fis = addMF(fis,'Feedbackerror_left','gaussmf',[1.446992696787 8],'Name','High');

fis = addMF(fis,'Feedbackerror_right','gaussmf',[1.94 0.661375661375661],'Name','Low');
fis = addMF(fis,'Feedbackerror_right','gaussmf',[2.14995253392485 5.63],'Name','Mid');
fis = addMF(fis,'Feedbackerror_right','gaussmf',[1.33689542637929 10],'Name','High');

%% Output
fis = addOutput(fis,[0 1],'Name','Verbalcue');
fis = addMF(fis,'Verbalcue','gaussmf',[0.08493 3.469e-18],'Name','1');
fis = addMF(fis,'Verbalcue','gaussmf',[0.08493 0.2],'Name','2');
fis = addMF(fis,'Verbalcue','gaussmf',[0.08493 0.4],'Name','3');
fis = addMF(fis,'Verbalcue','gaussmf',[0.08493 0.6],'Name','4');
fis = addMF(fis,'Verbalcue','gaussmf',[0.08493 0.8],'Name','5');
fis = addMF(fis,'Verbalcue','gaussmf',[0.08493 1],'Name','6');

%% Fuzzy rule
r1 = "If Trunk_Sagittal is Low and Trunk_Frontal is Mid and Feedbackerror_left is Low and Feedbackerror_right is Low then Verbalcue is 1";
r2 = "If Trunk_Sagittal is High and Trunk_Frontal is Mid and Feedbackerror_left is Low and Feedbackerror_right is Low then Verbalcue is 2";
r3 = "If Trunk_Sagittal is Mid and Trunk_Frontal is High and Feedbackerror_left is Low and Feedbackerror_right is Mid then Verbalcue is 3";
r4 = "If Trunk_Sagittal is Mid and Trunk_Frontal is Low and Feedbackerror_left is Mid and Feedbackerror_right is Low then Verbalcue is 4";
r5 = "If Trunk_Sagittal is Mid and Trunk_Frontal is Mid and Feedbackerror_left is High and Feedbackerror_right is Low then Verbalcue is 5";
r6 = "If Trunk_Sagittal is Mid and Trunk_Frontal is High and Feedbackerror_left is Low and Feedbackerror_right is High then Verbalcue is 6";

fis = addRule(fis,[r1 r2 r3 r4 r5 r6]);
fis.AndMethod = 'prod';

%% figure
plotfis(fis)

opt = evalfisOptions('OutOfRangeInputValueMessage','none');
[output,~,~,~,ruleFiring] = evalfis(fis,inputs,opt); % Fuzzy logic evaluation
[~,Out_cue] = max(ruleFiring)