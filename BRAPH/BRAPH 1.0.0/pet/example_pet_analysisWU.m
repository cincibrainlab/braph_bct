% An example file of graph analysis of weighted undirected graph created 
%   from PET cohort.
%
% See also PETGraphAnalysisWU, PETCohort.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Load PET cohort

% select file
[file,path,filterindex] = uigetfile(GUI.PCE_EXTENSION,GUI.PCE_MSG_GETFILE);
% load file
if filterindex
    filename = fullfile(path,file);
    tmp = load(filename,'-mat','cohort');
    if isa(tmp.cohort,'PETCohort')
        cohort = tmp.cohort;
    end
else
    disp('Failed to load PET Cohort.')
    return
end

%% Create PET graph analysis

ga = PETGraphAnalysisWU(cohort,Structure(), ...
    PETGraphAnalysis.CORR, PETGraphAnalysis.CORR_PEARSON, ...  % Choose one: CORR_PEARSON CORR_SPEARMAN CORR_KENDALL CORR_PARTIALPEARSON CORR_PARTIALSPEARMAN
    PETGraphAnalysis.NEG, PETGraphAnalysis.NEG_ZERO ... Choose one: NEG_ZERO NEG_NONE NEG_ABS
    );
 
disp(' ')
disp('MEASURES')
for m = GraphWU.MEASURES_WU
    name = Graph.NAME{m};
    nodal = Graph.NODAL(m);
    if nodal 
        disp([int2str(m) ' - ' name ' (nodal)' ])
    else
        disp([int2str(m) ' - ' name ' (global)' ])
    end
end
clear m name nodal;
 
disp(' ')
disp('GROUPS')
for g = 1:1:ga.getCohort.groupnumber()
    gr = cohort.getGroup(g);
    disp([int2str(g) ' - ' gr.getPropValue(Group.NAME)])
end
clear gr;

%% Calculate measure/comparison/random comparison

