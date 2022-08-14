classdef fMRIRandomComparisonWU < fMRIMeasureWU
    % fMRIRandomComparisonWU < fMRIMeasureWU : Weighted undirected fMRI random comparison
    %   fMRIRandomComparisonWU represents fMRI comparison of weighted undirected graph with random graphs.
    %
    % fMRIRandomComparisonWU properties (Access = protected):
    %   props   -   cell array of object properties < ListElement
    %
    % fMRIComparisonBUT properties (Constants):
    %   CODE                    -   code numeric code < fMRIMeasure
    %   CODE_TAG                -   code tag < fMRIMeasure
    %   CODE_FORMAT             -   code format < fMRIMeasure
    %   CODE_DEFAULT            -   code default < fMRIMeasure
    %
    %   PARAM                   -   parameters numeric code < fMRIMeasure
    %   PARAM_TAG               -   parameters tag < fMRIMeasure
    %   PARAM_FORMAT            -   parameters format < fMRIMeasure
    %   PARAM_DEFAULT           -   parameters default < fMRIMeasure
    %
    %   NOTES                   -   notes numeric code < fMRIMeasure
    %   NOTES_TAG               -   notes tag < fMRIMeasure
    %   NOTES_FORMAT            -   notes format < fMRIMeasure
    %   NOTES_DEFAULT           -   notes default < fMRIMeasure
    %
    %   GROUP1                  -   group1 numeric code < fMRIMeasure
    %   GROUP1_TAG              -   group1 tag < fMRIMeasure
    %   GROUP1_FORMAT           -   group1 format < fMRIMeasure
    %   GROUP1_DEFAULT          -   group1 default < fMRIMeasure
    %
    %   VALUES1                 -   values1 numeric code < fMRIMeasure
    %   VALUES1_TAG             -   values1 tag < fMRIMeasure
    %   VALUES1_FORMAT          -   values1 format < fMRIMeasure
    %   VALUES1_DEFAULT         -   values1 default < fMRIMeasure
    %
    %   RANDOM_COMP_VALUES      -   random graph values numeric code
    %   RANDOM_COMP_TAG         -   random graph values tag
    %   RANDOM_COMP_FORMAT      -   random graph values format
    %   RANDOM_COMP_DEFAULT     -   random graph values default
    %
    %   PVALUE1                 -   one tailed p-value numeric code
    %   PVALUE1_TAG             -   one tailed p-value tag
    %   PVALUE1_FORMAT          -   one tailed p-value format
    %   PVALUE1_DEFAULT         -   one tailed p-value default
    %
    %   PVALUE2                 -   two tailed p-value numeric code
    %   PVALUE2_TAG             -   two tailed p-value tag
    %   PVALUE2_FORMAT          -   two tailed p-value format
    %   PVALUE2_DEFAULT         -   two tailed p-value default
    %
    %   PERCENTILES             -   percentiles numeric code
    %   PERCENTILES_TAG         -   percentiles tag
    %   PERCENTILES_FORMAT      -   percentiles format
    %   PERCENTILES_DEFAULT     -   percentiles default
    %
    % fMRIRandomComparisonWU methods:
    %   fMRIRandomComparisonWU  -   constructor
    %   setProp                 -   sets property value < ListElement
    %   getProp                 -   gets property value, format and tag < ListElement
    %   getPropValue            -   string of property value < ListElement
    %   getPropFormat           -   string of property format < ListElement
    %   getPropTag              -   string of property tag < ListElement
    %   diff                    -   difference between two measures
    %   CI                      -   confidence interval calculated for a comparison
    %   isMeasure               -   return true if measure
    %   isComparison            -   return true if comparison
    %   isRandom                -   return true if comparison with random graphs
    %
    % fMRIRandomComparisonWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIMeasureWU, fMRIRandomComparisonBUD, fMRIRandomComparisonBUT.

    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % measure values group 2
        RANDOM_COMP_VALUES = fMRIMeasureWU.propnumber() + 1
        RANDOM_COMP_TAG = 'random graph values'
        RANDOM_COMP_FORMAT = BNC.NUMERIC
        RANDOM_COMP_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = fMRIMeasureWU.propnumber() + 2
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = fMRIMeasureWU.propnumber() + 3
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN
        
        % percentiles
        PERCENTILES = fMRIMeasureWU.propnumber() + 4
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function n = fMRIRandomComparisonWU(varargin)
            % FMRIRANDOMCOMPARISONWU() creates weighted undirected fMRI comparisons with random graphs.
            %
            % FMRIRANDOMCOMPARISONWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1,
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %       FMRIRandomComparisonWU.CODE                 -   numeric
            %       FMRIRandomComparisonWU.PARAM                -   numeric
            %       FMRIRandomComparisonWU.NOTES                -   char
            %       FMRIRandomComparisonWU.GROUP1               -   numeric
            %       FMRIRandomComparisonWU.VALUES1              -   numeric
            %       FMRIRandomComparisonWU.RANDOM_COMP_VALUES   -   numeric
            %       FMRIRandomComparisonWU.PVALUE1              -   numeric
            %       FMRIRandomComparisonWU.PVALUE2              -   numeric
            %       FMRIRandomComparisonWU.PERCENTILES          -   numeric
            %
            % See also fMRIRandomComparisonWU.

            n = n@fMRIMeasureWU(varargin{:});
        end
        function d = diff(n)
            % DIFF difference between two measures
            %
            % D = DIFF(N) returns the difference D between the two measures that are constituents
            %   of the comparison with random graphs N.
            %
            % See also fMRIRandomComparisonWU.

            d = n.getProp(fMRIRandomComparisonBUD.RANDOM_COMP_VALUES)-n.getProp(fMRIRandomComparisonBUD.VALUES1);
        end
        function ci = CI(n,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(N,P) returns the confidence interval CI of the comparison
            %   with random graphs N given the P-quantiles of the percentiles of N.
            %
            % See also fMRIRandomComparisonWU.
            
            p = round(p);
            percentiles = n.getProp(fMRIRandomComparisonWU.PERCENTILES);
            if p==50
                ci = percentiles(51,:);
            elseif p>=0 && p<50
                ci = [percentiles(p+1,:); percentiles(101-p,:)];
            else
                ci = NaN;
            end
        end
        function bool = isMeasure(n)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(N) returns false for comparison with random graphs.
            %
            % See also fMRIRandomComparisonWU, isComparison, isRandom.

            bool = false;
        end
        function bool = isComparison(n)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(N) returns false for comparison with random graphs.
            %
            % See also fMRIRandomComparisonWU, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(n)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(N) returns true for comparison with random graphs.
            %
            % See also fMRIRandomComparisonWU, isMeasure, isComparison.

            bool = true;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of fMRIComparisonBUD.
            %
            % See also fMRIComparisonWU.

            N = fMRIMeasureWU.propnumber() + 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIComparisonBUD.
            %
            % See also fMRIComparisonWU, ListElement.
            
            tags = [ fMRIMeasureWU.getTags() ...
                fMRIRandomComparisonWU.RANDOM_COMP_TAG ...
                fMRIRandomComparisonWU.PVALUE1_TAG ...
                fMRIRandomComparisonWU.PVALUE2_TAG ...
                fMRIRandomComparisonWU.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIComparisonWU.
            %
            % See also fMRIComparisonWU, ListElement.
            
            formats = [fMRIMeasureWU.getFormats() ...
                fMRIRandomComparisonWU.RANDOM_COMP_FORMAT ...
                fMRIRandomComparisonWU.PVALUE1_FORMAT ...
                fMRIRandomComparisonWU.PVALUE2_FORMAT ...
                fMRIRandomComparisonWU.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of fMRIComparisonWU.
            %
            % See also fMRIComparisonWU, ListElement.
            
            defaults = [fMRIMeasureWU.getDefaults() ...
                fMRIRandomComparisonWU.RANDOM_COMP_DEFAULT ...
                fMRIRandomComparisonWU.PVALUE1_DEFAULT ...
                fMRIRandomComparisonWU.PVALUE2_DEFAULT ...
                fMRIRandomComparisonWU.PERCENTILES_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRIComparisonWU.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRIComparisonWU, ListElement.
            
            options = {};
        end
    end
end