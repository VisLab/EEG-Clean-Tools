function noiseData = generateTestNoise(frames, fractionBad, deviation)
% Generates noise data to be added.
noiseFrames = round(frames*fractionBad);
noiseData = [random('normal', 0, deviation, [1, noiseFrames]) ...
             zeros(1, frames - noiseFrames)];