while ~exist('stop')
    disp(' ')
    MCF = input('New measure (M) or comparison (C) or random comparison (R) or finish (F) ? ','S');
    
    switch lower(MCF)
        
        case 'm'
            
            groupnumber = input('Group number ');
            if groupnumber > cohort.groupnumber
                disp(['Group ' int2str(groupnumber) ' is not a valid group'])
                groupnumber = input('Group number ');
            end
            measurecode = input('Measure number ');
            bool = any(GraphWU.MEASURES_WU == measurecode);
            if ~bool
                disp(['The entered measure is not a valid WU measure'])
                measurecode = input('Measure number ');
            end
            
            ga.calculate(measurecode,groupnumber);
            m = ga.getMeasure(measurecode,groupnumber);
            gr = ga.getCohort().getGroup(groupnumber);

            if Graph.isglobal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' GLOBAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                disp(['Measure value = ' num2str(m.getProp(PETMeasureWU.VALUES1))])
                disp('=== === ===')
            end

            if Graph.isnodal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' NODAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])

                values = m.getProp(PETMeasureWU.VALUES1);
                disp(['Average (over regions) measure value = ' num2str(mean(values))])

                ba = ga.getBrainAtlas();
                for i = 1:1:ba.length()
                    br = ba.get(i);
                    disp([num2str(values(i)) ' - ' br.getPropValue(BrainRegion.NAME)])
                end

                disp('=== === ===')
            end

        case 'c'
            
            groupnumber1 = input('1st group number ');
            if groupnumber1 > cohort.groupnumber
                disp(['Group ' int2str(groupnumber1) ' is not a valid group'])
                groupnumber1 = input('1st group number ');
            end
            groupnumber2 = input('2nd group number ');
            if groupnumber2 > cohort.groupnumber
                disp(['Group ' int2str(groupnumber2) ' is not a valid group'])
                groupnumber2 = input('2nd group number ');
            end
            measurecode = input('Measure number ');
            bool = any(GraphWU.MEASURES_WU == measurecode);
            if ~bool
                disp(['The entered measure is not a valid WU measure'])
                measurecode = input('Measure number ');
            end
            M = input('Permutation number (typically 1000) ');

            ga.compare(measurecode,groupnumber1,groupnumber2,'Verbose',false,'M',M);
            c = ga.getComparison(measurecode,groupnumber1,groupnumber2);
            gr1 = ga.getCohort().getGroup(groupnumber1);
            gr2 = ga.getCohort().getGroup(groupnumber2);

            if Graph.isglobal(measurecode)
                disp('=== === ===')
                disp(['Group numbers = ' int2str(groupnumber1) ' and ' int2str(groupnumber2)])
                disp(['Group names = ' gr1.getPropValue(Group.NAME) ' and ' gr2.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' GLOBAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                disp(['Difference = ' num2str(c.diff()) ])
                disp(['p-value (1) = ' num2str(c.getProp(PETComparisonWU.PVALUE1))])
                disp(['p-value (2) = ' num2str(c.getProp(PETComparisonWU.PVALUE2))])
                disp(['confidence interval = ' num2str(c.CI(5)') ])
                disp('=== === ===')
            end

            if Graph.isnodal(measurecode)
                disp('=== === ===')
                disp(['Group numbers = ' int2str(groupnumber1) ' and ' int2str(groupnumber2)])
                disp(['Group names = ' gr1.getPropValue(Group.NAME) ' and ' gr2.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' NODAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])

                values = c.diff();
                p1 = c.getProp(PETComparisonWU.PVALUE1);
                p2 = c.getProp(PETComparisonWU.PVALUE2);
                ci = c.CI(5);
                disp(['Differences (per region) = ' num2str(values)])
                disp(['p-value (1) (per region) = ' num2str(p1)])
                disp(['p-value (2) (per region) = ' num2str(p2)])
                disp(['con.int.do  (per region) = ' num2str(ci(1,:))])
                disp(['con.int.up  (per region) = ' num2str(ci(2,:))])

                ba = ga.getBrainAtlas();
                for i = 1:1:ba.length()
                    br = ba.get(i);
                    disp([num2str(values(i)) '  -  ' br.getPropValue(BrainRegion.NAME) '  -  p1=' num2str(p1(i)) ' p2=' num2str(p2(i)) ' ci =[' num2str(ci(1,i)) ',' num2str(ci(2,i)) ']'])
                end

                disp('=== === ===')
            end
            
        case 'r'
            
            groupnumber = input('Group number ');
            if groupnumber > cohort.groupnumber
                disp(['Group ' int2str(groupnumber) ' is not a valid group'])
                groupnumber = input('Group number ');
            end
            measurecode = input('Measure number ');
            bool = any(GraphWU.MEASURES_WU == measurecode);
            if ~bool
                disp(['The entered measure is not a valid WU measure'])
                measurecode = input('Measure number ');
            end
            M = input('random graph number (typically 1000)');

            ga.randomcompare(measurecode,groupnumber,'Verbose',true,'M',M);
            n = ga.getRandomComparison(measurecode,groupnumber);
            gr = ga.getCohort().getGroup(groupnumber);

            if Graph.isglobal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' GLOBAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                disp(['Measure value = ' num2str(n.getProp(PETRandomComparisonWU.VALUES1))])
                disp(['Random graph value = ' num2str(n.getProp(PETRandomComparisonWU.RANDOM_COMP_VALUES))])
                disp(['p-value (1) = ' num2str(n.getProp(PETRandomComparisonWU.PVALUE1))])
                disp(['p-value (2) = ' num2str(n.getProp(PETRandomComparisonWU.PVALUE2))])
                disp(['confidence interval = ' num2str(n.CI(5)') ])
                disp('=== === ===')
            end
            
            if Graph.isnodal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' NODAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                
                values = n.getProp(PETRandomComparisonWU.VALUES1);
                disp(['Average (over regions) measure value = ' num2str(mean(values))])

                values = n.diff();
                p1 = n.getProp(PETRandomComparisonWU.PVALUE1);
                p2 = n.getProp(PETRandomComparisonWU.PVALUE2);
                ci = n.CI(5);
                disp(['Differences (per region) = ' num2str(values)])
                disp(['p-value (1) (per region) = ' num2str(p1)])
                disp(['p-value (2) (per region) = ' num2str(p2)])
                disp(['con.int.do  (per region) = ' num2str(ci(1,:))])
                disp(['con.int.up  (per region) = ' num2str(ci(2,:))])

                ba = ga.getBrainAtlas();
                for i = 1:1:ba.length()
                    br = ba.get(i);
                    disp([num2str(values(i)) '  -  ' br.getPropValue(BrainRegion.NAME) '  -  p1=' num2str(p1(i)) ' p2=' num2str(p2(i)) ' ci =[' num2str(ci(1,i)) ',' num2str(ci(2,i)) ']'])
                end
                
                disp('=== === ===')
            end            

        otherwise
            stop = true;
    end
end