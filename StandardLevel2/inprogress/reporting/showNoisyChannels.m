   function showNoisyChannels(channels, channelLocations, ...
                       channelInformation, referenceChannels, dname, msg)
        bad_corr_sym = 'c';
        bad_amp_sym = '+';
        bad_noise_sym = 'x';
        bad_ransac_sym = '?';
        chanlocs = channelLocations;
        chaninfo = channelInformation;
        
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
        
        good_chans = setdiff(referenceChannels, (results.noisyChannels)');
        for j = good_chans
            chanlocs(j).labels = ' ';
        end
        
        % Plot the robust channel deviation after rereferencing
        echans = chanlocs(referenceChannels);
        try
            amplitude = results.robustChannelDeviation(referenceChannels);
            tString = ['Robust channel deviation (' msg '): ' dname];
            figure('Name', tString)
            topoplot(amplitude, echans, 'style', 'map', ...
                'electrodes', 'ptslabels','chaninfo',chaninfo);
            title(tString, 'Interpreter', 'none')
            colorbar
        catch mex
            warning(['Robust channel deviation ' dname ' topoplot failed: ' ...
                mex.message]);
        end
        
        % Plot the high frequency noise
        try
            znoise = results.zscoreHFNoise(referenceChannels);
            tString = ['Noise z-score (' msg '): ' dname];
            figure('Name', tString)
            topoplot(znoise, echans, 'style', 'map', ...
                'electrodes', 'ptslabels', 'chaninfo', chaninfo);
            title(tString, 'Interpreter', 'none')
            colorbar
        catch mex
            warning(['Znoise ' dname ' topoplot failed: ' ...
                mex.message]);
        end
        
        
        % Plot the median correlation among windows by channel
        try
            chancor = results.medianMaxCorrelation(referenceChannels);
            tString = ['Median max correlation (' msg '): ' dname];
            figure('Name', tString)
            topoplot(chancor, echans, 'style', 'map', ...
                'electrodes', 'ptslabels','chaninfo',chaninfo, ...
                'maplimits', [0.4, 1]);
            title(tString, 'Interpreter', 'none')
            colorbar
        catch mex
            warning(['Median max correlation ' dname ' topoplot failed: ' ...
                mex.message]);
        end
        
        % Plot the fraction of bad ransac windows
        try
            flagged_frac = results.ransacBadWindowFraction(referenceChannels);
            tString = ['Fraction of ransac windows with low correlation (' msg '): ' dname];
            figure('Name', tString)
            topoplot(flagged_frac, echans, 'style', 'map', ...
                'electrodes', 'ptslabels','chaninfo',chaninfo, ...
                'maplimits', [0.0, 1]);
            title(tString, 'Interpreter', 'none')
            colorbar
        catch mex
            warning(['Ransac correlation ' dname ' topoplot failed: ' ...
                mex.message]);
        end
        
    end