function [] = plot_evaluation_results(recall, precision, average)
% plot_evaluation_results - plot results of detector evaluation
% Inputs:
% 1. recall - array - tp/(tp+fn)
% 2. precision - array - tp/(tp+fp)
% 3. average - array 
%% Plot evaluation results
labels = {'sitting'; 'standing'; 'raising_hand'; 'turned'};
for i=1:4
    figure; grid on;
    plot(recall{i}, precision{i}, 'r-o');
    xlabel('Recall');
    ylabel('Precision');
    title(sprintf('Average Precision - %s = %.2f', cell2mat(labels(i)), average(i)));
end
end

