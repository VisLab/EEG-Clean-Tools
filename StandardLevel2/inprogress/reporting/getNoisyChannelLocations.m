function echans = getNoisyChannelLocations( results, channelLocations )
        bad_corr_sym = 'c';
        bad_amp_sym = '+';
        bad_noise_sym = 'x';
        bad_ransac_sym = '?';
        chanlocs = channelLocations;
        
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
end

