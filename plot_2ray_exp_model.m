% plot_2ray_exp_model.m
clear; clf;

% Parameters
scale = 1e-9;           % scale to nanoseconds
Ts = 10 * scale;        % Sampling time (10 ns)
t_rms = 30 * scale;     % RMS delay spread (30 ns)
num_ch = 10000;         % Number of channel realizations

%% 2-ray model
pow_2 = [0.5, 0.5];                % Equal power
delay_2 = [0, 2 * t_rms] / scale;  % Delay in ns (converted)

% Generate Rayleigh fading channels
H_2 = [Ray_model(num_ch); Ray_model(num_ch)].' * diag(sqrt(pow_2));
avg_pow_h_2 = mean(abs(H_2).^2);

subplot(2,2,1)
stem(delay_2, pow_2, 'ko', 'LineWidth', 1.5); hold on;
stem(delay_2, avg_pow_h_2, 'k.', 'MarkerSize', 10);
xlabel('Delay [ns]'); ylabel('Channel Power [linear]');
title('2-ray Channel Model');
legend('Ideal', 'Simulation');
axis([-10 140 0 0.7]); grid on;

%% Exponential model
pow_e = exp_PDP(t_rms, Ts);                             % Ideal PDP
delay_e = (0:length(pow_e)-1) * Ts / scale;             % Delay in ns

% Generate simulated fading for each tap
H_e = zeros(num_ch, length(pow_e));
for i = 1:length(pow_e)
    H_e(:,i) = Ray_model(num_ch).' * sqrt(pow_e(i));
end
avg_pow_h_e = mean(abs(H_e).^2);

subplot(2,2,2)
stem(delay_e, pow_e, 'ko', 'LineWidth', 1.5); hold on;
stem(delay_e, avg_pow_h_e, 'k.', 'MarkerSize', 10);
xlabel('Delay [ns]'); ylabel('Channel Power [linear]');
title('Exponential PDP Model');
legend('Ideal', 'Simulation');
axis([-10 140 0 0.7]); grid on;

