function LongNorm(imt1,imt2,tpflag,output,cropflag,CIVETpath)
%
% orig: origin T1 nifti file
% output: output path
% cropflag: 1 = do crop;
%

if tpflag==12
    [~,fntp1,~]=fileparts(imt1);
    imt1path=g_ls([output '/' fntp1]);
    if (isempty(imt1path))
        cmkt1=['mkdir ' output '/' fntp1];
        system(cmkt1);
        pathtp1=[output '/' fntp1];
    else
        pathtp1=[output '/' fntp1];
    end
    
    [~,fntp2,~]=fileparts(imt2);
    imt2path=g_ls([output '/' fntp2]);
    if (isempty(imt2path))
        cmkt2=['mkdir ' output '/' fntp2];
        system(cmkt2);
        pathtp2=[output '/' fntp2];
    else
        pathtp2=[output '/' fntp2];
    end
    
    if cropflag==1
        cropchecktp1=g_ls([pathtp1 '/' fntp1 '_crop.nii']);
        cropchecktp2=g_ls([pathtp2 '/' fntp2 '_crop.nii']);
        if isempty(cropchecktp1)
            cbet1=['source /etc/profile;robustfov -i ' imt1 ' -r ' [pathtp1 '/' fntp1 '_crop']];
            system(cbet1)
            cuzp1=['gunzip -f ' [pathtp1 '/' fntp1 '_crop.nii.gz']];
            system(cuzp1)
            tp14trans=[pathtp1 '/' fntp1 '_crop.nii'];
        else
            tp14trans=cropchecktp1{1};
        end
        
        if isempty(cropchecktp2)
            cbet2=['source /etc/profile;robustfov -i ' imt2 ' -r ' [pathtp2 '/' fntp2 '_crop']];
            system(cbet2)
            cuzp2=['gunzip -f ' [pathtp2 '/' fntp2 '_crop.nii.gz']];
            system(cuzp2)
            tp24trans=[pathtp2 '/' fntp2 '_crop.nii'];
        else
            tp24trans=cropchecktp2{1};
        end
    else
        tp14trans=imt1;
        tp24trans=imt2;
    end
    
    c4tm1 = ['source /etc/profile;nii2mnc ' tp14trans ' ' [pathtp1 '/' fntp1 '.mnc']];
    system(c4tm1)
    imt1mnc=[pathtp1 '/' fntp1 '.mnc'];
    imt1xfm=[pathtp1 '/' fntp1 '.xfm'];
    c4tm2 = ['source /etc/profile;nii2mnc ' tp24trans ' ' [pathtp2 '/' fntp2 '.mnc']];
    system(c4tm2)
    imt2mnc=[pathtp2 '/' fntp2 '.mnc'];
    imt2xfm=[pathtp2 '/' fntp2 '.xfm'];
    
    creg=['source /etc/profile;' CIVETpath '/CIVET/quarantines/Linux-x86_64/CIVET-2.1.0/progs/multispectral_stx_registration -nothreshold -clobber -single-stage -lsq6 -modeldir ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/mni-models -model icbm_avg_152_t1_tal_lin -source_mask targetOnly ' imt1mnc ' ' imt2mnc ' PD.mnc ' imt1xfm ' ' imt2xfm];
    system(creg);
    
    caplt1=['source /etc/profile;mincresample -clobber -transform ' imt1xfm ' -like ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/ICBM/icbm_template_1.00mm.mnc -trilinear ' imt1mnc ' ' [pathtp1 '/' fntp1 '_reged.mnc']];
    system(caplt1);
    caplt2=['source /etc/profile;mincresample -clobber -transform ' imt2xfm ' -like ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/ICBM/icbm_template_1.00mm.mnc -trilinear ' imt2mnc ' ' [pathtp2 '/' fntp2 '_reged.mnc']];
    system(caplt2);
    
    imt1reged = [pathtp1 '/' fntp1 '_reged.mnc'];
    cnuct1=['source /etc/profile;nu_correct_norm ' imt1reged ' ' [pathtp1 '/' fntp1 '_nunorm.mnc']];
    system(cnuct1)
    imt2reged = [pathtp2 '/' fntp2 '_reged.mnc'];
    cnuct2=['source /etc/profile;nu_correct_norm ' imt2reged ' ' [pathtp2 '/' fntp2 '_nunorm.mnc']];
    system(cnuct2)
    
    cm2nt1=['source /etc/profile;mnc2nii -short -signed -nii ' [pathtp1 '/' fntp1 '_nunorm.mnc'] ' ' [pathtp1 '/' fntp1 '_final.nii']];
    system(cm2nt1)
    
    cm2nt2=['source /etc/profile;mnc2nii -short -signed -nii ' [pathtp2 '/' fntp2 '_nunorm.mnc'] ' ' [pathtp2 '/' fntp2 '_final.nii']];
    system(cm2nt2)
    
