%% ============================
%% MUX-Based RO-PUF Uniformity (100 iterations averaged)
clc; clear; close all;

%% ============================
%% 1. Define RO frequencies from LTspice
fosc4  = [609098662.763, 608729808.96, 555410647.111, 527165841.547];
fosc8  = [609067845.763,608361651.367,555186910.552,527131346.438, ...
          513357844.606,507190124.847,503967112.833,501546427.313];
fosc16 = [609325852.286,609301597.539,554536684.057,527378219.409, ...
          513629427.558,507232502.973,503835154.151,502266106.873, ...
          501809813.631,501283945.98,500908838.664,500595375.654, ...
          500415246.134,500684633.668,500739553.187,500690307.004];
fosc32 = [608584062.852,607751124.412,554230880.787,527064613.647, ...
          513479661.569,506677377.65,503328907.666,501756237.8, ...
          500920778.513,500216668.875,500187259.265,500306183.185, ...
          500270326.639,500106149.557,499932432.291,499769460.726, ...
          499868105.717,499982371.697,500085059.121,500037255.225, ...
          499984173.836,499925611.464,499899563.625,499920903.34, ...
          499954612.276,499965252.904,499953466.094,499948622.485, ...
          499950622.091,499959356.644,499971348.835,499961958.831];

%% ============================
%% 2. Parameters
numChallenges = 1000;   % Number of challenge pairs
numMainIters  = 100;    % Repeat full randomization 100 times

%% ============================
%% 3. Function to compute uniformity for one randomization
function U = calcUniformity(f4, f8, f16, f32, numChallenges)
    computeResponse = @(fA, fB) double(fA > fB);

    responses.RO4  = zeros(numChallenges,1);
    responses.RO8  = zeros(numChallenges,1);
    responses.RO16 = zeros(numChallenges,1);
    responses.RO32 = zeros(numChallenges,1);

    for i = 1:numChallenges
        % --- RO4 ---
        selA = randi([1 2]); selB = randi([3 4]);
        responses.RO4(i) = computeResponse(f4(selA), f4(selB));

        % --- RO8 ---
        selA = randi([1 4]); selB = randi([5 8]);
        responses.RO8(i) = computeResponse(f8(selA), f8(selB));

        % --- RO16 ---
        selA = randi([1 8]); selB = randi([9 16]);
        responses.RO16(i) = computeResponse(f16(selA), f16(selB));

        % --- RO32 ---
        selA = randi([1 16]); selB = randi([17 32]);
        responses.RO32(i) = computeResponse(f32(selA), f32(selB));
    end

    % Calculate uniformity
    U.RO4  = mean(responses.RO4)*100;
    U.RO8  = mean(responses.RO8)*100;
    U.RO16 = mean(responses.RO16)*100;
    U.RO32 = mean(responses.RO32)*100;
end

%% ============================
%% 4. Run 100 randomizations and average results
uniformity.RO4  = zeros(numMainIters,1);
uniformity.RO8  = zeros(numMainIters,1);
uniformity.RO16 = zeros(numMainIters,1);
uniformity.RO32 = zeros(numMainIters,1);

for k = 1:numMainIters
    % Randomize order each iteration
    rng('shuffle');
    f4r  = fosc4(randperm(length(fosc4)));
    f8r  = fosc8(randperm(length(fosc8)));
    f16r = fosc16(randperm(length(fosc16)));
    f32r = fosc32(randperm(length(fosc32)));

    U = calcUniformity(f4r, f8r, f16r, f32r, numChallenges);

    uniformity.RO4(k)  = U.RO4;
    uniformity.RO8(k)  = U.RO8;
    uniformity.RO16(k) = U.RO16;
    uniformity.RO32(k) = U.RO32;
end

%% ============================
%% 5. Final averaged uniformity
finalUniformity.RO4  = mean(uniformity.RO4);
finalUniformity.RO8  = mean(uniformity.RO8);
finalUniformity.RO16 = mean(uniformity.RO16);
finalUniformity.RO32 = mean(uniformity.RO32);

disp('===============================');
disp(' Final Averaged Uniformity (%) ');
disp('===============================');
disp(finalUniformity);

%% ============================
%% 6. Plot averaged results
PUFsizes = [4, 8, 16, 32];
uniformityValues = [finalUniformity.RO4, finalUniformity.RO8, ...
                    finalUniformity.RO16, finalUniformity.RO32];

figure;
plot(PUFsizes, uniformityValues, '-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('RO-PUF Size (Number of ROs)');
ylabel('Average Uniformity (%)');
title('Average Uniformity vs RO-PUF Size (100 Randomized Iterations)');
grid on;
