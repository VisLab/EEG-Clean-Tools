%% File list
fileList = { ...
    'N:\\ARLAnalysis\\VEPStandardLevel2A\\vep_03.set'; ...
    'N:\\ARLAnalysis\\VEPStandardLevel2A\\vep_15.set'; ....=
    'N:\\ARLAnalysis\\NCTU\\Level2A\\session\\67\\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_67_subject_1_task_motionless_s54_081209n_recording_1.set'; ...
    'N:\\ARLAnalysis\\NCTU\\Level2A\\session\\79\\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_79_subject_1_task_motion_s77_120504m_recording_1.set'; ...
    'N:\\ARLAnalysis\\NCTU\\Level2A\\session\\80\\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_80_subject_1_task_motion_s80_120522m_recording_1.set' ...
    };

%% Plot the cummulative distribution
colors = [0, 0, 0; 1, 0, 0; 0, 1, 0];

for k = 1:length(fileList)
    load(fileList{k}, '-mat');
    noisyParameters = EEG.etc.noisyParameters;
    reference = noisyParameters.reference;
    original = reference.noisyOutOriginal;
    referenced = reference.noisyOut;
    referenceChannels = reference.referenceChannels;
    before = original.maximumCorrelations(referenceChannels, :);
    after = referenced.maximumCorrelations(referenceChannels, :);
    legendStrings = {['Before [mean=' num2str(mean(before(:)), 2) ']'], ...
                     ['After [mean=' num2str(mean(after(:)), 2) ']']};
    items = {before(:), after(:)};
    thresholdName = 'Maximum correlation';
    theTitle = {char(noisyParameters.name); char([thresholdName ' distribution'])};
    figure('Name', theTitle{1}, 'Color', [1, 1, 1])
    set(gca, 'XLim', [0.4, 1], 'XLimMode', 'manual', ...
        'YLim', [0, 1], 'YLimMode', 'manual', ...
        'YTickMode', 'manual', 'YTick', [0 0.2 0.4 0.6 0.8 1], ...
        'YTickLabelMode', 'manual', 'YTickLabel', ...
        {'', '0.2', '0.4', '0.6', '0.8', '1'});
    hold on
    for j = 1:length(items)
        [f, x] = ecdf(items{j}(:));
        plot(x, f, 'Color', colors(j, :), 'LineWidth', 2)
    end
    xg = xlabel('Maximum abs correlation');
    yg = ylabel('Cumulative probability');
    set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
    set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
   % title(theTitle, 'Interpreter', 'None')
    legend(legendStrings(1:length(items)), 'Location', 'NorthWest')
    
    hold off
    box on
end
               