elseif tpflag==13
    
    imt3=imt2;
    [~,fntp3,~]=fileparts(imt3);
    imt3path=g_ls([output '/' fntp3]);
    if (isempty(imt3path))
        cmkt3=['mkdir ' output '/' fntp3];
        system(cmkt3);
        pathtp3=[output '/' fntp3];
    else
        pathtp3=[output '/' fntp3];
    end
    
    if cropflag==1
        cropchecktp3=g_ls([pathtp3 '/' fntp3 '_crop.nii']);
        if isempty(cropchecktp3)
            cbet3=['source /etc/profile;robustfov -i ' imt3 ' -r ' [pathtp3 '/' fntp3 '_crop']];
            system(cbet3)
            cuzp3=['gunzip -f ' [pathtp3 '/' fntp3 '_crop.nii.gz']];
            system(cuzp3)
            tp34trans=[pathtp3 '/' fntp3 '_crop.nii'];
        else
            tp34trans=cropchecktp3{1};
        end
    else
        tp34trans=imt3;
    end
    c4tm3 = ['source /etc/profile;nii2mnc ' tp34trans ' ' [pathtp3 '/' fntp3 '.mnc']];
    system(c4tm3)
    imt3mnc=[pathtp3 '/' fntp3 '.mnc'];
    imt3xfm=[pathtp3 '/' fntp3 '.xfm'];
    
    [~,fntp1,~]=fileparts(imt1);
    mnc1=g_ls([output '/' fntp1 '/' fntp1 '.mnc']);
    xfm1=g_ls([output '/' fntp1 '/' fntp1 '.xfm']);
    imt1mnc=mnc1{1};
    imt1xfm=xfm1{1};
    imt3toimt1xfm=[pathtp3 '/' fntp3 '_to_' fntp1 '.xfm'];
    imt3to1nii=[pathtp3 '/' fntp3 '_to_' fntp1 '.nii'];

%     cregself=['source /etc/profile;mritoself -clobber -mi -lsq6 ',  imt3mnc,' ', imt1mnc,' ', imt3toimt1xfm];
%     system(cregself);
% 
%     cxfmcon=['source /etc/profile;xfmconcat -clobber ', imt3toimt1xfm,' ', imt1xfm,' ', imt3xfm];
%     system(cxfmcon);
%     
%     caplt3=['source /etc/profile;mincresample -clobber -transform ' imt3xfm ' -like ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/ICBM/icbm_template_1.00mm.mnc -trilinear ' imt3mnc ' ' [pathtp3 '/' fntp3 '_reged.mnc']];
%     system(caplt3);
    
    
    cregself=['source /etc/profile;flirt -dof 6 -in ' imt3 ' -ref ' imt1 ' -omat ', imt3toimt1xfm ' -out ' imt3to1nii];
    system(cregself);    
    cuzp31=['gunzip -f ' imt3to1nii];
    system(cuzp31)
    c4tm31 = ['source /etc/profile;nii2mnc ' imt3to1nii ' ' [imt3to1nii(1:end-3) 'mnc']];
    system(c4tm31)
    caplt3=['source /etc/profile;mincresample -clobber -transform ' imt1xfm ' -like ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/ICBM/icbm_template_1.00mm.mnc -trilinear ' [imt3to1nii(1:end-3) 'mnc'] ' ' [pathtp3 '/' fntp3 '_reged.mnc']];
    system(caplt3);    
    
    imt3reged = [pathtp3 '/' fntp3 '_reged.mnc'];
    cnuct3=['source /etc/profile;nu_correct_norm ' imt3reged ' ' [pathtp3 '/' fntp3 '_nunorm.mnc']];
    system(cnuct3)
    
    cm2nt3=['source /etc/profile;mnc2nii -short -signed -nii ' [pathtp3 '/' fntp3 '_nunorm.mnc'] ' ' [pathtp3 '/' fntp3 '_final.nii']];
    system(cm2nt3)
    
