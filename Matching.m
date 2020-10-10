function Matching
% Reproduction on Bpod of protocol used in the PatonLab, MATCHINGvFix

global BpodSystem
global TaskParameters
global nidaq

%% Task parameters
TaskParameters = BpodSystem.ProtocolSettings;
if isempty(fieldnames(TaskParameters))
    %% Center Port ("stimulus sampling")
    TaskParameters.GUI.CenterWaitMax = 15;
    TaskParameters.GUI.LoopbackFix = true; % breaking fixation (FixTimeMin) doesn't abort trial
    TaskParameters.GUIMeta.LoopbackFix.Style = 'checkbox';
    TaskParameters.GUI.EarlyCoutPenalty = 0;
    TaskParameters.GUI.StimDelaySelection = 4;
    TaskParameters.GUIMeta.StimDelaySelection.Style = 'popupmenu';
    TaskParameters.GUIMeta.StimDelaySelection.String = {'Fix','AutoIncr','TruncExp','Uniform'};
    TaskParameters.GUI.StimDelayMin = 0.2;
    TaskParameters.GUI.StimDelayMax = 0.5;
    TaskParameters.GUI.StimDelayTau = 0.2;
    TaskParameters.GUI.StimDelay = TaskParameters.GUI.StimDelayMin;
    TaskParameters.GUIMeta.StimDelay.Style = 'text';
    TaskParameters.GUIPanels.StimDelay = {'CenterWaitMax','LoopbackFix','EarlyCoutPenalty','StimDelaySelection','StimDelayMin','StimDelayMax','StimDelayTau','StimDelay'};
    
    %% General
    TaskParameters.GUI.Ports_LMR = '123';
    TaskParameters.GUI.PreITI=0.2; % (s) time gap at end of trial
    TaskParameters.GUI.ITI = 0.8; % (s) ITI at the start of trial
    TaskParameters.GUI.VI = false; % random ITI
    TaskParameters.GUIMeta.VI.Style = 'checkbox';
    TaskParameters.GUI.ChoiceDeadline = 10;
    TaskParameters.GUI.MinCutoff = 50; % New waiting time as percentile of empirical distribution
    TaskParameters.GUI.CatchUnrwd = false; % random ITI
    TaskParameters.GUIMeta.CatchUnrwd.Style = 'checkbox';
    TaskParameters.GUIPanels.General = {'Ports_LMR','PreITI','ITI','VI','ChoiceDeadline','MinCutoff','CatchUnrwd'};
    
    % Side Ports ("waiting for feedback")
    TaskParameters.GUI.EarlySoutPenalty = 1;
    TaskParameters.GUI.FeedbackDelaySelection = 2;
    TaskParameters.GUIMeta.FeedbackDelaySelection.Style = 'popupmenu';
    TaskParameters.GUIMeta.FeedbackDelaySelection.String = {'Fix','AutoIncr','TruncExp','Uniform'};
    TaskParameters.GUI.FeedbackDelayMin = 0;
    TaskParameters.GUI.FeedbackDelayMax = 1;
    TaskParameters.GUI.FeedbackDelayTau = 0.4;
    TaskParameters.GUI.FeedbackDelay = TaskParameters.GUI.FeedbackDelayMin;
    TaskParameters.GUIMeta.FeedbackDelay.Style = 'text';
    TaskParameters.GUI.Grace = 0.2;
    TaskParameters.GUIPanels.SidePorts = {'EarlySoutPenalty','FeedbackDelaySelection','FeedbackDelayMin','FeedbackDelayMax','FeedbackDelayTau','FeedbackDelay','Grace'};
    
    % Reward
    TaskParameters.GUI.pHi =  50; % 0-100% Higher reward probability
    TaskParameters.GUI.pLo =  12; % 0-100% Lower reward probability
    TaskParameters.GUI.blockLenMin = 50;
    TaskParameters.GUI.blockLenMax = 100;
    TaskParameters.GUI.rewardAmount = 30;
    TaskParameters.GUI.DrinkingTime=0.2;
    TaskParameters.GUI.DrinkingGrace=0.05;
    TaskParameters.GUIPanels.Reward = {'rewardAmount','pLo','pHi','blockLenMin','blockLenMax','DrinkingTime','DrinkingGrace'};
    
    TaskParameters.GUI = orderfields(TaskParameters.GUI);
    
    %% Video
    TaskParameters.GUI.Wire1VideoTrigger = false;
    TaskParameters.GUIMeta.Wire1VideoTrigger.Style = 'checkbox';
    TaskParameters.GUIPanels.VideoGeneral = {'Wire1VideoTrigger'};
    
    %% Photometry
    %photometry general
    TaskParameters.GUI.Photometry=0;
    TaskParameters.GUIMeta.Photometry.Style='checkbox';
    TaskParameters.GUI.DbleFibers=0;
    TaskParameters.GUIMeta.DbleFibers.Style='checkbox';
    TaskParameters.GUIMeta.DbleFibers.String='Auto';
    TaskParameters.GUI.Isobestic405=0;
    TaskParameters.GUIMeta.Isobestic405.Style='checkbox';
    TaskParameters.GUIMeta.Isobestic405.String='Auto';
    TaskParameters.GUI.RedChannel=1;
    TaskParameters.GUIMeta.RedChannel.Style='checkbox';
    TaskParameters.GUIMeta.RedChannel.String='Auto';    
    TaskParameters.GUIPanels.PhotometryRecording={'Photometry','DbleFibers','Isobestic405','RedChannel'};
    
    %plot photometry
    TaskParameters.GUI.TimeMin=-1;
    TaskParameters.GUI.TimeMax=15;
    TaskParameters.GUI.NidaqMin=-5;
    TaskParameters.GUI.NidaqMax=10;
    TaskParameters.GUI.SidePokeIn=1;
	TaskParameters.GUIMeta.SidePokeIn.Style='checkbox';
    TaskParameters.GUI.SidePokeLeave=1;
	TaskParameters.GUIMeta.SidePokeLeave.Style='checkbox';
    TaskParameters.GUI.RewardDelivery=1;
	TaskParameters.GUIMeta.RewardDelivery.Style='checkbox';
    
    TaskParameters.GUI.BaselineBegin=0.1;
    TaskParameters.GUI.BaselineEnd=0.8;
    TaskParameters.GUIPanels.PhotometryPlot={'TimeMin','TimeMax','NidaqMin','NidaqMax','SidePokeIn','SidePokeLeave','RewardDelivery',...
         'BaselineBegin','BaselineEnd'};
    
    %% Nidaq and Photometry
    TaskParameters.GUI.PhotometryVersion=1;
    TaskParameters.GUI.Modulation=1;
    TaskParameters.GUIMeta.Modulation.Style='checkbox';
    TaskParameters.GUIMeta.Modulation.String='Auto';
	TaskParameters.GUI.NidaqDuration=10;
    TaskParameters.GUI.NidaqSamplingRate=6100;
    TaskParameters.GUI.DecimateFactor=610;
    TaskParameters.GUI.LED1_Name='Fiber1 470-A1';
    TaskParameters.GUIMeta.LED1_Name.Style='edittext';
    TaskParameters.GUI.LED1_Amp=1;
    TaskParameters.GUI.LED1_Freq=211;
    TaskParameters.GUI.LED2_Name='Fiber1 405 / 565';
    TaskParameters.GUIMeta.LED2_Name.Style='edittext';
    TaskParameters.GUI.LED2_Amp=5;
    TaskParameters.GUI.LED2_Freq=531;
    TaskParameters.GUI.LED1b_Name='Fiber2 470-mPFC';
    TaskParameters.GUIMeta.LED1b_Name.Style='edittext';
    TaskParameters.GUI.LED1b_Amp=2;
    TaskParameters.GUI.LED1b_Freq=531;

    TaskParameters.GUIPanels.PhotometryNidaq={'PhotometryVersion','Modulation','NidaqDuration',...
                            'NidaqSamplingRate','DecimateFactor',...
                            'LED1_Name','LED1_Amp','LED1_Freq',...
                            'LED2_Name','LED2_Amp','LED2_Freq',...
                            'LED1b_Name','LED1b_Amp','LED1b_Freq'};
                        
    %% rig-specific
    TaskParameters.GUI.nidaqDev='Dev2';
    TaskParameters.GUIMeta.nidaqDev.Style='edittext';
        
    TaskParameters.GUIPanels.PhotometryRig={'nidaqDev'};
    
    TaskParameters.GUITabs.General = {'General','StimDelay','SidePorts','Reward'};
    TaskParameters.GUITabs.Photometry = {'PhotometryRecording','PhotometryNidaq','PhotometryPlot','PhotometryRig'};
    TaskParameters.GUITabs.Video = {'VideoGeneral'};
        
    TaskParameters.GUI = orderfields(TaskParameters.GUI);
    TaskParameters.Figures.OutcomePlot.Position = [200, 200, 1000, 400];
