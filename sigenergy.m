

function PE = sigenergy(non_normal_dirtysig, pixels, nOscillations, theta, pShift, graph_boolean, elements, contrast_sigma)


%% initialize empty energy maps

Wig1 = zeros(pixels);

Wig2 = zeros(pixels);

% Initialize Cleansig and Dirtysig
cleansig = dwntrast((sinwav(pixels,nOscillations,theta,pShift)),contrast_sigma);
cleansig = cleansig - mean(cleansig(:));


%% The problem: 
parfor i=1:pixels
    for j=1:pixels
        thetarange = linspace(theta-30,theta+30,pixels); 
        xirange = linspace(1,3,pixels);
        std = dwntrast((sinwav(pixels,xirange(j)*4,thetarange(i),pShift)),contrast_sigma);
        
        crr1 = sqrt( (xcorr2_fft(cleansig,cos(std))).^2 + (xcorr2_fft(cleansig,sin(std))).^2 );
        crr2 = sqrt( (xcorr2_fft(non_normal_dirtysig,cos(std))).^2 + (xcorr2_fft(non_normal_dirtysig,sin(std))).^2 );
       
        
        % to build Wav and Wmx as well, use these
%         [Wav1 Wmx1 ig1] = metrica(crr1);
%         [Wav2 Wmx2 ig2] = metrica(crr2);
        ig1 = integr(crr1);
        ig2 = integr(crr2);
        
        %av1 = mean(crr1(:));
        %av2 = mean(crr2(:));
       
       % Wav1(i,j) = av1;
       % Wmx1(i,j) = mx1;
       Wig1(i,j) = ig1;
       Wig2(i,j) = ig2;
       % Wmx2(i,j) = mx2;
       % Wig2(i,j) = ig2;
        
        
     end
     disp(strcat(num2str(  (i/pixels * 100) / elements ) , '%'))
end



if graph_boolean == true


    subplot(1,2,1)
    tig1 = 'Integration Energy of Noiseless Signal';
    pic(Wig1,tig1)
    hold on

    XTL = {'\theta = -30','\theta =0','\theta = +30'};
    Ticks = [0 pixels/2 pixels];
    YTL = {'\xi = 1', '\xi = 2', '\xi = 3'};
    set(gca, 'xtick', Ticks)
    set(gca, 'xticklabel', XTL)
    set(gca, 'ytick', Ticks)
    set(gca, 'yticklabel', YTL)


    subplot(1,2,2)
    tig2 = 'Integration Energy of Noisy Signal';
    pic(Wig2,tig2)
    hold on

    XTL = {'\theta = -30','\theta =0','\theta = +30'};
    Ticks = [0 pixels/2 pixels];
    YTL = {'\xi = 1', '\xi = 2', '\xi = 3'};
    set(gca, 'xtick', Ticks)
    set(gca, 'xticklabel', XTL)
    set(gca, 'ytick', Ticks)
    set(gca, 'yticklabel', YTL)

else
    %do nothing
end

PE = max(Wig2(:))/max(Wig1(:));

