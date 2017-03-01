function sma = stateMatrix()
global BpodSystem
global TaskParameters
ValveTimes  = GetValveTimes(TaskParameters.GUI.rewardAmount, [1 3]);
%% Define ports
LeftPort = floor(mod(TaskParameters.GUI.Ports_LMR/100,10));
CenterPort = floor(mod(TaskParameters.GUI.Ports_LMR/10,10));
RightPort = mod(TaskParameters.GUI.Ports_LMR,10);
LeftPortOut = strcat('Port',num2str(LeftPort),'Out');
CenterPortOut = strcat('Port',num2str(CenterPort),'Out');
RightPortOut = strcat('Port',num2str(RightPort),'Out');
LeftPortIn = strcat('Port',num2str(LeftPort),'In');
CenterPortIn = strcat('Port',num2str(CenterPort),'In');
RightPortIn = strcat('Port',num2str(RightPort),'In');

LeftValve = 2^(LeftPort-1);
RightValve = 2^(RightPort-1);

LeftValveTime  = GetValveTimes(TaskParameters.GUI.rewardAmount, LeftPort);
RightValveTime  = GetValveTimes(TaskParameters.GUI.rewardAmount, RightPort);

if BpodSystem.Data.Custom.Baited.Left(end)
    LeftPokeAction = 'rewarded_Lin';
else
    LeftPokeAction = 'unrewarded_Lin';
end
if BpodSystem.Data.Custom.Baited.Right(end)
    RightPokeAction = 'rewarded_Rin';
else
    RightPokeAction = 'unrewarded_Rin';
end
%%
sma = NewStateMatrix();
sma = AddState(sma, 'Name', 'state_0',...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'wait_Cin'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'wait_Cin',...
    'Timer', 0,...
    'StateChangeConditions', {CenterPortIn, 'Cin'},...
    'OutputActions', {strcat('PWM',num2str(CenterPort)),255});
sma = AddState(sma, 'Name', 'Cin',...
    'Timer', TaskParameters.GUI.SampleTime,...
    'StateChangeConditions', {CenterPortOut, 'EarlyCout','Tup','stillSampling'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'stillSampling',...
    'Timer', TaskParameters.GUI.ChoiceDeadline,...
    'StateChangeConditions', {CenterPortOut, 'wait_Sin','Tup','wait_Sin'},...
    'OutputActions', {'SoftCode',2});
sma = AddState(sma, 'Name', 'wait_Sin',...
    'Timer',TaskParameters.GUI.ChoiceDeadline,...
    'StateChangeConditions', {LeftPortIn,'Lin',RightPortIn,'Rin','Tup','ITI'},...
    'OutputActions',{strcat('PWM',num2str(LeftPort)),255,strcat('PWM',num2str(RightPort)),255});
sma = AddState(sma, 'Name', 'Lin',...
    'Timer', TaskParameters.GUI.FeedbackTime,...
    'StateChangeConditions', {LeftPortOut, 'EarlyLout','Tup','stillLin'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'stillLin',...
    'Timer', TaskParameters.GUI.MaxFeedbackTime-TaskParameters.GUI.FeedbackTime,...
    'StateChangeConditions', {LeftPortOut,LeftPokeAction,'Tup',LeftPokeAction},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'Rin',...
    'Timer', TaskParameters.GUI.FeedbackTime,...
    'StateChangeConditions', {RightPortOut,'EarlyRout','Tup','stillRin'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'stillRin',...
    'Timer', TaskParameters.GUI.MaxFeedbackTime-TaskParameters.GUI.FeedbackTime,...
    'StateChangeConditions', {RightPortOut,RightPokeAction,'Tup',RightPokeAction},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'rewarded_Lin',...
    'Timer', 0,...
    'StateChangeConditions', {'Tup','water_L'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'rewarded_Rin',...
    'Timer', 0,...
    'StateChangeConditions', {'Tup','water_R'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'unrewarded_Lin',...
    'Timer', 0,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'unrewarded_Rin',...
    'Timer', 0,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'water_L',...
    'Timer', LeftValveTime,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {'ValveState', LeftValve});
sma = AddState(sma, 'Name', 'water_R',...
    'Timer', RightValveTime,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {'ValveState', RightValve});
sma = AddState(sma, 'Name', 'EarlyCout',...
    'Timer', TaskParameters.GUI.EarlyCoutPenalty,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {'SoftCode',1});
sma = AddState(sma, 'Name', 'EarlyLout',...
    'Timer', TaskParameters.GUI.EarlySoutPenalty,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {'SoftCode',1});
sma = AddState(sma, 'Name', 'EarlyRout',...
    'Timer', TaskParameters.GUI.EarlySoutPenalty,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {'SoftCode',1});
if TaskParameters.GUI.VI
    sma = AddState(sma, 'Name', 'ITI',...
        'Timer',exprnd(TaskParameters.GUI.ITI),...
        'StateChangeConditions',{'Tup','exit'},...
        'OutputActions',{});
else
    sma = AddState(sma, 'Name', 'ITI',...
        'Timer',TaskParameters.GUI.ITI,...
        'StateChangeConditions',{'Tup','exit'},...
        'OutputActions',{});
end
end