end

TaskParameters.GUI.StimDelay = TaskParameters.GUI.StimDelayMin;
TaskParameters.GUI.FeedbackDelay = TaskParameters.GUI.FeedbackDelayMin;
BpodParameterGUI('init', TaskParameters);

%% Initializing data (trial type) vectors

BpodSystem.Data.Custom.Baited.Left = true;
BpodSystem.Data.Custom.Baited.Right = true;
BpodSystem.Data.Custom.BlockNumber = 1;
BpodSystem.Data.Custom.LeftHi = rand>.5;
BpodSystem.Data.Custom.BlockLen = drawBlockLen();

BpodSystem.Data.Custom.ChoiceLeft = NaN;
BpodSystem.Data.Custom.EarlyCout(1) = false;
BpodSystem.Data.Custom.EarlySout(1) = false;
BpodSystem.Data.Custom.Grace(1) = false;
BpodSystem.Data.Custom.Rewarded = false;
BpodSystem.Data.Custom.StimDelay(1) = NaN;
BpodSystem.Data.Custom.FeedbackTime(1) = NaN;
BpodSystem.Data.Custom.RewardMagnitude(1,1:2) = TaskParameters.GUI.rewardAmount;

%server data
BpodSystem.Data.Custom.Rig = getenv('computername');
[~,BpodSystem.Data.Custom.Subject] = fileparts(fileparts(fileparts(fileparts(BpodSystem.DataPath))));

