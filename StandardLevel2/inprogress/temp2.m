%%
noise = [beforeNoise(:), afterNoise(:), afterNoiseRel(:)];
figure
normplot(noise)
title('Noise score normplot')
legend('before', 'after', 'rel')
%%
fprintf('Fraction before > 3: %g\n', sum(noise(:, 1) > 5)/size(noise, 1));
fprintf('Fraction after > 3: %g\n', sum(noise(:, 2) > 5)/size(noise, 1));
%%
noiseLevels = [beforeNoiseLevels(:), afterNoiseLevels(:)];
figure
normplot(noise)
title('Noise levels normplot')
legend('before', 'after')
%%
figure
probplot('lognormal', noise);
title('Noise score lognormal')
legend('before', 'after', 'rel')
%%
figure
probplot('extreme value', noise);
title('Noise score extreme val')
legend('before', 'after', 'rel')
%%
dev = [beforeDeviationLevels(:), afterDeviationLevels(:)];

%%
figure
probplot('normal', dev);
title('Deviation values normal')
legend('before', 'after')
%%
figure
probplot('extreme value', dev);
title('Deviation values extreme')
legend('before', 'after')
%%
figure
probplot('lognormal', dev);
title('Deviation values lognormal')
legend('before', 'after')

%%
figure
probplot('weibull', dev);
title('Deviation values weibull')
legend('before', 'after')