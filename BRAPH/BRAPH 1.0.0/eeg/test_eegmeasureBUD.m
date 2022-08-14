% File to test the use of EEGMeasureBUD.
%
% See also EEGMeasureBUD.

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

%% creating subects, groups and cohort

sub1 = EEGSubject( ...
    EEGSubject.CODE,'SUB1', ...
    EEGSubject.AGE,75, ...
    EEGSubject.GENDER,EEGSubject.GENDER_FEMALE, ...
    EEGSubject.DATA,10*rand(length(atlas)), ...
    EEGSubject.NOTES,'none');

sub2 = EEGSubject( ...
    EEGSubject.CODE,'SUB2', ...
    EEGSubject.AGE,75, ...
    EEGSubject.GENDER,EEGSubject.GENDER_FEMALE, ...
    EEGSubject.DATA,10*rand(length(atlas)), ...
    EEGSubject.NOTES,'none');

sub3 = EEGSubject( ...
    EEGSubject.CODE,'SUB3', ...
    EEGSubject.AGE,75, ...
    EEGSubject.GENDER,EEGSubject.GENDER_FEMALE, ...
    EEGSubject.DATA,10*rand(length(atlas)), ...
    EEGSubject.NOTES,'none');

sub4 = EEGSubject( ...
    EEGSubject.CODE,'SUB4', ...
    EEGSubject.AGE,75, ...
    EEGSubject.GENDER,EEGSubject.GENDER_FEMALE, ...
    EEGSubject.DATA,10*rand(length(atlas)), ...
    EEGSubject.NOTES,'none');

subjects = {sub1 sub2 sub3 sub4};

cohort = EEGCohort(atlas,subjects);

g1 = Group( ...
    Group.NAME,'gr1', ...
    Group.DATA,[1 1 0 0], ...
    Group.NOTES,'notes gr 1');
g2 = Group( ...
    Group.NAME,'gr2', ...
    Group.DATA,[0 0 1 1], ...
    Group.NOTES,'notes gr 2');
cohort.addgroup(g1)  % add group g1 to cohort
cohort.addgroup(g2)  % add group g2 to cohort
cohort.disp()

%% create BUD measure

measure = EEGMeasureBUD( ...
    EEGMeasureBUD.CODE,3, ...
    EEGMeasureBUD.NOTES,'Measure BUD', ...
    EEGMeasureBUD.DENSITY,50)

%% hash, isMeasure, isComparison

[code,g,d] = measure.hash();
bool1 = measure.isMeasure();
bool2 = measure.isComparison();

%% getDefaults

defaults = measure.getDefaults();
 
%% mean, std, var

mean = measure.mean()
std = measure.std()
var = measure.var()