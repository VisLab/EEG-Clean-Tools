function compareChannelIndicators(report1, report2)

    headColor = [0.7, 0.7, 0.7];
    elementColor = [0, 0, 0];
    [echans1, chaninfo1, refchans1] = getChannelInformation(report1);
    [echans2, chaninfo2, refchans2] = getChannelInformation(report2);
  
    % Plot the robust channel deviation after rereferencing
    results1 = report1.results;
    results2 = report2.results;
    try
        amplitude1 = results1.robustChannelDeviation(refchans1);
        amplitude2 = results2.robustChannelDeviation(refchans2);
        scale = max(max(abs(amplitude1)), max(abs(amplitude2)));
        tString1 = ['Robust channel deviation (' report1.msg '): ' report1.name];
        plotScalpMap(amplitude1, echans1, 'cubic', 1, headColor, ...
             elementColor, [-scale, scale], chaninfo1.nosedir, tString1)
        
        tString2 = ['Robust channel deviation (' report2.msg '): ' report2.name];
        plotScalpMap(amplitude2, echans2, 'cubic', 1, headColor, ...
             elementColor, [-scale, scale], chaninfo2.nosedir, tString2)
    catch mex
        warning(['Robust channel map plot failed: ' mex.message]);
    end

    %Plot the high frequency noise
    try
        znoise1 = report1.results.zscoreHFNoise(refchans1);
        znoise2 = report2.results.zscoreHFNoise(refchans2);
        scale = max(max(abs(znoise1)), max(abs(znoise2)));
        tString1 = ['Noise z-score (' report1.msg '): ' report1.name];
        plotScalpMap(znoise1, echans1, 'cubic', 1, headColor, ...
             elementColor, [-scale, scale], chaninfo1.nosedir, tString1)
        tString2 = ['Noise z-score (' report2.msg '): ' report2.name];
        plotScalpMap(znoise2, echans2, 'cubic', 1, headColor, ...
             elementColor, [-scale, scale], chaninfo2.nosedir, tString2)
    catch mex
        warning(['Znoise map plot failed: ' mex.message]);
    end

    % Plot the median correlation among windows by channel
    try
        chancor1 = results1.medianMaxCorrelation(refchans1);
        tString1 = ['Median max correlation (' report1.msg '): ' report1.name];
        plotScalpMap(chancor1, echans1, 'cubic', 1, headColor, ...
             elementColor, [report1.corthresh, 1],...
             chaninfo1.nosedir, tString1)
        chancor2 = results2.medianMaxCorrelation(refchans2);
        tString2 = ['Median max correlation (' report2.msg '): ' report2.name];
        plotScalpMap(chancor2, echans2, 'cubic', 1, headColor, ...
             elementColor, [report2.corthresh, 1],...
             chaninfo2.nosedir, tString2)
    catch mex
        warning(['Median max correlation topoplot failed: ' ...
            mex.message]);
    end

    % Plot the fraction of ransac unbroken windows after interpolation
    try
        flagged_frac1 = results1.ransacBadWindowFraction(refchans1);
        tString1 = ['Fraction of ransac windows with low correlation (' report1.msg '): ' report1.name];
        plotScalpMap(flagged_frac1, echans1, 'cubic', 1, headColor, ...
              elementColor, [0, 1], chaninfo1.nosedir, tString1)
        flagged_frac2 = results2.ransacBadWindowFraction(refchans2);
        tString2 = ['Fraction of ransac windows with low correlation (' report2.msg '): ' report2.name];
        plotScalpMap(flagged_frac2, echans2, 'cubic', 1, headColor,...
              elementColor, [0, 1], chaninfo2.nosedir, tString2)
    catch mex
        warning(['Ransac fraction map failed: ' mex.message]);
    end

    function [echans, chaninfo, refchans] = getChannelInformation(report)
        bad_corr_sym = 'c';
        bad_amp_sym = '+';
        bad_noise_sym = 'x';
        bad_ransac_sym = '?';
        chanlocs = report.chanlocs;
        chaninfo = report.chaninfo;
        refchans = report.refchans;
        results = report.results;
        % Set the bad channel labels
        for j = results.badChannelsFromCorrelation
            chanlocs(j).labels = [chanlocs(j).labels bad_corr_sym];
        end
        for j = results.badChannelsFromDeviation
            chanlocs(j).labels = [chanlocs(j).labels bad_amp_sym];
        end
        
        for j = results.badChannelsFromHFNoise
            chanlocs(j).labels = [chanlocs(j).labels bad_noise_sym];
        end
        
        for j = results.badChannelsFromRansac
            chanlocs(j).labels = [chanlocs(j).labels bad_ransac_sym];
        end
        
        good_chans = setdiff(refchans, (results.noisyChannels)');
        for j = good_chans
            chanlocs(j).labels = ' ';
        end
        echans = chanlocs(refchans);
    end
end
