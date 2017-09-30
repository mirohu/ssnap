% Should be run after running SSNAP.m
% Loops through all matrices and calculates the signal energy percentage
% per each stimulus and variance thereof. RUN from inside the Folder of
% Interest, ie., the folder generated by running SSNAP.m

list1 = dir('*.xlsx');
datasheet = xlsread(list1.name);

TrialList = datasheet(:,1)';
PsiList = datasheet(:,2)';
PixelsList = datasheet(:,3)';
nOscillationsList = datasheet(:,4)';
ThetaList = datasheet(:,5)';
NoiseContrast = datasheet(:,6)';
GaborContrast = datasheet(:,7)';



%Verify that the elements in PixelsList, nOscillationsList, ThetaList, NC
%and GC are the same across all the board. If so, EXECUTE!

if not(all(PixelsList == PixelsList(1))) | not(all(nOscillationsList == nOscillationsList(1))) |not(all(NoiseContrast == NoiseContrast(1))) | not(all(GaborContrast == GaborContrast(1)))
    disp('Error! Elements in the General Parameters Matrix are like, totally messed up, dude.')
else %assuming the .xlsx file variables are normal, it should execute the following:
   list2 = ls(['non_normal_dirtysig*.mat']); %builds a list of 
   elements = size(list2, 1);
   PE_list = zeros(elements,1)';
   for i = 1:elements
       Q = load(list2(i,:));
       PE_list(i) = sigenergy(Q.non_normal_dirtysig,PixelsList(1),nOscillationsList(1),ThetaList(1),PsiList(i),true,elements,0.1);
   disp(strcat('Completed: ', num2str(i/elements * 100), '%'))
   end
end