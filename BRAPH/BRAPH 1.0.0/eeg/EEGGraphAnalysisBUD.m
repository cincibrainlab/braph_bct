classdef EEGGraphAnalysisBUD < EEGGraphAnalysis
    % EEGGraphAnalysisBUD < EEGGraphAnalysis : Graph analysis of fixed density binary undirected EEG
    %   EEGGraphAnalysisBUD represents a list of measures used for graph analysis of EEG data based 
    %   on binary undirected graphs with fixed density.
    %
    % EEGGraphAnalysisBUD properties (Access = protected):
    %   props                   -   cell array of object properties < ListElement
    %   elements                -   cell array of list elements < List
    %   path                    -   XML file path < List
    %   file                    -   XML file name < List
    %   cohort                  -   cohort (EEGCohort) < EEGGraphAnalysis
    %   data                    -   subject data (cell array; matrix; one per subject) < EEGGraphAnalysis
    %   A                       -   adjaciency matrix (cell array; matrix; one per subject) < EEGGraphAnalysis
    %   P                       -   correlation p-value matrix (cell array; matrix; one per subject) < EEGGraphAnalysis      
    %   structure               -   community structure < EEGGraphAnalysis 
    %   ht_measure              -   hashtable for measure (cell array; sparse vectors; one per measure) < EEGGraphAnalysis
    %   ht_comparison           -   hashtable for comparison (cell array; sparse matrices; one per measure) < EEGGraphAnalysis
    %   ht_random_comparison    -   hashtable for random comparison (cell array; sparse vectors; one per measure) < EEGGraphAnalysis
    %
    % EEGGraphAnalysisBUD properties (Constant):
    %   NAME            -   name numeric code < EEGGraphAnalysis
    %   NAME_TAG        -   name tag < EEGGraphAnalysis
    %   NAME_FORMAT     -   name format < EEGGraphAnalysis
    %   NAME_DEFAULT    -   name default < EEGGraphAnalysis
    %
    %   CORR                    -   correlation numeric code < EEGGraphAnalysis
    %   CORR_TAG                -   correlation tag < EEGGraphAnalysis
    %   CORR_FORMAT             -   correlation format < EEGGraphAnalysis
    %   CORR_PEARSON            -   correlation 'pearson' option < EEGGraphAnalysis
    %   CORR_SPEARMAN           -   correlation 'spearman' option < EEGGraphAnalysis
    %   CORR_KENDALL            -   correlation 'kendall' option < EEGGraphAnalysis
    %   CORR_PARTIALPEARSON     -   correlation 'partial pearson' option < EEGGraphAnalysis
    %   CORR_PARTIALSPEARMAN    -   correlation 'partial spearman' option < EEGGraphAnalysis
    %   CORR_OPTIONS            -   array of correlation options < EEGGraphAnalysis
    %   CORR_DEFAULT            -   correlation default < EEGGraphAnalysis
    %
    %   NEG             -   negative correlations numeric code < EEGGraphAnalysis
    %   NEG_TAG         -   negative correlations tag < EEGGraphAnalysis
    %   NEG_FORMAT      -   negative correlations format < EEGGraphAnalysis
    %   NEG_ZERO        -   negative correlations 'zero' option < EEGGraphAnalysis
    %   NEG_NONE        -   negative correlations 'none' option < EEGGraphAnalysis
    %   NEG_ABS         -   negative correlations 'abs' option < EEGGraphAnalysis
    %   NEG_OPTIONS     -   array of negative correlations options < EEGGraphAnalysis
    %   NEG_DEFAULT     -   negative correlations default < EEGGraphAnalysis
    %
    %   FMIN            -   Lower frequency cutoff numeric code < EEGGraphAnalysis
    %   FMIN_TAG        -   Lower frequency cutoff tag < EEGGraphAnalysis
    %   FMIN_FORMAT     -   Lower frequency cutoff format < EEGGraphAnalysis
    %   FMIN_DEFAULT    -   Lower frequency cutoff default < EEGGraphAnalysis
    %
    %   FMAX            -   Higher frequency cutoff numeric code < EEGGraphAnalysis
    %   FMAX_TAG        -   Higher frequency cutoff tag < EEGGraphAnalysis
    %   FMAX_FORMAT     -   Higher frequency cutoff format < EEGGraphAnalysis
    %   FMAX_DEFAULT    -   Higher frequency cutoff default < EEGGraphAnalysis
    %
    % EEGGraphAnalysisBUD methods (Access = protected):
    %   copyElement            -   copies elements of graph analysis < EEGGraphAnalysis
    %   initialize             -   initializes graph analysis < EEGGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %
    % EEGGraphAnalysisBUD methods:
    %   EEGGraphAnalysisBUD    -   constructor
    %   setProp                 -   sets property value < ListElement
    %   getProp                 -   gets property value, format and tag < ListElement
    %   getPropValue            -   string of property value < ListElement
    %   getPropFormat           -   string of property format < ListElement
    %   getPropTag              -   string of property tag < ListElement
    %   fullfile                -   builds XML file name < List
    %   length                  -   list length < List
    %   get                     -   gets element < List
    %   getProps                -   get a property from all elements of the list < List 
    %   invert                  -   inverts two elements < List
    %   moveto                  -   moves element < List
    %   removeall               -   removes selected elements < List 
    %   addabove                -   adds empty elements above selected ones < List
    %   addbelow                -   adds empty elements below selected ones < List
    %   moveup                  -   moves up selected elements < List 
    %   movedown                -   moves down selected elements < List
    %   move2top                -   moves selected elements to top < List
    %   move2bottom             -   moves selected elements to bottom < List 
    %   load                    -   load < List
    %   loadfromfile            -   loads List from XML file < List
    %   save                    -   save < List
    %   savetofile              -   saves a list to XML file < List
    %   clear                   -   clears list < List
    %   adjmatrix               -   calculates the adjaciency matrix < EEGGraphAnalysis
    %   getCohort               -   returns cohort of a graph analysis < EEGGraphAnalysis
    %   getBrainAtlas           -   returns atlas of graph analysis < EEGGraphAnalysis
    %   getPlotBrainSurf        -   generates new PlotBrainSurf < EEGGraphAnalysis
    %   getPlotBrainAtlas       -   generates new PlotBrainAtlas < EEGGraphAnalysis
    %   getPlotBrainGraph       -   generates new PlotBrainGraph < EEGGraphAnalysis
    %   getSubjectData          -   returns data of subjects < EEGGraphAnalysis
    %   getA                    -   returns adjaciency matrix < EEGGraphAnalysis
    %   getP                    -   returns correlations p-value matrix < EEGGraphAnalysis
    %   getStructure            -   returns community structure < EEGGraphAnalysis
    %   exist                   -   tests whether a given measure/comparison exists < EEGGraphAnalysis
    %   existMeasure            -   tests whether a given measure exists < EEGGraphAnalysis
    %   existComparison         -   tests whether a given comparison exists < EEGGraphAnalysis
    %   existRandom             -   tests whether a given random comparison exists < EEGGraphAnalysis
    %   add                     -   adds measure < EEGGraphAnalysis
    %   remove                  -   removes measure < EEGGraphAnalysis
    %   replace                 -   replaces measure < EEGGraphAnalysis
    %   toXML                   -   creates XML Node from graph analysis < EEGGraphAnalysis
    %   fromXML                 -   loads graph analysis from XML Node < EEGGraphAnalysis
    %   disp                    -   displays graph analysis
    %   getMeasures             -   gets available measures
    %   getMeasure              -   gets measure from a given group
    %   getComparisons          -   gets available comparisons
    %   getComparison           -   gets comparison from given groups
    %   getRandomComparisons    -   gets available random comparisons
    %   getRandomComparison     -   gets random comparison from given groups
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare       -   calculates random comparison
    %
    % EEGGraphAnalysisBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < EEGGraphAnalysis
    %   getTags         -   cell array of strings with the tags of the properties < EEGGraphAnalysis
    %   getFormats      -   cell array with the formats of the properties < EEGGraphAnalysis
    %   getDefaults     -   cell array with the defaults of the properties < EEGGraphAnalysis
    %   getOptions      -   cell array with options (only for properties with options format) < EEGGraphAnalysis
    %   getIndex        -   get index used in calculation of hash values
    %   elementClass    -   element class name
    %   element         -   creates new empty element
    %
    % See also EEGGraphAnalysisBUT, EEGGraphAnalysis ,EEGGraphAnalysisWU, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = EEGGraphAnalysisBUD(cohort,structure,varargin)
            % EEGGRAPHANALYSISBUD(COHORT,STRUCTURE) creates a EEG graph analysis using the cohort COHORT 
            %   and community structure STRUCTURE. This analysis has default properties and uses a  
            %   binary undirected graph with fixed density.
            %   
            % EEGGRAPHANALYSISBUD(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGGraphAnalysis.NAME      -   char
            %     EEGGraphAnalysis.CORR      -   options (EEGGraphAnalysis.CORR_PEARSON,EEGGraphAnalysis.CORR_SPEARMAN,
            %                                    EEGGraphAnalysis.CORR_KENDALL,EEGGraphAnalysis.CORR_PARTIALPEARSON,
            %                                    EEGGraphAnalysis.CORR_PARTIALSPEARMAN)
            %     EEGGraphAnalysis.NEG       -   options (EEGGraphAnalysis.NEG_ZERO,
            %                                    EEGGraphAnalysis.NEG_NONE,EEGGraphAnalysis.NEG_ABS)
            %     EEGGraphAnalysis.FMIN      -   numeric
            %     EEGGraphAnalysis.FMAX      -   numeric
            %
            % See also EEGGraphAnalysisBUD, EEGGraphAnalysis, List.
            
            ga = ga@EEGGraphAnalysis(cohort,structure, ...
                EEGGraphAnalysis.GRAPH, EEGGraphAnalysis.GRAPH_BUD, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also EEGGraphAnalysisBUD.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'EEGComparisonBUD')
                    disp([Graph.NAME{m.getProp(EEGComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(EEGComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(EEGComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(EEGComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(EEGComparisonBUD.THRESHOLD1) ...
                        ' t2=' m.getPropValue(EEGComparisonBUD.THRESHOLD2) ...
                        ' g1=' m.getPropValue(EEGComparisonBUD.GROUP1)...
                        ' g2=' m.getPropValue(EEGComparisonBUD.GROUP2) ...
                        ' v1= matrix ' int2str(size(m.getProp(EEGComparisonBUD.VALUES1),1)) ' x ' int2str(size(m.getProp(EEGComparisonBUD.VALUES1),2)) ...
                        ' v2= matrix ' int2str(size(m.getProp(EEGComparisonBUD.VALUES2),1)) ' x ' int2str(size(m.getProp(EEGComparisonBUD.VALUES2),2)) ...
                        ' p=' m.getPropValue(EEGComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(EEGComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(EEGComparisonBUD.PERCENTILES) ...
                        ])
                    elseif isa(m,'EEGRandomComparisonBUD')
                    disp([Graph.NAME{m.getProp(EEGRandomComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(EEGRandomComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(EEGRandomComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(EEGRandomComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(EEGRandomComparisonBUD.THRESHOLD1) ...
                        ' g1=' m.getPropValue(EEGRandomComparisonBUD.GROUP1)...
                        ' v=' m.getPropValue(EEGRandomComparisonBUD.VALUES1) ...
                        ' rand=' m.getPropValue(EEGRandomComparisonBUD.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(EEGRandomComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(EEGRandomComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(EEGRandomComparisonBUD.PERCENTILES) ...
                        ])
                elseif isa(m,'EEGMeasureBUD')
                    disp([Graph.NAME{m.getProp(EEGMeasureBUD.CODE)} ...
                        ' param=' m.getPropValue(EEGMeasureBUD.PARAM) ...
                        ' notes=' m.getPropValue(EEGMeasureBUD.NOTES) ...
                        ' d=' m.getPropValue(EEGMeasureBUD.DENSITY) ...
                        ' t=' m.getPropValue(EEGMeasureBUD.THRESHOLD1) ...
                        ' g=' m.getPropValue(EEGMeasureBUD.GROUP1) ...
                        ' v= matrix ' int2str(size(m.getProp(EEGMeasureBUD.VALUES1),1)) ' x ' int2str(size(m.getProp(EEGMeasureBUD.VALUES1),2)) ...
                        ])
                end
            end
        end
        function [ms,mi] = getMeasures(ga,measurecode,g)
            % GETMEASURES gets available measures
            %
            % [MS,MI] = GETMEASURES(GA,MEASURECODE,G) returns the measures MS and hash table position
            %   MI of the measure specified by MEASURECODE calculated for a group G in graph analysis GA.
            %
            % See also EEGGraphAnalysisBUD.
            
            indices = find(ga.ht_measure{measurecode}~=0);
            indices = indices(reg2int(indices,EEGMeasureBUD.DENSITY_LEVELS)==g);
            
            mi = zeros(1,length(indices));
            ms = cell(1,length(indices));
            for i = 1:1:length(indices)
                mi(i) = ga.ht_measure{measurecode}(indices(i));
                ms{i} = ga.get(mi(i));
            end
        end
        function [m,mi] = getMeasure(ga,measurecode,g,density)
            % GETMEASURE gets measure from a given group at specified density
            %
            % [M,MI] = GETMEASURE(GA,MEASURECODE,G,DENSITY) returns the measure M and hash table position
            %   MI of the measure specified by MEASURECODE calculated for a group G at specified density
            %   DENSITY in graph analysis GA.
            %
            % See also EEGGraphAnalysisBUD.
            
            mt = EEGMeasureBUD( ...
                EEGMeasureBUD.CODE,measurecode, ...
                EEGMeasureBUD.GROUP1,g, ...
                EEGMeasureBUD.DENSITY,density ...                
                );
            
            [~,mi] = ga.existMeasure(mt);
            if mi>0
                m = ga.get(mi);
            else
                m = [];
            end
        end
        function [cs,ci] = getComparisons(ga,measurecode,g1,g2)
             % GETCOMPARISONS gets available comparisons
            %
            % [CS,CI] = GETCOMPARISONS(GA,MEASURECODE,G1,G2) returns the comparisons CS and hash table position
            %   CI of the comparison specified by MEASURECODE calculated for the groups G1 and G2 in graph 
            %   analysis GA.
            %
            % See also EEGGraphAnalysisBUD.
            
            [indices1t,indices2t] = find(ga.ht_comparison{measurecode}~=0);
            indices1 = indices1t(reg2int(indices1t,EEGMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,EEGMeasureBUD.DENSITY_LEVELS)==g2);
            indices2 = indices2t(reg2int(indices1t,EEGMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,EEGMeasureBUD.DENSITY_LEVELS)==g2);
            
            ci = zeros(1,length(indices1));
            cs = cell(1,length(indices1));
            for i = 1:1:length(indices1)
                ci(i) = ga.ht_comparison{measurecode}(indices1(i),indices2(i));                
                cs{i} = ga.get(ga.ht_comparison{measurecode}(indices1(i),indices2(i)));
            end
        end
        function [c,ci] = getComparison(ga,measurecode,g1,g2,density)
            % GETCOMPARISON gets comparison from given groups at specified density
            %
            % [C,CI] = GETCOMPARISON(GA,MEASURECODE,G1,G2,DENSITY) returns the comparison C and hash table 
            %   position CI of the comparison specified by MEASURECODE calculated for the groups G1 and G2
            %   at specified density DENSITY in graph analysis GA.
            %
            % See also EEGGraphAnalysisBUD.
            
            ct = EEGComparisonBUD( ...
                EEGComparisonBUD.CODE,measurecode, ...
                EEGComparisonBUD.GROUP1,g1, ...
                EEGComparisonBUD.GROUP2,g2, ...
                EEGComparisonBUD.DENSITY,density ...
                );
            
            [~,ci] = ga.existComparison(ct);
            if ci>0
                c = ga.get(ci);
            else
                c = [];
            end
        end
        function [ns,ni] = getRandomComparisons(ga,measurecode,g)
            % GETRANDOMCOMPARISONS gets available comparisons with random graphs
            %
            % [NS,NI] = GETRANDOMCOMPARISONS(GA,MEASURECODE,G) returns the comparisons with
            %   random graphs NS and hash table position NI of the measure specified by
            %   MEASURECODE calculated for a group G in graph analysis GA.
            %
            % See also EEGGraphAnalysisBUD.

            indices = find(ga.ht_random_comparison{measurecode}~=0);
            indices = indices(reg2int(indices,EEGMeasureBUD.DENSITY_LEVELS)==g);
            
            ni = zeros(1,length(indices));
            ns = cell(1,length(indices));
            for i = 1:1:length(indices)
                ni(i) = ga.ht_random_comparison{measurecode}(indices(i));
                ns{i} = ga.get(ni(i));
            end
        end
        function [n,ni] = getRandomComparison(ga,measurecode,g,density)
            % GETRANDOMCOMPARISON gets comparison with random graphs from given group at specified density
            %
            % [N,NI] = GETRANDOMCOMPARISON(GA,MEASURECODE,G,DENSITY) returns the comparisons
            %   with random graphs NS and hash table position NI of the measure specified by
            %   MEASURECODE calculated for a group G at specified density DENSITY in graph analysis GA.
            %
            % See also EEGGraphAnalysisBUD.
            
            nt = EEGRandomComparisonBUD( ...
                EEGRandomComparisonBUD.CODE,measurecode, ...
                EEGRandomComparisonBUD.GROUP1,g, ...
                EEGRandomComparisonBUD.DENSITY,density ...                
                );
            
            [~,ni] = ga.existRandom(nt);
            if ni>0
                n = ga.get(ni);
            else
                n = [];
            end
        end
        function m = calculate(ga,measurecode,g,density,varargin)
            % CALCULATE calculates measure
            %
            % M = CALCULATE(GA,MEASURECODE,G,DENSITY) returns the properties of the measure M after 
            %   calculating the measure specified by MEASURECODE for the group G at specified density 
            %   DENSITY in graph analysis GA.
            %
            % M = CALCULATE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
            %
            % See also EEGGraphAnalysisBUD, GraphBU.
            
            [m,mi] = ga.getMeasure(measurecode,g,density);

            if ~mi
                indices = find(ga.cohort.getGroup(g).getProp(Group.DATA)==true);
                res = [];
                threshold = [];
                for i = indices
                    graph = GraphBU(ga.A{i},'structure',ga.structure,'Density',density,varargin{:});
                    res = [res; graph.measure(measurecode)];
                    threshold = [threshold graph.threshold()];
                end            

                m = EEGMeasureBUD( ...
                    EEGMeasureBUD.CODE,measurecode, ...
                    EEGMeasureBUD.DENSITY,density, ...
                    EEGMeasureBUD.THRESHOLD1,threshold, ...
                    EEGMeasureBUD.GROUP1,g, ...
                    EEGMeasureBUD.VALUES1,res);
                ga.add(m)                
            end
        end
        function c = compare(ga,measurecode,g1,g2,density,varargin)
            % COMPARE calculates comparison
            %
            % C = COMPARE(GA,MEASURECODE,G1,G2,DENSITY) returns the properties of the comparison C after 
            %   calculating the measure specified by MEASURECODE for the groups G1 and G2 at specified density 
            %   DENSITY in graph analysis GA.
            %
            % C = COMPARE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
            %   Additional admissible properties are:
            %       verbose          -   print the progress of the permutation test on the command line
            %                            true (default) | false
            %       interruptible    -   time for parallel execution of other codes 
            %                            [default = 0]
            %       m                -   number of permutations
            %                            [default = 1e+1]
            %       longitudinal     -   whether to make a longitudinal comparison
            %                            [default = false]
            %
            % See also EEGGraphAnalysisBUD, GraphBU.
            
            % Whether to print progress messages to the command window [default = true]
            verbose = true;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'verbose')
                    verbose = varargin{n+1};
                end
            end
            
            % Whether the code should leave some time for parallel
            % execution of other codes [default = 0]
            interruptible = 0;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'interruptible')
                    interruptible = varargin{n+1};
                end
            end
            
            % Number of permutations
            M = 1e+1;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'m')
                    M = varargin{n+1};
                end
            end
            
            % Whether to make a longitudinal comparison [default = false]
            longitudinal = false;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'longitudinal')
                    longitudinal = varargin{n+1};
                end
            end
            
            [c,ci] = ga.getComparison(measurecode,g1,g2,density);
            
            if ~ci
                
                m1 = ga.calculate(measurecode,g1,density,varargin{:});
                values1 = m1.getProp(EEGMeasure.VALUES1);
                res1 = m1.mean();
                
                m2 = ga.calculate(measurecode,g2,density,varargin{:});
                values2 = m2.getProp(EEGMeasure.VALUES1);
                res2 = m2.mean();
                
                values = [values1; values2];
                                
                all1 = zeros(M,numel(res1));
                all2 = zeros(M,numel(res2));

                number_sub1 = size(values1,1);
                number_sub2 = size(values2,1);
                number_subtot = number_sub1+number_sub2;

                start = tic;
                for i = 1:1:M
                    if verbose
                        disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                    end
                    
                    if longitudinal
                        subs1 = [1:1:number_sub1];
                        subs2 = number_sub1 + [1:1:number_sub2];
                        max = min(numel(subs1),numel(subs2));
                        perm = sign(randn(1,max));
                        perm1 = subs1;
                        perm2 = subs2;
                        perm1(perm==1) = subs2(perm==1);
                        perm2(perm==1) = subs1(perm==1);                        
                    else
                        perm1 = sort( randperm(number_subtot,number_sub1) );
                        perm2 = [1:1:number_subtot];
                        perm2(perm1) = 0;
                        perm2 = perm2(perm2>0);
                    end
                    
                    valuesperm1 = values(perm1,:);
                    mperm1 = mean(valuesperm1,1);
                    
                    valuesperm2 = values(perm2,:);
                    mperm2 = mean(valuesperm2,1);
                    
                    all1(i,:) = reshape(mperm1,1,numel(mperm1));
                    all2(i,:) = reshape(mperm2,1,numel(mperm2));
                    
                    if interruptible
                        pause(interruptible)
                    end
                end
                dm = res2 - res1;
                dall = all2 - all1;
                
                p_single = pvalue1(dm,dall);
                p_double = pvalue2(dm,dall);
                percentiles = quantiles(dall,100);
                                
                c = EEGComparisonBUD( ...
                    EEGComparisonBUD.CODE,measurecode, ...
                    EEGComparisonBUD.DENSITY,(m1.getProp(EEGMeasureBUD.DENSITY) + m2.getProp(EEGMeasureBUD.DENSITY))/2, ...
                    EEGComparisonBUD.THRESHOLD1,m1.getProp(EEGMeasureBUD.THRESHOLD1), ...
                    EEGComparisonBUD.THRESHOLD2,m2.getProp(EEGMeasureBUD.THRESHOLD1), ...
                    EEGComparisonBUD.GROUP1,g1, ...
                    EEGComparisonBUD.VALUES1,res1, ...
                    EEGComparisonBUD.GROUP2,g2, ...
                    EEGComparisonBUD.VALUES2,res2, ...
                    EEGComparisonBUD.PVALUE1,p_single, ...
                    EEGComparisonBUD.PVALUE2,p_double, ...
                    EEGComparisonBUD.PERCENTILES,percentiles, ...
                    EEGComparisonBUD.PARAM,M);
                
                ga.add(c)
            end
        end
        function n = randomcompare(ga,measurecode,g,density,varargin)
            % RANDOMCOMPARE calculates comparison with random graphs
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,DENSITY) returns the properties of the comparison
            %   with random graphs N after calculating the measure specified by MEASURECODE for the group G
            %   at specified density DENSITY in graph analysis GA.
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
            %   Additional admissible properties are:
            %       verbose         -   print the progress of the permutation test on the command line
            %                           true (default) | false
            %       interruptible   -   time for parallel execution of other codes
            %                           [default = 0]
            %       m               -   number of permutations
            %                           [default = 1e+1]
            %       swaps           -   number of swaps to create random matrix
            %                           [default = 5]
            %
            % See also EEGGraphAnalysisBUD, GraphBU.

             % Whether to print progress messages to the command window [default = true]
            verbose = true;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'verbose')
                    verbose = varargin{n+1};
                end
            end
            
            % Whether the code should leave some time for parallel
            % execution of other codes [default = 0]
            interruptible = 0;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'interruptible')
                    interruptible = varargin{n+1};
                end
            end
            
            % Number of random matrixes to be compared with
            M = 1e+1;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'m')
                    M = varargin{n+1};
                end
            end
            
            % how much swaps to create random matrix
            bin_swaps = 5;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'swaps')
                    bin_swaps = varargin{n+1};
                end
            end
            
            [n,ni] = ga.getRandomComparison(measurecode,g,density);
            
            if ~ni
                m = ga.calculate(measurecode,g,density,varargin{:});
                res = m.mean();                    
                
                indices = find(ga.cohort.getGroup(g).getProp(Group.DATA)==true);
                start = tic;
                results = cell(length(indices),M);
                for i = 1:1:length(indices)
                    graph = GraphBU(ga.A{indices(i)},'structure',ga.structure,'Density',density,varargin{:});
                    for c = 1:1:M
                        if verbose
                            disp(['** RANDOM GRAPH - sampling #' int2str((i-1)*M+c) '/' int2str(M*length(indices)) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                        end
                        [random_gr,~] = graph.randomize(bin_swaps);
                        temp_res = random_gr.measure(measurecode);
                        results{i,c} = temp_res;
                        
                        if interruptible
                            pause(interruptible)
                        end
                        
                    end
                end
                
                 tmp_res = zeros(M,length(results{1,1}));
                 resall = zeros(length(indices),length(results{1,1}));
                 for c = 1:1:length(indices)
                     for i = 1:1:M
                         tmp_res(i,:) = results{c,i};
                     end
                     resall(c,:) = mean(tmp_res);
                 end
                 
                    p_single = pvalue1(res,resall);
                    p_double = pvalue2(res,resall);
                    percentiles = quantiles(resall,100);
                    rand_res = mean(resall);
                    
                    n = EEGRandomComparisonBUD( ...
                        EEGRandomComparisonBUD.CODE,measurecode, ...
                        EEGRandomComparisonBUD.DENSITY,m.getProp(EEGMeasureBUD.DENSITY), ...
                        EEGRandomComparisonBUD.THRESHOLD1,m.getProp(EEGMeasureBUD.THRESHOLD1), ...
                        EEGRandomComparisonBUD.GROUP1,g, ...
                        EEGRandomComparisonBUD.VALUES1,res, ...
                        EEGRandomComparisonBUD.RANDOM_COMP_VALUES,rand_res, ...
                        EEGRandomComparisonBUD.PVALUE1,p_single, ...
                        EEGRandomComparisonBUD.PVALUE2,p_double, ...
                        EEGRandomComparisonBUD.PERCENTILES,percentiles, ...
                        EEGRandomComparisonBUD.PARAM,M);
                    
                    ga.add(n)
            end
        end
    end
    methods (Access = protected)
        function initialize_hashtables(ga)
            % INITIALIZE_HASTABLES intializes hashtables
            %
            % INITIALIZE_HASTABLES(GA) initalizes the sparse matrices to be
            %   used as hashtables. 
            %
            % See also EEGGraphAnalysisBUD.
            
            ga.ht_measure = {};
            ga.ht_comparison = {};
            ga.ht_random_comparison = {};
            
            for m = 1:1:GraphBU.measurenumber()
                D = ga.cohort.groupnumber() * EEGMeasureBUD.DENSITY_LEVELS;
                ga.ht_measure{GraphBU.MEASURES_BU(m)} = sparse(1,D);
                ga.ht_comparison{GraphBU.MEASURES_BU(m)} = sparse(D,D);
                ga.ht_random_comparison{GraphBU.MEASURES_BU(m)} = sparse(1,D);
            end
        end
    end
    methods (Static)
        function index = getIndex(m)
            % GETINDEX calculates measure index
            %
            % GETINDEX(M) calculates the index of the measure M.
            %
            % See also EEGGraphAnalysisBUD.
            
            Check.isa('Error: The measure m must be a EEGMeasureBUD',m,'EEGMeasureBUD')
            
            if m.isMeasure()
                [~,g,d] = m.hash();
                index = int2reg(g,d,EEGMeasureBUD.DENSITY_LEVELS);
            elseif m.isComparison()
                [~,g1,g2,d] = m.hash();
                index = [int2reg(g1,d,EEGMeasureBUD.DENSITY_LEVELS) int2reg(g2,d,EEGMeasureBUD.DENSITY_LEVELS)];
            else % m.isRandom()
                [~,g,d] = m.hash();
                index = int2reg(g,d,EEGMeasureBUD.DENSITY_LEVELS);
            end
            
        end
        function class = elementClass()
            % ELEMENTCLASS element class name
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'EEGMeasureBUD'.
            %
            % See also EEGGraphAnalysisBUD, EEGMeasureBUD.
            
            class = 'EEGMeasureBUD';
        end
        function m = element()
            % ELEMENT creates new EEG measure of a binary undirected graph
            %
            % M = ELEMENT() returns a EEG measure M of a binary undirected graph with fixed density.
            %
            % See also EEGGraphAnalysisBUD, EEGMeasureBUD.
            
            m = EEGMeasureBUD();
        end
    end
end