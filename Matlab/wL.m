%% ========== Per-chip averaged uniformity + uniqueness ==========
clc; clear; close all;

% --- 1) LTSpice frequency sets for 5 chips (example: replace with yours) ---
fosc_chips = {
    [653173117.406,609050853.616,651549466.562,608350759.461,575921724.309,555134406.309,539308836.152,527120299.420,518399541.594,513368070.871,509781337.733,507207113.010,505345141.706,503987130.650,502710084.683,501560316.722],
    [609325852.286,609301597.539,554536684.057,527378219.409,513629427.558,507232502.973,503835154.151,502266106.873,501809813.631,501283945.98,500908838.664,500595375.654,500415246.134,500684633.668,500739553.187,500690307.004],
    [650943076.976,554078601.155,518749942.405,506705164.655,502439922.426,500868562.790,500344789.258,500106970.730,500039151.311,500013839.846,500004581.320,500001220.074,500000231.792,500000003.622,499999969.157,499999977.476],
    [607855845.080,526756605.411,506540608.840,501490868.003,500422964.566,499936226.970,500022755.289,499898243.026,499766331.926,499950554.600,499910977.726,499863062.565,499913820.373,499905199.638,499882846.418,499913757.523],
    [577116278.866,513764522.062,502530296.231,500558416.404,500429063.077,500082207.118,500281628.575,500228168.350,500187671.782,500268295.825,500193615.557,500229220.732,500209806.262,500216106.076,500214380.454,933827413.257]
};

numChips = length(fosc_chips);
numROs   = length(fosc_chips{1});
numChallenges = 100;      % Number of random challenges per iteration
numIterations = 100;      % Number of randomized trials (you asked for 100)

% Storage:
uniformity_all_iters = zeros(numIterations, numChips);  % each row = iteration, col = chip
uniqueness_all_iters  = zeros(numIterations,1);        % uniqueness averaged across pairs per iteration

rng('default');  % optional: for reproducibility change to 'shuffle' if you want different runs

for iter = 1:numIterations
    % generate the same challenge set for this iteration (or random each iter if you prefer)
    % Here we generate random challenge pairs as indices:
    % select two distinct ROs by random indices (from MUX halves if desired)
    % For simplicity, pick random distinct indices across full range:
    idxA = randi([1 numROs], numChallenges, 1);
    idxB = randi([1 numROs], numChallenges, 1);
    % ensure distinct (if equal, re-draw)
    same = (idxA == idxB);
    while any(same)
        idxB(same) = randi([1 numROs], sum(same), 1);
        same = (idxA == idxB);
    end

    responses = zeros(numChallenges, numChips);

    for chip = 1:numChips
        fosc = fosc_chips{chip};

        % --- add small random multiplicative noise (~ +/-2%) to model process variation
        noise = 1 + 0.02*randn(size(fosc));   % gaussian ±2%
        fosc = fosc .* noise;

        % --- randomize RO order to avoid W/L ordering bias
        fosc = fosc(randperm(numROs));

        % --- compute responses for the challenge set
        for c = 1:numChallenges
            responses(c,chip) = double(fosc(idxA(c)) > fosc(idxB(c)));
        end

        % uniformity for this chip in this iteration (fraction of 1s)
        uniformity_all_iters(iter, chip) = mean(responses(:,chip)) * 100;  % percent
    end

    % --- uniqueness: average Hamming distance across all chip pairs for this iteration
    hd_list = [];
    for a = 1:numChips-1
        for b = a+1:numChips
            hd = sum(responses(:,a) ~= responses(:,b)) / numChallenges;
            hd_list(end+1) = hd; %#ok<AGROW>
        end
    end
    uniqueness_all_iters(iter) = mean(hd_list) * 100;  % percent
end

% ---- Final per-chip averages and std dev over all iterations
avg_uniformity_per_chip = mean(uniformity_all_iters, 1);    % 1 x numChips
std_uniformity_per_chip = std(uniformity_all_iters, 0, 1); % 1 x numChips

% ---- Final uniqueness average (across iterations)
avg_uniqueness = mean(uniqueness_all_iters);
std_uniqueness = std(uniqueness_all_iters);

% Display results
fprintf('\nAverage uniformity per chip (%%) over %d iterations:\n', numIterations);
for chip = 1:numChips
    fprintf(' Chip %d (W/L #%d): Mean = %.2f%%, Std = %.2f%%\n', chip, chip, avg_uniformity_per_chip(chip), std_uniformity_per_chip(chip));
end
fprintf('\nAverage uniqueness (%%) over %d iterations: Mean = %.2f%%, Std = %.2f%%\n\n', numIterations, avg_uniqueness, std_uniqueness);

% optional plots
figure;
errorbar(1:numChips, avg_uniformity_per_chip, std_uniformity_per_chip, 'o-','LineWidth',1.5);
xlabel('Chip index (W/L setting)'); ylabel('Uniformity (%)');
title('Per-chip average uniformity ± std dev');
grid on;

figure;
plot(1:numIterations, uniqueness_all_iters, '-');
xlabel('Iteration'); ylabel('Uniqueness (%)');
title('Uniqueness across iterations');
grid on;
