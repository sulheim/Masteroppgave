set(0,'defaultTextUnits','Normalized');

% specify filename here ------------------
fnameBase = 'D:\Phase shift project\Ultrasound image data\2014-05-02-09-38-20.iq';
%Use IQ modulated data
% specify frame number here ------------------
frameNumber= 1;
% ------------------------------------------
[Idata,Qdata,param] = VsiBModeIQ(fnameBase, '.bmode', frameNumber);
% ------------------------------------------
%real and imaginary values of the IQ data are loaded into Idata and Qdata,
%and param contains information abput the dataset
BmodeNumSamples = param.BmodeNumSamples;
%BmodeNumSamples are the number of data points recorded in axial direction
BmodeNumFocalZones = param.BmodeNumFocalZones;
%Number of focal zones apllied for imaging
BmodeNumLines = param.BmodeNumLines; 
%Number of datapoints in lateral direction
BmodeDepthOffset = param.BmodeDepthOffset;

BmodeDepth = param.BmodeDepth; 
%?
BmodeWidth = param.BmodeWidth; 
%?
BmodeQuad2x = param.BmodeQuad2x;
%?
BmodeRxFrequency = param.BmodeRxFrequency; %Hz
BmodeTxFrequency = param.BmodeTxFrequency; %Hz
% ------------------------------------------
% Setup the Rx frequency
fs= BmodeRxFrequency;
f_rf = fs; % reconstruct to the original Rx freq in the param file
if strcmp(BmodeQuad2x,'true') 
    fs = fs*2; % actual Rx freq is double because of Quad 2x
    IntFac = 8;
else
    IntFac = 16;
end
fs_int = fs*IntFac;

%IntFac is a factor applied to enlarge the size of image for interpolation
%of IQ data. Number of datapoints in lateral direction is the same, but the
%number of datapoints in axial direction is multiplied by a factor IntFac

% Initialize
IdataInt = zeros(BmodeNumSamples*IntFac, BmodeNumLines);
QdataInt = zeros(BmodeNumSamples*IntFac, BmodeNumLines);
RfData = zeros(BmodeNumSamples*IntFac, BmodeNumLines);
t = [0:1/fs_int:((BmodeNumSamples*IntFac)-1)/fs_int];

% Interpolate I/Q and reconstruct RF
for i=1:BmodeNumLines
    IdataInt(:,i) = interp(Idata(:,i), IntFac);
    QdataInt(:,i) = interp(Qdata(:,i), IntFac);
    % phase term in complex exponential modified for rev. 1.1
    RfData(:,i) = real(complex(IdataInt(:,i), QdataInt(:,i)).*exp(sqrt(-1)*(2*pi*f_rf*t')));
end

if strcmp(BmodeQuad2x,'true')
    RfData= -RfData;  
end

% plot B-Mode image and reconstructed RF line
% specify which RF line to plot 
% specify range for RF data plot  
% RF samples range from 1 to BmodeNumSamples*IntFac
% ------------------------
lineNumber= 250;
sampleWindow= 2000:5000;
% ----------------------------------
fig1= figure('units','normalized','position',[.01 .55 .4 .35]);
imagesc(10*log10(Idata.^2 + Qdata.^2)); 
title(fnameBase,'interpreter','none');
colormap('gray'); colorbar
fig2= figure('units','normalized','position',[.01 .10 .4 .35]);
plot(sampleWindow,RfData(sampleWindow,lineNumber)); grid;
title(fnameBase,'interpreter','none');
text(.8,.95,['line ' num2str(lineNumber)]);
xlabel('RF sample number')






