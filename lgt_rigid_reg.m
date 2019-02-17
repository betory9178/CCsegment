origfiles=g_ls('/data/stalxy/Corbetta/T1/FCS*.nii');

fileids=zeros(length(origfiles),3);
for i=1:length(origfiles)
    [~,nam,~]=fileparts(origfiles{i});
    fileids(i,1)=str2double(nam(5:7));
    fileids(i,3)=i;
    if i==1
        fileids(i,2)=1;
    else
        if fileids(i,1)~=fileids(i-1,1)
            fileids(i,2)=1;
        else
            fileids(i,2)=fileids(i-1,2)+1;
        end
    end
end

subids=unique(fileids(:,1));
subT1=fileids(fileids(:,2)==1,:);
subT2=fileids(fileids(:,2)==2,:);
subT3=fileids(fileids(:,2)==3,:);

% second timepoint and first timepoint 
output='/data/stalxy/Corbetta/PreprocLong';
for i2=1:length(subT2)

    SecondTP=origfiles{subT2(i2,3)};
    tid12=find(subT1(:,1)==subT2(i2,1));
    FirstTP=origfiles{subT1(tid12,3)};
    LongNorm(FirstTP,SecondTP,12,output,1,'/opt/')
end

% third timepoint and first timepoint 
for i3=1:length(subT3)

    ThirdTP=origfiles{subT3(i3,3)};
    tid12=find(subT1(:,1)==subT3(i3,1));
    FirstTP=origfiles{subT1(tid12,3)};
    LongNorm(FirstTP,ThirdTP,13,output,1,'/opt/')
end

% only first timepoint
subonly1=setdiff(subT1(:,1),subT2(:,1));
for i1=1:length(subonly1)

    tid1=find(subT1(:,1)==subonly1(i1));
    OnlyTP=origfiles{subT1(tid1,3)};
    LongNorm(OnlyTP,OnlyTP,1,output,1,'/opt/')
end

predt1=g_ls('/data/stalxy/Corbetta/PreprocLong/FCS*/FCS*_final.nii');
for i=1:length(predt1)
    CCsegment(predt1{i},'/data/stalxy/Corbetta/CCreLong','/data/stalxy/Corbetta/CCreLong/Corbetta_long');
end


%%
cbtCCnew=readtable('/data/stalxy/Corbetta/Corbetta_long_yuki.csv');
cbtCCold=readtable('/data/stalxy/Corbetta/Corbetta_yuki.csv');

cbtCCnewids=cbtCCnew.ID;
cbtCColdids=cbtCCold.ID;

for i=1:length(cbtCCnewids)
    [~,nid,~]=fileparts(cbtCCnewids{i});
    cnid{i,1}=nid(1:12);
end
for i=1:length(cbtCColdids)
    [oid,~,~]=fileparts(cbtCColdids{i});
    [~,oid2,~]=fileparts(oid);
    coid{i,1}=oid2(1:12);
end
[C,ia,ib]=intersect(cnid,coid);

SurfStatPlot(table2array(cbtCCnew(ia,2)),table2array(cbtCCold(ib,2)))

orginfile=g_ls('/data/stalxy/Corbetta/PreprocLong/*/*_final.nii');
ccfile=g_ls('/data/stalxy/Corbetta/CCreLong/*/CCmsp*_final_msp.nii');
acpcfile=g_ls('/data/stalxy/Corbetta/PreprocLong/*/*_final_ACPC.txt');
IDrange=[1:287];
CCcheck(orginfile,ccfile,acpcfile,IDrange)

%%

