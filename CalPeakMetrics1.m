
%% This code analyzes the peak count, mean peak frequency, duration, mean peak intervals and AUC.

% Make sure the findpeaks3.m and the calcium trace excel files are in the same folder.


% if xlsx is in the same folder as this .m file then can just use name. If
% not put whole path here.
F1 = readtable('calcium traces.xlsx');

%%
tableNames = {'Name','pkCount','pkFreq (peak/min)','1stPk(min)','1st-lastpk(min)','AUC', 'MeanCycle(s)'};
tableOutputs = array2table(zeros(0,7),'VariableNames',tableNames);

% Define y and x for graph axis.
for i=2:width(F1)
    y = F1(:,i);
    y=table2array(y);
    x = 0:5:1800; % Make sure this time interval and duration matches with the excel file.


    % Display Peak information in vectors, could set MinPeakProminence, MinPeakHeight, MinPeakWidth values to filter out noise or
    % non-specific peaks.
    % PeakWidth here represents width at half prominence. 
    [pks,locs,w,p,bounds] = findpeaks3(y, x, "MinPeakProminence",0.5,"MinPeakHeight",0.5, "MinPeakWidth", 40, "MinPeakDistance", 0, "Annotate","extents");

    for locMT = isempty(locs)
            if locMT == 1
                minloc = 0;
                maxloc = 0;
            elseif locMT == 0
                minloc = min(locs);
                maxloc = max(locs);
            end

%       For counting peaks, if the pks is empty then there are 0 peaks. 
        pksMT = isempty(pks);
            if pksMT == 1
                j=0;
            elseif pksMT == 0
                j=numel(pks);
            end
        
%       Finding time to first peak by amplitude location.    
        m=(minloc)./60;
            if minloc==0
                m = 0;
            end

%       Signal duration calculation using half-prominence width
%       intercepts. (Last peak last intercept given in seconds)-(first
%       peak first intecept given in seconds). Allows measurements to be
%       the same regardless of peak counts. Divide by 60 to translate to
%       minutes. 
        boundz=bounds(:);
        boundzMT = isempty(boundz);
            if boundzMT == 1
                minboundz = 0;
                maxboundz = 0;
            elseif locMT == 0
                minboundz = min(boundz);
                maxboundz = max(boundz);
            end
        nd=(maxboundz-minboundz)/60;

%       Optimized peak freqency using signal duration from peak
%       intercepts. 
        pd=(j/nd);
            if j==0
                pd = 0;
            end
        
%       Refined Area under the curve measurement derived via signal
%       duration. x start and end points need to be rounded to nearest 5 to
%       match up with steps (look at your xx and yy lengths, they need to
%       be the same for this to work). miny and maxy need to have +1 due to
%       zero not being a point in either the data set or the vector, adding
%       1 allows the x and y data to match up.
        minx=(round(minboundz/5) *5);
            if minboundz == 0
                minx = 5;
            end
        maxx=(round(maxboundz/5) *5);
            if maxboundz == 0
                maxx = 10;
            end
            
        miny=(minx/5)+1;
        maxy=(maxx/5)+1;
        yy = y(miny:maxy);

%       If whole video use x = 0:5:2400. If just post treatment use x =
%       0:5:1800. If videos have 10 second intervals use x = 0:10:1800. Use
%       these values ONLY if you plan to calculate the AUC of the whole of
%       these ranges. If AUC is based off rounded intercepts then use xx =
%       minx:5:maxx (if your image interval is 10 ajdust xx to
%       minx:10:maxx).

        xx = minx:5:maxx;
        yy(yy<0) = 0;
        AUC = trapz(xx,yy);
            if AUC < 10
                AUC = 0;
            end

 % meanCycle is to calculate the mean peak interval
       meanCycle = mean(diff(locs))

%       To make a summarized chart of all extracted features/calculations. 
        rowToAdd = {F1.Properties.VariableNames(i),j,pd,m,nd,AUC,meanCycle}; 
        tableOutputs = [tableOutputs; rowToAdd];
    end
    
end
