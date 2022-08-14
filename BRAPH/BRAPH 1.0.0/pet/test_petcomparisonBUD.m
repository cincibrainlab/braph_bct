% File to test the use of PETComparisonBUD.
%
% See also PETComparisonBUD.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create BrainAtlas from BrainRegion list

br1 = BrainRegion(BrainRegion.LABEL,'REG. 1', ...
    BrainRegion.NAME,'Brain Region 1', ...
    BrainRegion.X,1, ...
    BrainRegion.Y,1, ...
    BrainRegion.Z,1, ...
    BrainRegion.HS,BrainRegion.HS_LEFT, ...
    BrainRegion.NOTES,'notes1 ...');

br2 = BrainRegion(BrainRegion.LABEL,'REG. 2', ...
    BrainRegion.NAME,'Brain Region 2', ...
    BrainRegion.X,2, ...
    BrainRegion.Y,-2, ...
    BrainRegion.Z,2, ...
    BrainRegion.HS,BrainRegion.HS_RIGHT, ...
    BrainRegion.NOTES,'notes2 ...');

br3 = BrainRegion(BrainRegion.LABEL,'REG. 3', ...
    BrainRegion.NAME,'Brain Region 3', ...
    BrainRegion.X,3, ...
    BrainRegion.Y,3, ...
    BrainRegion.Z,-3, ...
    BrainRegion.HS,BrainRegion.HS_LEFT, ...
    BrainRegion.NOTES,'notes3 ...');

br4 = BrainRegion(BrainRegion.LABEL,'REG. 4', ...
    BrainRegion.NAME,'Brain Region 4', ...
    BrainRegion.X,-4, ...
    BrainRegion.Y,4, ...
    BrainRegion.Z,4, ...
    BrainRegion.HS,BrainRegion.HS_RIGHT, ...
    BrainRegion.NOTES,'notes4 ...');

br5 = BrainRegion(BrainRegion.LABEL,'REG. 5', ...
    BrainRegion.NAME,'Brain Region 5', ...
    BrainRegion.X,-5, ...
    BrainRegion.Y,-5, ...
    BrainRegion.Z,5, ...
    BrainRegion.HS,BrainRegion.HS_LEFT, ...
    BrainRegion.NOTES,'notes5 ...');

brs = {br1 br2 br3 br4 br5};
atlas = BrainAtlas(brs,BrainAtlas.NAME,'Atlas1');

%% create subjects

sub1 = PETSubject( ...
    PETSubject.CODE,'SUB1', ...
    PETSubject.AGE,71, ...
    PETSubject.GENDER,PETSubject.GENDER_FEMALE, ...
    PETSubject.DATA,rand(1,atlas.length()), ...
    PETSubject.NOTES,'none 1');

sub2 = PETSubject( ...
    PETSubject.CODE,'SUB2', ...
    PETSubject.AGE,72, ...
    PETSubject.GENDER,PETSubject.GENDER_MALE, ...
    PETSubject.DATA,rand(1,atlas.length()), ...
    PETSubject.NOTES,'none 2');

sub3 = PETSubject( ...
    PETSubject.CODE,'SUB3', ...
    PETSubject.AGE,73, ...
    PETSubject.GENDER,PETSubject.GENDER_FEMALE, ...
    PETSubject.DATA,rand(1,atlas.length()), ...
    PETSubject.NOTES,'none 3');

sub = {sub3 sub2 sub1};

%% create cohort

cohort = PETCohort(atlas,sub,PETCohort.NAME,'Cohort Trial');

%% create BUD comparison

comparison = PETComparisonBUD( ...
    PETComparisonBUD.CODE,3, ...
    PETComparisonBUD.NOTES,'Comparison BUD', ...
    PETComparisonBUD.DENSITY,20, ...
    PETComparisonBUD.GROUP1,1, ...
    PETComparisonBUD.GROUP2,5)

%% hash, isMeasure, isComparison

[code,g,d] = comparison.hash();
bool1 = comparison.isMeasure()
bool2 = comparison.isComparison()
bool3 = comparison.isRandom()

%% getTags, getFormats

tags = comparison.getTags()
formats = comparison.getFormats()
 