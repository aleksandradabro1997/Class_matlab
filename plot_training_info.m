function [] = plot_training_info(training_info)
% plot data included in training info structure
% Inputs
% 1. training_info - struct - structure with training loss, etc
%%
figure();
subplot(3,1,1); grid on;
plot(training_info.TrainingLoss);
xlabel('Iteration');
title('Training loss')

subplot(3,1,2); grid on;
plot(training_info.TrainingAccuracy);
xlabel('Iteration');
title('Training accuracy')

subplot(3,1,3); grid on;
plot(training_info.TrainingRMSE);
xlabel('Iteration');
title('Training RMSE')

sgtitle('Training info')
end