BpodSystem.Data.Custom = orderfields(BpodSystem.Data.Custom);

%% Set up PulsePal
load PulsePalParamFeedback.mat
BpodSystem.Data.Custom.PulsePalParamFeedback=PulsePalParamFeedback;
BpodSystem.SoftCodeHandlerFunction = 'SoftCodeHandler';
if ~BpodSystem.EmulatorMode
    ProgramPulsePal(BpodSystem.Data.Custom.PulsePalParamFeedback);
end

%% Initialize plots
temp = SessionSummary();
for i = fieldnames(temp)'
    BpodSystem.GUIHandles.(i{1}) = temp.(i{1});
end
clear temp
% BpodNotebook('init');

%% NIDAQ Initialization and Plots
if TaskParameters.GUI.Photometry
if (TaskParameters.GUI.DbleFibers+TaskParameters.GUI.Isobestic405+TaskParameters.GUI.RedChannel)*TaskParameters.GUI.Photometry >1
    disp('Error - Incorrect photometry recording parameters')
    return
end

Nidaq_photometry('ini');

FigNidaq1=Online_NidaqPlot('ini','470');
if TaskParameters.GUI.DbleFibers || TaskParameters.GUI.Isobestic405 || TaskParameters.GUI.RedChannel
    FigNidaq2=Online_NidaqPlot('ini','channel2');
end
end

%% Main loop
RunSession = true;
iTrial = 1;

