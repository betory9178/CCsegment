function CCnorm(orig,output,coregflag,cropflag,CIVETpath)
%
% orig: origin T1 nifti file
% output: output path
% coregflag: 1 = do acpc coregister 
% cropflag: 1 = do crop;
%

[path,~,~]=fileparts(orig);
[~,name,~]=fileparts(path);

tmpath=g_ls([output '/' name]);
if (isempty(tmpath))
    cmk=['mkdir ' output '/' name]; 
    system(cmk);
end
outputpath=[output '/' name];

if cropflag==1
    cbet=['source /etc/profile;robustfov -i ' orig ' -r ' [outputpath '/' name '_crop']];
    system(cbet)
    cuzp=['gunzip -f ' [outputpath '/' name '_crop.nii.gz']];
    system(cuzp)
    file4trans=[outputpath '/' name '_crop.nii'];
else
    file4trans=orig;
end

cn2m = ['source /etc/profile;nii2mnc ' file4trans ' ' [outputpath '/' name '.mnc']];
system(cn2m)

if coregflag==1
    
    creg=['source /etc/profile;' CIVETpath '/CIVET/quarantines/Linux-x86_64/CIVET-2.1.0/progs/multispectral_stx_registration -nothreshold -clobber -single-stage -lsq6 -modeldir ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/mni-models -model mni_icbm152_t1_tal_nlin_sym_09a -source_mask targetOnly ' [outputpath '/' name '.mnc'] ' T2.mnc PD.mnc ' [outputpath '/' name '.xfm '] ' T2PD_to_tal.xfm'];
    system(creg);
    
    capl=['source /etc/profile;mincresample -transform ' [outputpath '/' name '.xfm '] ' -like ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/ICBM/icbm_template_1.00mm.mnc -trilinear ' [outputpath '/' name '.mnc'] ' ' [outputpath '/' name '_reged.mnc']];    
    system(capl);
    
    file4norm = [outputpath '/' name '_reged.mnc'];
else
    file4norm = [outputpath '/' name '.mnc'];
end


% cnucn=['source /etc/profile;nu_correct_norm ' file4norm ' ' [outputpath '/' name '_nunorm.mnc']];
% system(cnucn)


% cm2n=['source /etc/profile;mnc2nii -short -signed -nii ' [outputpath '/' name '_nunorm.mnc'] ' ' [outputpath '/' name '_nunorm.nii']];
cm2n=['source /etc/profile;mnc2nii -short -signed -nii ' file4norm ' ' [file4norm(1:end-4) '.nii']];
system(cm2n)

end