% M. Ammar, 04.08.2015
%% Function that maps actions and language

function [accuracy,abstraction_frequency,expression_usage,sentenceIdx,wordIdx,letterIdx] = fun_Coordination(T,D,beta,Bias,action,dictionary)
        
    %penalty of expressions
    penalty = [];
    for i = 1:length(dictionary)
        penalty = [penalty length(dictionary{i})];   
    end    
            
    %initialize plot matrices
    accuracy = zeros(D,T,length(beta));
    abstraction_frequency = zeros(D,3,length(beta));
    expression_usage = zeros(D,length(dictionary),length(beta));
    
    [sentenceIdx,wordIdx,letterIdx] = fun_Dictionary(dictionary); 

    %Architect: choose an expression for action X
    %Builder: choose an action for expression
    for b = 1:length(beta)
        for d = 1:D

            %initialize weight of expressions
            weight = repmat({repmat(1,1,length(action))},1,length(dictionary)); %Architect's sampling bias    
            builder_weight = repmat({repmat(1,1,length(action))},1,length(dictionary)); %Builder's sampling bias

            for t = 1:T
                X = randsample(action,1); %current action
                dummy = cellfun(@(x) x(find(contains(action,X))),weight); %weights of all expressions for current action 
                dummy = dummy./(penalty.^(beta(b))); %penalize length of expressions
                expression = randsample(dictionary,1,true,dummy); %architect chooses expression based on weight
                
                index_action =find(contains(action,X)); %index of current action
                index_expression =find(ismember(dictionary,expression)); %index of chosen expression
                
                M = find(contains(action,expression{1})); %actions that can be described by expression
                A = randsample([M M],1,true,[builder_weight{index_expression}(M) builder_weight{index_expression}(M)]); %builder chooses action
                builder_weight{index_expression}(A) = builder_weight{index_expression}(A) + Bias; %builder updates expression weight
                
                if index_action == A
                    weight{index_expression}(index_action) = weight{index_expression}(index_action)+1; %increase weight of expression by 1 if it maps to the current action
                    accuracy(d,t,b) = 1; %note correct action for plot
                else
                    weight{index_expression}(index_action) = weight{index_expression}(index_action)+0.2; %increase weight by 0.5 if it does not map to the current action
                end      
        
                if index_expression <=length(sentenceIdx)
                    abstraction_frequency(d,1,b) = abstraction_frequency(d,1,b)+1;
                elseif index_expression >=wordIdx(1) & index_expression <=wordIdx(end)
                    abstraction_frequency(d,2,b) = abstraction_frequency(d,2,b)+1;
                else
                    abstraction_frequency(d,3,b) = abstraction_frequency(d,3,b)+1;
                end
        
                expression_usage(d,index_expression,b)=expression_usage(d,index_expression,b)+1;
            end
        end
    end