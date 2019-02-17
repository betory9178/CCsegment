Failed=g_ls('/data/stalxy/Corbetta/PreprocLong_revised/*/*/FCS_*_crop.nii');
fileids=zeros(length(Failed),3);
for i=1:length(Failed)
    [~,nam,~]=fileparts(Failed{i});
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
output='/data/stalxy/Corbetta/PreprocLong_revised';
for i2=1:length(subT2)

    SecondTP=Failed{subT2(i2,3)};
    tid12=find(subT1(:,1)==subT2(i2,1));
    FirstTP=Failed{subT1(tid12,3)};
    LongNorm_revised(FirstTP,SecondTP,12,output,0,'/opt/')
end

% third timepoint and first timepoint 
for i3=1:length(subT3)

    ThirdTP=Failed{subT3(i3,3)};
    tid12=find(subT1(:,1)==subT3(i3,1));
    FirstTP=Failed{subT1(tid12,3)};
    LongNorm_revised(FirstTP,ThirdTP,13,output,0,'/opt/')
end

% only first timepoint
subonly1=setdiff(subT1(:,1),subT2(:,1));
for i1=1:length(subonly1)

    tid1=find(subT1(:,1)==subonly1(i1));
    OnlyTP=Failed{subT1(tid1,3)};
    LongNorm_revised(OnlyTP,OnlyTP,1,output,0,'/opt/')
end

%%

predt1=g_ls('/data/stalxy/Corbetta/PreprocLong_revised/FCS*/FCS*_final.nii');
for i=1:length(predt1)
    CCsegment(predt1{i},'/data/stalxy/Corbetta/CCreLong_revised','/data/stalxy/Corbetta/Corbetta_long');
end

orginfile=g_ls('/data/stalxy/Corbetta/PreprocLong_revised/FCS*/*_final.nii');
ccfile=g_ls('/data/stalxy/Corbetta/CCreLong_revised/*/CCmsp*_final_msp.nii');
acpcfile=g_ls('/data/stalxy/Corbetta/PreprocLong_revised/FCS*/*_final_ACPC.txt');
IDrange=[1:25];
CCcheck(orginfile,ccfile,acpcfile,IDrange)