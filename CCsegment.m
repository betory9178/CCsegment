function CCsegment(n,output,csvpath)
%
% n: preprocessed unsigned nifti files, "XXX_nunorm.nii"
% output: output path of CC results
% csvpath: output path of CSV from Yuki
%

[~,name,~]=fileparts(n);

tmpath=g_ls([output '/' name]);
if (isempty(tmpath))
    cmk=['mkdir ' output '/' name]; 
    system(cmk);   
end

outputpath=[output '/' name];


cmd=['source /etc/profile;yuki -v -mrx -n 100 -o ' [outputpath '/' name] ' -csv ' [csvpath '_yuki.csv'] ' -W -Hampel -acpc -i ' n];
system(cmd);


ACPCs=g_ls([n(1:end-4) '_ACPC.txt']);
mrxs=g_ls([outputpath '/' name '*_msp.mrx']);
CCs=g_ls([outputpath '/' name '*_cc.nii']);

i=1;

[path,name,~]=fileparts(mrxs{i});
origf=load_untouch_nii(n);


nx=num2str(origf.hdr.dime.dim(2));
ny=num2str(origf.hdr.dime.dim(3));
nz=num2str(origf.hdr.dime.dim(4));
dx=num2str(origf.hdr.dime.pixdim(2));
dy=num2str(origf.hdr.dime.pixdim(3));
dz=num2str(origf.hdr.dime.pixdim(4));
cmd1 = ['art2fsl -v -i ' mrxs{i} ' -o ' [path '/' name '_FSL.mat'] ' -Snx ' nx ' -Sny ' ny ' -Snz ' nz ' -Sdx ' dx ' -Sdy ' dy ' -Sdz ' dz ' -Tnx 512 -Tny 512 -Tnz 1 -Tdx 0.5 -Tdy 0.5 -Tdz 1'];
system(cmd1)
cmd2 = ['source /etc/profile;convert_xfm  -omat ' [path '/inverse_' name '_FSL.mat'] ' -inverse ' [path '/' name '_FSL.mat']];
system(cmd2)
cmd3 = ['fsl2art -v -i ' [path '/inverse_' name '_FSL.mat'] ' -o ' [path '/inverse_' name '.mrx'] ' -Tnx ' nx ' -Tny ' ny ' -Tnz ' nz ' -Tdx ' dx ' -Tdy ' dy ' -Tdz ' dz ' -Snx 512 -Sny 512 -Snz 1 -Sdx 0.5 -Sdy 0.5 -Sdz 1'];
system(cmd3)
cmd4 = ['unwarp2d -iter 1 -obj ' CCs{i} ' -trg ' n ' -T ' [path '/inverse_' name '.mrx'] ' -o ' [path '/CC_' name '.nii']];
system(cmd4)

fid=importdata(ACPCs{i},' ',20);
ACord=str2num(fid{8});
PCord=str2num(fid{10});

transCC=load_untouch_nii([path '/CC_' name '.nii']);
j=round((ACord(1)+PCord(1))/2); %round?
if j>1 && j<str2double(nx)
CCtemplate=zeros(origf.hdr.dime.dim(2),origf.hdr.dime.dim(3),origf.hdr.dime.dim(4));
CCtemplate(j+1,:,:)=logical(transCC.img(j+1,:,:)+transCC.img(j+2,:,:)+transCC.img(j,:,:));
origf.img=CCtemplate;
save_untouch_nii(origf,[path '/CCmsp_' name '.nii'])
end

end