%example call: folder_response('./data/responder');
% No "/" at the end of the path is important!

function folder_response(directoryPath)

% Preparation
set_parameters;

% Create list of .wav files to process
filesList=dir(strcat(directoryPath,'/*.wav'));

% Create folders to sort audiofiles into, if flag is set
if (split)
   mkdir(horzcat(directoryPath, '/responder/'));
   mkdir(horzcat(directoryPath, '/non_responder/'));  
   mkdir(horzcat(directoryPath, '/record_error/'));
   mkdir(horzcat(directoryPath, '/responder/plots/'));
   mkdir(horzcat(directoryPath, '/non_responder/plots/'));  
   mkdir(horzcat(directoryPath, '/record_error/plots/'));
end

% Create cell array with [resp, ons, mpeak, avgpeak, ratio, mpeak_w, mean_data]
resultsArray = cell(length(filesList), 8);

for process = 1:length(filesList)
    
    % Get results from the audiofile specified in filePath
    filePath=strcat(directoryPath,'/',filesList(process).name);
    [resp, ons, mpeak, avgpeak, ratio, mpeak_w, mean_data] = response(filePath, process, filesList(process).name); 
    
    % Write data into table
    resultsArray{process,1} = filesList(process).name;
    resultsArray{process,2} = resp;
    resultsArray{process,3} = ons;
    resultsArray{process,4} = mpeak;
    resultsArray{process,5} = avgpeak;
    resultsArray{process,6} = ratio;
    resultsArray{process,7} = mpeak_w;
    resultsArray{process,8} = mean_data;
    
    % Save plots as .png instead of keeping in Matlab, if flag set
    if (research~=1)
        saveas(process, strcat(filePath, '.png'));
        close;
    end
    
    % Sorting of files into result-folders for easier checking of results,
    % if flag set
    if (split)
        
       if (resp==4)
           copyfile(filePath, horzcat(directoryPath,'/responder'), 'f');
           if (research~=1)
               movefile(strcat(filePath, '.png'), horzcat(directoryPath,'/responder/plots'), 'f');
           end
       end
       
       if (resp==0)
           copyfile(filePath, horzcat(directoryPath,'/non_responder'), 'f');
           if (research~=1)
               movefile(strcat(filePath, '.png'), horzcat(directoryPath,'/non_responder/plots'), 'f');
           end
       end
       
       if (resp==99)
           copyfile(filePath, horzcat(directoryPath,'/record_error'), 'f');
           if (research~=1)
               movefile(strcat(filePath, '.png'), horzcat(directoryPath,'/record_error/plots'), 'f');
           end
           
       end
       
    end
    
end

% Convert cell array to table
resultsTable = cell2table(resultsArray, 'VariableNames', {'Filename',...
                      'Response', 'Onset', 'maxPeak', 'avgPeak', ...
                'peakRatio', 'widthMaxPeak', 'meanDataValues'});

% Create handle for output file
[~, outFileName, ~] = fileparts(directoryPath);
outFilePath=strcat(directoryPath, '/',outFileName, '.xlsx');

% Write table to output file
writetable(resultsTable, outFilePath);

end