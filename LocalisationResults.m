
classdef LocalisationResults < handle
    
    properties
        
        sFolder_Data;
        sFolder_Functions = 'functions';
        sFolder_Output = 'output';
        
        hFig_Main;
        
        sFileName = '';
        
        hPanel_Graphic;
        hPanel_Config;
        hPanel_Control;
        
        hAxes_Main;
        hText_Calculating;
        
        hDropDown_ArrayName;
        hDropDown_SRC;
        hDropDown_RIR;
        hDropDown_Len;
        hDropDown_FFTLen;
        hDropDown_SNR;
        hDropDown_Sensors;
        
        hText_ArrayName;
        hText_SRC;
        hText_RIR;
        hText_Len;
        hText_FFTLen;
        hText_SNR;
        hText_Sensors;
        
        hText_Style;
        hText_Primary;
        hDropdown_Style;
        hDropdown_Primary;
        hButton_Print;
        hButton_Save;
        hButton_Folder;
        hDropdown_LinLog;
        
        sTitle_DropDown_ArrayName = 'Geometry:';
        sTitle_Dropdown_SRC = 'Source:';
        sTitle_Dropdown_RIR = 'Room:';
        sTitle_Dropdown_Len = 'Length:';
        sTitle_Dropdown_FFTLen = 'FFT:';
        sTitle_Dropdown_SNR = 'SNR:';
        sTitle_Dropdown_Sensors = '#Sensors:';
        sTitle_Button_Folder = 'Folder';
        
        sTitle_Dropdown_Style = 'Style:';
        sTitle_Dropdown_Primary = 'Primary:';
        sTitle_Button_Print = 'Print';
        sTitle_Button_Save = 'Save';
        cTitle_Option_Style = {'Boxplot', 'Mono'};
        cTitle_Option_Primary = {'Geometry', 'SNR', 'Room', 'Length', ...
            'FFT', 'Source', '#Sensors'};
        cTitle_Option_LogLin = {'Lin', 'Log'};
        
        
        cItems_ArrayName = {};
        cItems_SRC = {};
        cItems_RIR = {};
        cItems_Len = {};
        cItems_FFT = {};
        cItems_SNR = {};
        cItems_Sensors = {};
        
        sTitle_Calculating = 'Calculating';
        sTitle_NoData = 'Not enough Data available';
        sTitle_PanelGraphic = 'Graphic';
        sTitle_PanelConfig = 'Configuration';
        sTitle_PanelControl = 'Controls';
        
        sTitle_FigMain = 'LocalisationResults';
        
        nDivision_Horizontal = 20;
        nDivision_Vertical = 15;
        nTextHeight = 20;
        nTitleHeight = 20;
        nButtonHeight = 30;
        nButtonWidth = 76;
        nOffset_Vertical = 15;
        nPad_Axes = 10;
        
        nCalculatingWidth = 150;
        nCalculatingHeight = 20;
        
        vScreenSize;
        nHeight_FigMain = 480;
        nWidth_FigMain = 800;
        
        nHeight_PanelConfig = 300;
        nWidth_PanelGraphic;
        nHeight_PanelControl;
        nWidth_PanelControl;
        
        stPrint = struct( ...
            'Width', [6, 6]/2.54, ...
            'Height', [15, 3.5]/2.54, ...
            'AxesLineWidth', 0.75, ...
            'FontSize', 9, ...
            'LineWidth', 1.5, ...
            'MarkerSize', 8, ...
            'InvertHardcopy', 'on', ...
            'PaperUnits', 'inches', ...
            'DPI', 300, ...
            'MaxCharactersInLabel', 20);
        
        
        
    end
    
    methods
        
        function[obj] = LocalisationResults()
            
            addpath(genpath(obj.sFolder_Functions));
            
            set(0,'Units','Pixels') ;
            obj.vScreenSize = get(0, 'Screensize');
            
            obj.nWidth_PanelGraphic = obj.nWidth_FigMain - (obj.nButtonWidth*2 + 3*obj.nDivision_Horizontal);
            obj.nHeight_PanelConfig = obj.nHeight_FigMain - (4*obj.nButtonHeight + 5*obj.nDivision_Vertical);
            
            obj.nHeight_PanelControl = obj.nHeight_FigMain - obj.nHeight_PanelConfig;
            obj.nWidth_PanelControl = obj.nWidth_FigMain - obj.nWidth_PanelGraphic;
            
            obj.getDataFolder();
            obj.getItems();
            obj.createGUI();
            
        end
        
        function [] = createGUI(obj)
            
            obj.hFig_Main = uifigure();
            obj.hFig_Main.Position = [(obj.vScreenSize(3)-obj.nWidth_FigMain)/2,...
                (obj.vScreenSize(4)-obj.nHeight_FigMain)/2, obj.nWidth_FigMain, obj.nHeight_FigMain];
            obj.hFig_Main.Name = obj.sTitle_FigMain;
            obj.hFig_Main.Resize = 'Off';
            
            % Panels
            
            obj.hPanel_Graphic = uipanel('Parent', obj.hFig_Main);
            obj.hPanel_Graphic.Position = [1, 1, obj.nWidth_PanelGraphic, obj.nHeight_FigMain];
            obj.hPanel_Graphic.Title = obj.sTitle_PanelGraphic;
            
            obj.hPanel_Config = uipanel('Parent', obj.hFig_Main);
            obj.hPanel_Config.Position = [obj.nWidth_PanelGraphic+1, ...
                obj.nHeight_PanelControl+1, obj.nWidth_PanelControl, obj.nHeight_PanelConfig];
            obj.hPanel_Config.Title = obj.sTitle_PanelConfig;
            
            obj.hPanel_Control = uipanel('Parent', obj.hFig_Main);
            obj.hPanel_Control.Position = [obj.nWidth_PanelGraphic+1, ...
                1, obj.nWidth_PanelControl, obj.nHeight_PanelControl];
            obj.hPanel_Control.Title = obj.sTitle_PanelControl;
            
            
            %% Graphic
            
            
            obj.hAxes_Main = uiaxes('Parent', obj.hPanel_Graphic);
            obj.hAxes_Main.Units = 'Pixels';
            obj.hAxes_Main.Position = [obj.nPad_Axes,obj.nPad_Axes,obj.hPanel_Graphic.Position(3)-2*obj.nPad_Axes, obj.hPanel_Graphic.Position(4)-20-2*obj.nPad_Axes];
            obj.hAxes_Main.Visible = 'Off';
            
            obj.hText_Calculating = uilabel('Parent', obj.hPanel_Graphic);
            obj.hText_Calculating.Text = obj.sTitle_Calculating;
            obj.hText_Calculating.Position = [(obj.nWidth_PanelGraphic-obj.nCalculatingWidth)/2, ...
                (obj.nHeight_FigMain-obj.nCalculatingHeight)/2, obj.nCalculatingWidth, obj.nCalculatingHeight];
            obj.hText_Calculating.Visible = 'Off';
            
            
            %% Configuration
            
            
            % Text Labels
            
            obj.hText_Sensors = uilabel('Parent', obj.hPanel_Config);
            obj.hText_Sensors.Text = obj.sTitle_Dropdown_Sensors;
            obj.hText_Sensors.Position = [obj.nDivision_Horizontal, 2*obj.nDivision_Vertical+obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            obj.hText_FFTLen = uilabel('Parent', obj.hPanel_Config);
            obj.hText_FFTLen.Text = obj.sTitle_Dropdown_FFTLen;
            obj.hText_FFTLen.Position = [obj.nDivision_Horizontal, 4*obj.nDivision_Vertical+2*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            obj.hText_RIR = uilabel('Parent', obj.hPanel_Config);
            obj.hText_RIR.Text = obj.sTitle_Dropdown_RIR;
            obj.hText_RIR.Position = [obj.nDivision_Horizontal, 6*obj.nDivision_Vertical+3*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            obj.hText_ArrayName = uilabel('Parent', obj.hPanel_Config);
            obj.hText_ArrayName.Text = obj.sTitle_DropDown_ArrayName;
            obj.hText_ArrayName.Position = [obj.nDivision_Horizontal, 8*obj.nDivision_Vertical+4*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            obj.hText_SRC = uilabel('Parent', obj.hPanel_Config);
            obj.hText_SRC.Text = obj.sTitle_Dropdown_SRC;
            obj.hText_SRC.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 4*obj.nDivision_Vertical+2*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            obj.hText_Len = uilabel('Parent', obj.hPanel_Config);
            obj.hText_Len.Text = obj.sTitle_Dropdown_Len;
            obj.hText_Len.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 6*obj.nDivision_Vertical+3*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            obj.hText_SNR = uilabel('Parent', obj.hPanel_Config);
            obj.hText_SNR.Text = obj.sTitle_Dropdown_SNR;
            obj.hText_SNR.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 8*obj.nDivision_Vertical+4*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nTextHeight];
            
            % Dropdown Menus
            
            obj.hDropDown_Sensors = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_Sensors.Items = obj.cItems_Sensors;
            obj.hDropDown_Sensors.Position = [obj.nDivision_Horizontal, 1*obj.nDivision_Vertical, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_Sensors.ValueChangedFcn = @obj.checkSelection;
            
            obj.hDropDown_FFTLen = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_FFTLen.Items = obj.cItems_FFT;
            obj.hDropDown_FFTLen.Position = [obj.nDivision_Horizontal, 3*obj.nDivision_Vertical+obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_FFTLen.ValueChangedFcn = @obj.checkSelection;
            
            obj.hDropDown_RIR = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_RIR.Items = obj.cItems_RIR;
            obj.hDropDown_RIR.Position = [obj.nDivision_Horizontal, 5*obj.nDivision_Vertical+2*obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_RIR.ValueChangedFcn = @obj.checkSelection;
            
            obj.hDropDown_ArrayName = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_ArrayName.Items = obj.cItems_ArrayName;
            obj.hDropDown_ArrayName.Position = [obj.nDivision_Horizontal, 7*obj.nDivision_Vertical+3*obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_ArrayName.ValueChangedFcn = @obj.checkSelection;
            
            obj.hDropDown_SRC = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_SRC.Items = obj.cItems_SRC;
            obj.hDropDown_SRC.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 3*obj.nDivision_Vertical+obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_SRC.ValueChangedFcn = @obj.checkSelection;
            
            obj.hDropDown_Len = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_Len.Items = obj.cItems_Len;
            obj.hDropDown_Len.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 5*obj.nDivision_Vertical+2*obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_Len.ValueChangedFcn = @obj.checkSelection;
            
            obj.hDropDown_SNR = uidropdown('Parent', obj.hPanel_Config);
            obj.hDropDown_SNR.Items = obj.cItems_SNR;
            obj.hDropDown_SNR.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 7*obj.nDivision_Vertical+3*obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropDown_SNR.ValueChangedFcn = @obj.checkSelection;
            
            
            %% Buttons
            
            
            obj.hButton_Folder = uibutton('Parent', obj.hPanel_Config);
            obj.hButton_Folder.Text = obj.sTitle_Button_Folder;
            obj.hButton_Folder.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 1*obj.nDivision_Vertical, obj.nButtonWidth, obj.nButtonHeight];
            obj.hButton_Folder.ButtonPushedFcn = @obj.callbackFolder;
          
            
            %% Controls
            
            % Lin/Log Dropdown
            obj.hDropdown_LinLog = uidropdown('Parent', obj.hPanel_Control);
            obj.hDropdown_LinLog.Items = obj.cTitle_Option_LogLin;
            obj.hDropdown_LinLog.Position = [obj.nDivision_Horizontal, 4*obj.nDivision_Vertical+2*obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            obj.hDropdown_LinLog.ValueChangedFcn = @obj.callbackLinLog;
            
            % Print Button
            obj.hButton_Print = uibutton('Parent', obj.hPanel_Control);
            obj.hButton_Print.Text = obj.sTitle_Button_Print;
            obj.hButton_Print.Position = [obj.nDivision_Horizontal, obj.nDivision_Vertical, obj.nButtonWidth, obj.nButtonHeight];
            obj.hButton_Print.ButtonPushedFcn = @obj.callbackPlot;
            
            % Save Button
            obj.hButton_Save = uibutton('Parent', obj.hPanel_Control);
            obj.hButton_Save.Text = obj.sTitle_Button_Save;
            obj.hButton_Save.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, obj.nDivision_Vertical, obj.nButtonWidth, obj.nButtonHeight];
            obj.hButton_Save.ButtonPushedFcn = @obj.callbackSaveGraph;
            
            % Style Dropdown
            obj.hDropdown_Style = uidropdown('Parent', obj.hPanel_Control);
            obj.hDropdown_Style.Items = obj.cTitle_Option_Style;
            obj.hDropdown_Style.Position = [obj.nDivision_Horizontal, 2*obj.nDivision_Vertical+obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            
            % Style Primary
            obj.hDropdown_Primary = uidropdown('Parent', obj.hPanel_Control);
            obj.hDropdown_Primary.Items = obj.cTitle_Option_Primary;
            obj.hDropdown_Primary.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 2*obj.nDivision_Vertical+obj.nButtonHeight, obj.nButtonWidth, obj.nButtonHeight];
            
            % Label Style
            obj.hText_Style = uilabel('Parent', obj.hPanel_Control);
            obj.hText_Style.Text = obj.sTitle_Dropdown_Style;
            obj.hText_Style.Position = [obj.nDivision_Horizontal, 3*obj.nDivision_Vertical+2*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nButtonHeight];
            
            % Label Primary
            obj.hText_Primary = uilabel('Parent', obj.hPanel_Control);
            obj.hText_Primary.Text = obj.sTitle_Dropdown_Primary;
            obj.hText_Primary.Position = [2*obj.nDivision_Horizontal+obj.nButtonWidth, 3*obj.nDivision_Vertical+2*obj.nButtonHeight-obj.nOffset_Vertical, obj.nButtonWidth, obj.nButtonHeight];
            
        end
        
        function [] = callbackFolder(obj, ~, ~)
           obj.sFolder_Data = uigetdir();
           obj.getItems();
        end
        
        function [] = getItems(obj)
            
            stDir = dir(obj.sFolder_Data);
            stDir(1:2) = [];
            nDir = length(stDir);
            
            vErase = [];
            for iDir = 1:nDir
                if stDir(iDir).isdir
                    vErase = [vErase, iDir];
                end
            end
            stDir(vErase) = [];
            nDir = length(stDir);
            
            for iDir = 1:nDir
                
                cResultData = regexp(stDir(iDir).name, ...
                    'Results_ARRAY(\w)*_SRC(\w)_RIR(\w)_LEN(\w)*_FFT(\w)*_SNR(\w)*_SENSORS(\w)*', 'tokens');
                
                if length(cResultData{1}) ~= 7
                    obj.setNoDataAvailable();
                    break; 
                end
                
                sResult_ArrayName = cResultData{1}{1};
                sResult_SRC = cResultData{1}{2};
                sResult_RIR = cResultData{1}{3};
                sResult_Len = cResultData{1}{4};
                sResult_FFTLen = cResultData{1}{5};
                sResult_SNR = cResultData{1}{6};
                sResult_Sensors = cResultData{1}{7};
                
                if sResult_SRC
                    sResult_SRC = 'Real';
                else
                    sResult_SRC = 'Arti';
                end
                
                if sResult_RIR
                    sResult_RIR = 'RIR';
                else
                    sResult_RIR = 'Delay';
                end
                
                if isempty(obj.cItems_ArrayName)
                    obj.cItems_ArrayName{end+1} = sResult_ArrayName;
                elseif ~contains(obj.cItems_ArrayName, sResult_ArrayName)
                    obj.cItems_ArrayName{end+1} = sResult_ArrayName;
                end
                
                if isempty(obj.cItems_SRC)
                    obj.cItems_SRC{end+1} = sResult_SRC;
                elseif ~contains(obj.cItems_SRC, sResult_SRC)
                    obj.cItems_SRC{end+1} = sResult_SRC;
                end
                
                if isempty(obj.cItems_RIR)
                    obj.cItems_RIR{end+1} = sResult_RIR;
                elseif ~contains(obj.cItems_RIR, sResult_RIR)
                    obj.cItems_RIR{end+1} = sResult_RIR;
                end
                
                if isempty(obj.cItems_Len)
                    obj.cItems_Len{end+1} = sResult_Len;
                elseif ~contains(obj.cItems_Len, sResult_Len)
                    obj.cItems_Len{end+1} = sResult_Len;
                end
                
                if isempty(obj.cItems_FFT)
                    obj.cItems_FFT{end+1} = sResult_FFTLen;
                elseif ~contains(obj.cItems_FFT, sResult_FFTLen)
                    obj.cItems_FFT{end+1} = sResult_FFTLen;
                end
                
                if isempty(obj.cItems_SNR)
                    obj.cItems_SNR{end+1} = sResult_SNR;
                elseif ~contains(obj.cItems_SNR, sResult_SNR)
                    obj.cItems_SNR{end+1} = sResult_SNR;
                end
                
                if isempty(obj.cItems_Sensors)
                    obj.cItems_Sensors{end+1} = sResult_Sensors;
                elseif ~contains(obj.cItems_Sensors, sResult_Sensors)
                    obj.cItems_Sensors{end+1} = sResult_Sensors;
                end
                
            end
            
            
        end
        
        function [] = getDataFolder(obj)
            
            %             obj.sFolder_Data = uigetdir();
            obj.sFolder_Data = 'F:\Dropbox\VIWER-S\[2019] VIWER_LocalisationExperiment\output';
            
        end
        
        function [] = callbackPlot(obj, ~, ~)
            if obj.checkPlot()
                obj.plotFigure();
            end
        end
        
        function bCheckFile = checkFile(obj, sFileName)
            
            if exist(fullfile(obj.sFolder_Data, sFileName), 'file') == 2
                bCheckFile = true;
                obj.sFileName = sFileName;
            else
                bCheckFile = false;
                obj.sFileName = '';
            end
            
        end
        
        function [] = callbackLinLog(obj, ~, ~)
            if strcmp(obj.hDropdown_LinLog.Value, 'Log')
                obj.hAxes_Main.YScale = 'log';
            else
                obj.hAxes_Main.YScale = 'linear';
            end
        end
        
        function bCheck = checkPlot(obj)
            bCheck = true;
        end
        
        function [] = plotFigure(obj)
            
            sPrimary = obj.hDropdown_Primary.Value;
            
            switch(sPrimary)
                
                case 'Geometry'
                    vNum_Base = length(obj.cItems_ArrayName);
                case 'SNR'
                    vNum_Base = length(obj.cItems_SNR);
                case 'Room'
                    vNum_Base = length(obj.cItems_RIR);
                case 'Length'
                    vNum_Base = length(obj.cItems_Len);
                case 'FFT'
                    vNum_Base = length(obj.cItems_FFT);
                case 'Source'
                    vNum_Base = length(obj.cItems_SRC);
                case '#Sensors'
                    vNum_Base = length(obj.cItems_Sensors);
            end
            
            stData = obj.getData();
            
            stRMSE = obj.calculateRMSE_Mono(stData);
            stRMSE = obj.reformatStructToVectors(stRMSE);
            
            
            obj.hAxes_Main.NextPlot = 'ReplaceAll';
            plot(obj.hAxes_Main, stRMSE.GroundTruth, stRMSE.DiagonalUnloading);
            obj.hAxes_Main.NextPlot = 'Add';
            plot(obj.hAxes_Main, stRMSE.GroundTruth, stRMSE.SRPPHAT);
            
            obj.hAxes_Main.XTick = stRMSE.GroundTruth;
            obj.hAxes_Main.XTickLabel = stRMSE.GroundTruth/pi*180;
            obj.hAxes_Main.XLim = [-5/180*pi, stRMSE.GroundTruth(end)+5/180*pi];
            obj.hAxes_Main.Box = 'On';
            obj.hAxes_Main.XGrid = 'On';
            obj.hAxes_Main.YGrid = 'On';
            obj.hAxes_Main.Title.String = 'RMSE of different Localisation Algorithms';
            obj.hAxes_Main.XLabel.String = 'Angle [°]';
            obj.hAxes_Main.YLabel.String = 'RMSE [°]';
            
            obj.callbackLinLog();
            
            
            hLegend = legend(obj.hAxes_Main);
            hLegend.Location = 'NorthEast';
            hLegend.String = {'Diagonal Unloading', 'SRP-PHAT'};
            

            
        end
        
        function [bCheck] = checkSelection(obj, ~, ~)
            
            if obj.checkFile(obj.getFileName)
                obj.hButton_Print.Enable = 'On';
                obj.hAxes_Main.Visible = 'On';
                obj.hText_Calculating.Visible = 'Off';
                obj.plotFigure();
                bCheck = true;
            else
                obj.setNoDataAvailable();
                bCheck = false;
            end
            
        end
        
        function stOut = reformatStructToVectors(obj, stIn)
           
            nEntries = length(stIn);
            vTmp_DU = zeros(nEntries, 1);
            vTmp_SRPPHAT = zeros(nEntries, 1);
            vTmp_GroundTruth = zeros(nEntries, 1);
            
            for iEntry = 1:nEntries
                vTmp_DU(iEntry) = stIn(iEntry).DiagonalUnloading;
                vTmp_SRPPHAT(iEntry) = stIn(iEntry).SRPPHAT;
                vTmp_GroundTruth(iEntry) = stIn(iEntry).GroundTruth;
            end
            
            stOut.GroundTruth = vTmp_GroundTruth;
            stOut.DiagonalUnloading = vTmp_DU;
            stOut.SRPPHAT = vTmp_SRPPHAT;
            
        end
        
        function [] = setNoDataAvailable(obj)
            obj.hButton_Print.Enable = 'Off';
            obj.hAxes_Main.Visible = 'Off';
            obj.hText_Calculating.Text = obj.sTitle_NoData;
            obj.hText_Calculating.Visible = 'On';
        end
        
        function sFileName = getFileName(obj)
            if strcmp(obj.hDropDown_SRC.Value, 'Real')
                sSRC = '1';
            else
                sSRC = '0';
            end
            
            if strcmp(obj.hDropDown_RIR.Value, 'RIR')
                sRIR = '1';
            else
                sRIR = '0';
            end
            
            sFileName = sprintf('Results_ARRAY%s_SRC%s_RIR%s_LEN%s_FFT%s_SNR%s_SENSORS%s.mat', ...
                obj.hDropDown_ArrayName.Value, sSRC, ...
                sRIR, obj.hDropDown_Len.Value, ...
                obj.hDropDown_FFTLen.Value, obj.hDropDown_SNR.Value, ...
                obj.hDropDown_Sensors.Value);
        end
        
        function stData = getData(obj)
            
            obj.sFileName = obj.getFileName();
            tmp = load(fullfile(obj.sFolder_Data, obj.sFileName));
            stData = tmp.value;
            
        end
        
        function stRMSE = calculateRMSE_Mono(obj, stData)
            
            stRMSE = struct('GroundTruth', [], 'DiagonalUnloading', [], 'SRPPHAT', []);
            
            nEntries = length(stData);
            for iEntry = 1:nEntries
                stRMSE(iEntry).GroundTruth =  stData(iEntry).GroundTruth;
                stRMSE(iEntry).DiagonalUnloading = rms(stData(iEntry).DiagonalUnloading - stData(iEntry).GroundTruth/pi*180);
                stRMSE(iEntry).SRPPHAT = rms(stData(iEntry).SRPPHAT - stData(iEntry).GroundTruth/pi*180);
            end
            
        end
        
        function cRMSE = calculateRMSE_Boxplot(obj)
            
        end
        
        function [] = callbackSaveGraph(obj, ~, ~)
            if true
               obj.saveGraph(); 
            end
        end
        
        function [] = saveGraph(obj)


            % Create new figure and new axes
            hFig_Save = figure();
            hFig_Save.Visible = 'Off';
            axNew = axes; 
            % Copy all objects from UIAxes to new axis
            copyobj(obj.hAxes_Main.Children, axNew)
            % Save all parameters of the UIAxes
            uiAxParams = get(obj.hAxes_Main);
            uiAxParamNames = fieldnames(uiAxParams); 
            % Get list of editable params in new axis
            editableParams = fieldnames(set(axNew)); 
            % Remove the UIAxes params that aren't editable in the new axes (add others you don't want)
            badFields = uiAxParamNames(~ismember(uiAxParamNames, editableParams)); 
            badFields = [badFields; 'Parent'; 'Children'; 'XAxis'; 'YAxis'; 'ZAxis';'Position';'OuterPosition']; 
            uiAxGoodParams = rmfield(uiAxParams,badFields); 
            % set editable params on new axes
            set(axNew, uiAxGoodParams)
                
                nWidth_Situations = 6/2.54;
                nHeight_Situations = 3.5/2.54;

                tmp_pos = get(hFig_Save, 'Position');
                hFig_Save.Position = [tmp_pos(1), tmp_pos(2), ...
                    nWidth_Situations*obj.stPrint.DPI, nHeight_Situations*obj.stPrint.DPI];
                set(axNew, 'FontSize', obj.stPrint.FontSize, ...
                    'LineWidth', 1);
                hFig_Save.InvertHardcopy = obj.stPrint.InvertHardcopy;
                hFig_Save.PaperUnits = 'inches';
                tmp_papersize = hFig_Save.PaperSize;
                tmp_left = (tmp_papersize(1) - nWidth_Situations)/2;
                tmp_bottom = (tmp_papersize(2) - nHeight_Situations)/2;
                tmp_figuresize = [tmp_left, tmp_bottom, nWidth_Situations, ...
                    nHeight_Situations];
                hFig_Save.PaperPosition = tmp_figuresize;
                
%                 % Set new axis params
%             allf = fieldnames(uiAxGoodParams); 
%             for i = 1:length(allf)
%                 fprintf('Property #%d: %s\n', i, allf{i});
%                 set(axNew, allf{i}, uiAxGoodParams.(allf{i}))
%             end

                export_fig([obj.sFolder_Output, filesep, obj.sFileName, '.pdf'], '-native');
            
        
        end
        
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

% End of file