while RunSession
    TaskParameters = BpodParameterGUI('sync', TaskParameters);
    
    sma = stateMatrix();
    SendStateMatrix(sma);
    
    %% NIDAQ Get nidaq ready to start
    if TaskParameters.GUI.Photometry
    Nidaq_photometry('WaitToStart');
    end
    %% Run Trial
    RawEvents = RunStateMatrix;
    
    %% NIDAQ Stop acquisition and save data in bpod structure
    if TaskParameters.GUI.Photometry
    Nidaq_photometry('Stop');
    [PhotoData,Photo2Data]=Nidaq_photometry('Save');
    BpodSystem.Data.NidaqData{iTrial}=PhotoData;
    if TaskParameters.GUI.DbleFibers || TaskParameters.GUI.RedChannel
        BpodSystem.Data.Nidaq2Data{iTrial}=Photo2Data;
    end
    end
    
    %% Bpod save
    if ~isempty(fieldnames(RawEvents))
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents);
        SaveBpodSessionData;
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.BeingUsed == 0
        return
    end
    
    %% Update fields
    updateCustomDataFields(iTrial)
  
    BpodSystem.GUIHandles = SessionSummary(BpodSystem.Data, BpodSystem.GUIHandles, iTrial);
    
    %% Plot Photo Data
    
    if TaskParameters.GUI.Photometry
            
        Alignments = {[],[],[]};
         %Choice

        if ~isnan(BpodSystem.Data.Custom.ChoiceLeft(iTrial)) %Choice
            Alignments{1} = 'start_'; %a little dangerous since generic state name start_ but so far (3/2019) only used for choice
        end

        %Leave     
        if ~isnan(BpodSystem.Data.Custom.ChoiceLeft(iTrial)) && BpodSystem.Data.Custom.Rewarded(iTrial)==0
            Alignments{2} = 'ITI';
        end

        %Reward
        if  BpodSystem.Data.Custom.Rewarded(iTrial)==1
            Alignments{3} = 'water_';
        end
        
        
        
        for k =1:length(Alignments)
             align = Alignments{k};
             if ~isempty(align)
            [currentNidaq1, rawNidaq1]=Online_NidaqDemod(PhotoData(:,1),nidaq.LED1,TaskParameters.GUI.LED1_Freq,TaskParameters.GUI.LED1_Amp,align);
            FigNidaq1=Online_NidaqPlot('update',[],FigNidaq1,currentNidaq1,rawNidaq1,k);
            
            if TaskParameters.GUI.Isobestic405 || TaskParameters.GUI.DbleFibers || TaskParameters.GUI.RedChannel
                if TaskParameters.GUI.Isobestic405
                    [currentNidaq2, rawNidaq2]=Online_NidaqDemod(PhotoData(:,1),nidaq.LED2,TaskParameters.GUI.LED2_Freq,TaskParameters.GUI.LED2_Amp,align);
                elseif TaskParameters.GUI.RedChannel
                    [currentNidaq2, rawNidaq2]=Online_NidaqDemod(Photo2Data(:,1),nidaq.LED2,TaskParameters.GUI.LED2_Freq,TaskParameters.GUI.LED2_Amp,align);
                elseif TaskParameters.GUI.DbleFibers
                    [currentNidaq2, rawNidaq2]=Online_NidaqDemod(Photo2Data(:,1),nidaq.LED2,TaskParameters.GUI.LED1b_Freq,TaskParameters.GUI.LED1b_Amp,align);
                end
                FigNidaq2=Online_NidaqPlot('update',[],FigNidaq2,currentNidaq2,rawNidaq2,k);
            end
             end%if non-empty align
        end%alignment loop
    end%if photometry
    
    iTrial = iTrial + 1;    
end
%% photometry check
if TaskParameters.GUI.Photometry
    thismax=max(PhotoData(TaskParameters.GUI.NidaqSamplingRate:TaskParameters.GUI.NidaqSamplingRate*2,1))
    if thismax>4 || thismax<0.3
        disp('WARNING - Something is wrong with fiber #1 - run check-up! - unpause to ignore')
        BpodSystem.Pause=1;
        HandlePauseCondition;
    end
    if TaskParameters.GUI.DbleFibers
        thismax=max(Photo2Data(TaskParameters.GUI.NidaqSamplingRate:TaskParameters.GUI.NidaqSamplingRate*2,1))
        if thismax>4 || thismax<0.3
            disp('WARNING - Something is wrong with fiber #2 - run check-up! - unpause to ignore')
            BpodSystem.Pause=1;
            HandlePauseCondition;
        end
    end
end

end