%% This code analyzes the peak height, width, and prominence of each inidvidual peak in a trace. 

% Make sure the findpeaks3.m and the calcium trace excel files are in the same folder.

F1 = readtable('calcium traces.xlsx');


% Make graph line color consistant
newcolors = [0 0.4470 0.7410];
colororder(newcolors);
%%
% 'pks': peak height; 'w': peak width at half prominence; 'p': peak prominence.

tableNames = {'Name','pkNum','pks','locs(Sec)','locs(Min)','w','p'};
tableOutputs = array2table(zeros(0,7),'VariableNames',tableNames);
% Define y and x for graph axis.
for i=2:width(F1)
    y = F1(:,i);
    y=table2array(y);
    x = F1.Time;


    % Optional: Add color to under the curve.
    level = 0.0;
    area(x, max(y, level), level, "EdgeColor", "none", "FaceColor", [0.94 1.00 0.94],"HandleVisibility","off");
    hold on
    
    area(x, min(y, level), level, "EdgeColor", "none", "FaceColor", [1.00 0.89 0.88],"HandleVisibility","off");
    hold on
    
    % Using the findpeaks function create graph with marked peaks using preset peak parameters.
    % PeakWidth here represents width at half prominence. 
    % could set MinPeakProminence, MinPeakHeight, MinPeakWidth values to
    % filter out noise or non-specific peaks.
    findpeaks(y, x, "MinPeakProminence",0.5,"MinPeakHeight",0.5, "MinPeakWidth", 40, "MinPeakDistance", 0, "Annotate","extents");
    xlabel("Time (s)");
    ylabel("∆F/F_0");
    title("Cell1");
    hold off
    
    % Display Peak information in vectors
    [pks,locs,w,p] = findpeaks(y, x, "MinPeakProminence",0.5, "MinPeakHeight",0.5, "MinPeakWidth", 40, "MinPeakDistance", 0, "Annotate","extents");
    
    % Convert locs from seconds to minute
    
    for j=1:length(pks)
        k=(locs)./60;
        rowToAdd = {F1.Properties.VariableNames(i),j,pks(j),locs(j),k(j),w(j),p(j)}; 
        tableOutputs = [tableOutputs; rowToAdd];
    end

end