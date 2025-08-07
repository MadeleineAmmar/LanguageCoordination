% M. Ammar, 04.08.2015
%% Function that extracts abstraction categories from the dictionary

function [sentenceIdx,wordIdx,letterIdx] = fun_Dictionary(dictionary) 
    sentenceIdx = [];
    wordIdx = [];
    letterIdx = [];
    
    for i = 1:length(dictionary)
        str = dictionary{i};
        
        % Count number of words
        words = strsplit(str);
        numWords = length(words);
        
        % Check if it's a sentence: multiple words, ends in punctuation
        if numWords > 1 
            sentenceIdx(end+1) = i;
        
        % Check if it's a single letter (1 character and alphabetic)
        elseif length(str) == 1 && isstrprop(str, 'alpha')
            letterIdx(end+1) = i;
        
        % Check if it's a word: a single word with alphabetic characters
        elseif numWords == 1 && all(isstrprop(str, 'alpha'))
            wordIdx(end+1) = i;
        end
    end