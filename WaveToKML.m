function WaveToKML

load waveforms_All


for i=1:length(waveform)
    wave=waveform{i};
    betas=[];
    for k=1:length(wave.station) 
        betas=[betas wave.station{k}.betaFactorRaw]; 
    end
    betamax=max(betas);
    betamin=min(betas);
    betanorm = @(x) (x-betamin)/(betamax-betamin);
    FH=fopen('temp.html','w');
    fprintf(FH,'var stations = {\n');
    for j=1:length(wave.station)
        station=wave.station{j};
        fprintf(FH,'%s: {\n',regexprep(station.name,'[^a-zA-Z0-9]',''));
        fprintf(FH,'center: {lat: %4.4f, lng: %4.4f},\n',station.latitude,station.longitude);
        fprintf(FH,'beta: %2.4f,\n',station.betaFactorRaw);
        fprintf(FH,'betaNorm: %2.4f,\n',betanorm(station.betaFactorRaw));
        fprintf(FH,'betaFactorAverage: "%2.4f"\n',station.betaFactorAverage);
        fprintf(FH,'},\n');
    end
    fprintf(FH,'};\n');
    
    fclose(FH);
    system(sprintf('cat head.html temp.html foot.html > %s.html',wave.name));
    system('rm temp.html');
end