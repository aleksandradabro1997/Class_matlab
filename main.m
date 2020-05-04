% CLASS PROJECT - ICK - AGH - EAIIB - AIR ISS - 2020
% Aleksandra D�browska
% Jerzy D�browski
% Kinga Talaga
%% Clear
clear all; close all; clc
% Set interpreter of plots for none to be able to use _, / etc
set(0, 'DefaultTextInterpreter', 'none');
%% MAIN
fprintf('Witamy, wybierz co chcesz zrobic\n')
fprintf('1. Uruchom trening, ewaluacj� i zapisz detektor\n')
fprintf('2. Stw�rz nowy dataset\n')
fprintf('3. Uruchom detektor \n')
fprintf('4. Utw�rz opcje treningowe\n')

from_user = 1;
while from_user
    from_user = input('\n');
    if from_user == 1
        dataset_name = input('Wprowad� nazw� datasetu\n');
        train_size = input('Wprowad� rozmiar zbioru treningowego 0-1\n');
        max_anchors = input('Wprowad� maksymaln� liczb� anchor boxes\n');
        training_options = input('Wprowad� �cie�k� do pliku zawieraj�cego opcje treningu\n');
        [test_data, detector] = run_training(dataset_name, train_size, max_anchors, training_options);
        [average, recall, precision] = evaluate_detector(detector, test_data);
        plot_evaluation_results(recall, precision, average)
    elseif from_user == 2
        create_dataset({'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria1',...
                 'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria2'}, ...
                 {'labels_series1.mat', 'labels_series2.mat'}, ...
                 [224 224 3], [720 1280 3], 'dataset_input224x224x3');
    elseif from_user == 3
        detector_name = input('Wprowad� �cie�k� do detektora\n');
        detector=load(detector_name);
        detector=detector.detector;
        filepath = input('Wprowad� �cie�k� do folderu ze zdj�ciami\n');
        run_detector_on_pictures(filepath, detector);
    elseif from_user == 4
        save_path = input('Wprowad� �cie�k� do zapisu opcji\n');
        input_size = input('Rozmiar obrazka do sieci\n');
        feature_extraction_network = input('Wprowad� nazw� sieci ekstraktuj�cej cechy\n');
        feature_extraction_network_name = input('Wprowad� nazw� sieci ekstraktuj�cej dane\n');
        feature_layer = input('Wprowad� nazw� warstwy ekstraktuj�cej dane\n');
        mini_batch_size = input('Wprowad� mini batch size\n');
        learn_rate = input('Wprowad� tempo nauki\n');
        max_epochs = input('Wprowad� maksymaln� liczb� epok\n');
        verbose_freq = input('Wprowad� cz�sto�� wy�wietlania progresu\n');
        checkpoint_path = input('Wprowad� �cie�k� do zapisywania checkpoint�w \n');
        negative_overlap = input('Wprowad� zakres negative overlap\n');
        positive_overlap = input('Wprowad� zakres positive overlap\n');
        augmentation = input('Wprowad� czy uaktywni� opcj� augmentacji 0,1\n');
        define_training_options(save_path,input_size, feature_extraction_network, feature_extraction_network_name,...
                                      feature_layer, mini_batch_size , learn_rate, max_epochs, ...
                                      verbose_freq, checkpoint_path, negative_overlap, positive_overlap, augmentation)
    else
        
    end
end