else
    [~,fntp1,~]=fileparts(imt1);
    imt1path=g_ls([output '/' fntp1]);
    if (isempty(imt1path))
        cmkt1=['mkdir ' output '/' fntp1];
        system(cmkt1);
        pathtp1=[output '/' fntp1];
    else
        pathtp1=[output '/' fntp1];
    end
    
    if cropflag==1
        cropchecktp1=g_ls([pathtp1 '/' fntp1 '_crop.nii']);
        if isempty(cropchecktp1)
            cbet1=['source /etc/profile;robustfov -i ' imt1 ' -r ' [pathtp1 '/' fntp1 '_crop']];
            system(cbet1)
            cuzp1=['gunzip -f ' [pathtp1 '/' fntp1 '_crop.nii.gz']];
            system(cuzp1)
            tp14trans=[pathtp1 '/' fntp1 '_crop.nii'];
        else
            tp14trans=cropchecktp1{1};
        end
    else
        tp14trans=imt1;
    end
    
    c4tm1 = ['source /etc/profile;nii2mnc ' tp14trans ' ' [pathtp1 '/' fntp1 '.mnc']];
    system(c4tm1)
    imt1mnc=[pathtp1 '/' fntp1 '.mnc'];
    imt1xfm=[pathtp1 '/' fntp1 '.xfm'];
    
%     creg=['source /etc/profile;' CIVETpath '/CIVET/quarantines/Linux-x86_64/CIVET-2.1.0/progs/multispectral_stx_registration -nothreshold -clobber -single-stage -lsq6 -modeldir ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/mni-models -model mni_icbm152_t1_tal_nlin_sym_09a -source_mask targetOnly ' imt1mnc ' T2.mnc PD.mnc ' imt1xfm '  T2PD_to_tal.xfm'];
%     system(creg);
    creg=['source /etc/profile;' CIVETpath '/CIVET/quarantines/Linux-x86_64/CIVET-2.1.0/progs/multispectral_stx_registration -nothreshold -clobber -single-stage -lsq6 -modeldir ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/mni-models -model icbm_avg_152_t1_tal_lin -source_mask targetOnly ' imt1mnc ' T2.mnc PD.mnc ' imt1xfm '  T2PD_to_tal.xfm'];
    system(creg);    
    
    caplt1=['source /etc/profile;mincresample -clobber -transform ' imt1xfm ' -like ' CIVETpath '/CIVET/quarantines/Linux-x86_64/share/ICBM/icbm_template_1.00mm.mnc -trilinear ' imt1mnc ' ' [pathtp1 '/' fntp1 '_reged.mnc']];
    system(caplt1);

    imt1reged = [pathtp1 '/' fntp1 '_reged.mnc'];
    cnuct1=['source /etc/profile;nu_correct_norm ' imt1reged ' ' [pathtp1 '/' fntp1 '_nunorm.mnc']];
    system(cnuct1)
    
    cm2nt1=['source /etc/profile;mnc2nii -short -signed -nii ' [pathtp1 '/' fntp1 '_nunorm.mnc'] ' ' [pathtp1 '/' fntp1 '_final.nii']];
    system(cm2nt1)

end

end