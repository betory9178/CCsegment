function CCcheck(orginfile,ccfile,acpcfile,IDrange)

% orginfile: cells, T1 files of subjects, "XXX_nunorm.nii"
% ccfile: cells, segmented CC files, "ccmsp_XXX_nunorm.nii"
% acpcfile:cells, ACPC coordinates files, "XXX_ACPC.txt"
% IDrange: [a:b] group of some numbers 

niftl=length(orginfile);
ccl=length(ccfile);

for i=1:niftl
    [~,nameog,~]=fileparts(orginfile{i});
    IDSog{i,1}=nameog(1:end-7); % be careful name length
end
for i=1:ccl
    [~,namecc,~]=fileparts(ccfile{i});
    IDScc{i,1}=namecc(7:end-11); % be careful name length
end

if niftl~=ccl
    [~,iog,icc] = intersect(IDSog,IDScc);
    [~,fog]= setdiff(IDSog,IDScc);
    
    orgins=[orginfile(iog);orginfile(fog)];
    ccs=[ccfile(icc);repmat({''},length(fog),1)];
    aps=[acpcfile(iog);acpcfile(fog)];
    
else
    [~,iog,icc] = intersect(IDSog,IDScc);
    orgins=orginfile(iog);
    ccs=ccfile(icc);
    aps=acpcfile(iog);
    
end

for k=1:length(IDrange)
    i=IDrange(k);
    fid=importdata(aps{i},' ',20);
    ACord=str2num(fid{8}); % might be different in several versions
    PCord=str2num(fid{10}); % might be different in several versions
    
    j=round((ACord(1)+PCord(1))/2);
    
    origf=load_untouch_nii(orgins{i});
    nx=origf.hdr.dime.dim(2);
    [~,nme,~]=fileparts(orgins{i});
    mean(reshape(origf.img,1,[]))
    y=quantile(reshape(origf.img,1,[]),0.95); % could be adjusted
    
    if j>1 && j<nx
        
        a=' -s ortho ';
        b=' -xz 1500 -yz 100 -zz 100 -ls 14 -lo horizontal -yh -zh -bg 0 0 0 -fg 1 1 1 -cc 0 1 0 -cbl top -cbs top-left -p 3 -xc 0 0 -yc 0 0 -zc 0 0 ';
        c=[' -n "' nme '" -ot volume -a 100 -b 50 -c 50 -or 0 0 -dr 0 ' num2str(y) ' -cr 0 6000 -cm greyscale -cmr 256 -in none -ns 100 -bf 0.2 -r 100 -dt 0.01 -nis 10 -v 0 '];
        d=[' -n "' nme '_CC" -ot volume -a 100 -b 50 -c 50 -or 0 0 -dr 0 1 -cr 0 1.01 -cm red -cmr 256 -in none -ns 100 -bf 0.2 -r 100 -dt 0.01 -nis 10 -v 0'];
        
        cmd= ['unset LD_LIBRARY_PATH;source /etc/profile;fsleyes ' a ' -vl ' num2str(j) ' 0 0 -ds ' orgins{i} b orgins{i} c ccs{i} d];
        system(cmd)
        
    else
        j=round(nx/2);
        a=' -s ortho ';
        b=' -xz 1500 -yz 100 -zz 100 -ls 14 -lo horizontal -yh -zh -bg 0 0 0 -fg 1 1 1 -cc 0 1 0 -cbl top -cbs top-left -p 3 -xc 0 0 -yc 0 0 -zc 0 0 ';
        c=[' -n "' nme '" -ot volume -a 100 -b 50 -c 50 -or 0 0 -dr 0 ' num2str(y) ' -cr 0 6000 -cm greyscale -cmr 256 -in none -ns 100 -bf 0.2 -r 100 -dt 0.01 -nis 10 -v 0 '];
        
        cmd= ['unset LD_LIBRARY_PATH;source /etc/profile;fsleyes ' a ' -vl ' num2str(j) ' 0 0 -ds ' orgins{i} b orgins{i} c];
        system(cmd)
        
    end
    
end

end