%%
ess2Dir = 'N:\\ARLAnalysis\\NCTU\Level2\\session\\5\\';
eesEEG = 'eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_5_subject_1_task_motionless_s01_060926_1n_recording_1.set';
EEG = pop_loadset([ess2Dir eesEEG]);

%%
publishLevel2Report(EEG, ess2Dir, 'report.pdf');