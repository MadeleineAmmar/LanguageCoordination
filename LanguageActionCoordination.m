% M. Ammar, 04.08.2015
%% Coordination of abstract language

clear all;
clc;

%% Define function input

T =1000; %no. of trials per dyad
D = 100; %no. of dyads
beta = [0:0.01:0.1]; %Penalizing parameter
Bias = 0; %Builder's sampling bias --> set Bias = 0, if builder should sample actions at random

%Actions
%action = {'ABCD EFGH IJKY', 'ABCD EFGH IJKX', 'ABCD EFGH IJKZ', 'ABCD EFGH IJKQ'};
action = {'ABCD EFKL IJMN','ABCD EFOP IJQR', 'ABCD EFST IJUV', 'ABCD EFWX IJYZ'};

%Dictionary of expressions
%dictionary = {'ABCD EFGH IJKY', 'ABCD EFGH IJKX', 'ABCD EFGH IJKZ', 'ABCD EFGH IJKQ','ABCD','EFGH','IJKY','IJKX','IJKZ','IJKQ','A','B','C','D','E','F','G','H','I','J','K','Y','X','Z','Q'};
dictionary = {'ABCD EFKL IJMN', 'ABCD EFOP IJQR', 'ABCD EFST IJUV', 'ABCD EFWX IJYZ','ABCD','EFKL','IJMN','EFOP','IJQR','EFST','IJUV','EFWX','IJYZ','A','B','C','D','E','F','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

[accuracy,abstraction_frequency,expression_usage,sentenceIdx,wordIdx,letterIdx] = fun_Coordination(T,D,beta,Bias,action,dictionary);


%% Plotting function's output

%Normalization of frequency
abstraction_frequency(:,1,:) = abstraction_frequency(:,1,:)./length(sentenceIdx);
abstraction_frequency(:,2,:) = abstraction_frequency(:,2,:)./length(wordIdx);
abstraction_frequency(:,3,:) = abstraction_frequency(:,3,:)./length(letterIdx);

%Index vector of beta values to be plotted
beta_plot=[1 round(length(beta)/2) length(beta)]; 

%Plotting accuracy and abstraction frequency
figure(1)
subplot(2,3,1)
plot(mean(accuracy(:,:,beta_plot(1))),'Color',[0.5 0.5 0.5]); %low penality
ylabel('Proportion of correct actions')
xlabel('Time')
title(strjoin({'\beta = ',num2str(beta(beta_plot(1)))}))
subplot(2,3,2)
plot(mean(accuracy(:,:,beta_plot(2))),'Color',[0.5 0.5 0.5]); %medium penality
xlabel('Time')
title(strjoin({'\beta = ',num2str(beta(beta_plot(2)))}))
subplot(2,3,3)
plot(mean(accuracy(:,:,beta_plot(3))),'Color',[0.5 0.5 0.5]); %high penality
xlabel('Time')
title(strjoin({'\beta = ',num2str(beta(beta_plot(3)))}))
subplot(2,3,[4 5 6])
sentences = mean(abstraction_frequency(:,1,:)./sum(abstraction_frequency(:,:,:),2));
words = mean(abstraction_frequency(:,2,:)./sum(abstraction_frequency(:,:,:),2));
letters = mean(abstraction_frequency(:,3,:)./sum(abstraction_frequency(:,:,:),2));
scatter(beta,sentences(:,:),'.','MarkerEdgeColor','r')
hold on;
scatter(beta,words(:,:),'*','MarkerEdgeColor',[0 0 0])
hold on;
scatter(beta,letters(:,:),'d','MarkerEdgeColor',[0 0 0])
legend('Sentence','Word','Letter')
title('Level of abstraction')
ylabel('Proportion of expressions')
xlabel('Penalizing parameter \beta')


%Plotting most frequently used expressions
rgbTriplets = rand(length(dictionary),3); %random color palette
labels = dictionary; %legend labels

for bi = 1:length(beta_plot)
    matrix_B = nan(10,length(dictionary));
    for d = 1:10 %show results for 10 dyads
        [B,I]=maxk(expression_usage(d,:,beta_plot(bi)),4); %4 most frequent expressions for dyad d
        matrix_B(d,I)=B; %store frequency of usage
    end

    matrix_B(end+1,:)=NaN;
    
    figure(2)
    subplot(1,length(beta_plot),bi)
    legendHandles = [];
    legendLabels = {};
    
    for i = 1:10
        b=bar([i i+1],matrix_B([i end],:),'stacked');
        hold on;
        for c = 1:length(dictionary)
            b(c).FaceColor = rgbTriplets(c,:);
        end
    
        for k = 1:length(b)
            if any(b(k).YData)
                legendHandles(end+1) = b(k);
                legendLabels{end+1} = labels{k};
            end
        end
        
    end   
    
    title(strjoin({'\beta = ',num2str(beta(beta_plot(bi)))}))
    xticks([1:1:10])
    [uniqueLabels, ia] = unique(legendLabels, 'stable');  % 'stable' keeps first occurrence
    uniqueHandles = legendHandles(ia);
    
    legend(uniqueHandles, uniqueLabels);

end

han=axes(figure(2),'visible','off'); 
han.XLabel.Visible = 'on';
xlabel('Dyads')
han.YLabel.Visible = 'on';
ylabel('Frequency of expression used in a dyad')
