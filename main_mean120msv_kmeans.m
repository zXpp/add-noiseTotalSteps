clear all;
fclose all;
%% GET the mean of the sample to send to kmeans as the center data matrix
%mydir='/home/zzpp220/DATA/TEST/2520/evy_gmsv/';
 rootdir='H:\cluster_data';
 aa=['gmm'];%'MeiZu_M2-None']
for z=1:size(aa,1);
 x=aa(z,:);
     %rootdir='/home/zzpp220/Documents/mobile/DATA/TRAIN/';
filedir=fullfile(rootdir,strcat(x,'_gmm13\'));%'208_500_500_39_21.gmm/');
true_labels=load(fullfile(rootdir,'lists','lists','true_labels-6840.lst'));
 fid = fopen(fullfile(rootdir,'lists','lists','brandname.list'), 'rt');
 C = textscan(fid, '%s %s');
fclose(fid);
    %[C,IA,IC] = unique(A,'stable') returns the values of C in the same order that they appear in A
model_ids = unique(C{1}, 'stable');
nspks = length(model_ids);%all clusters counts
gmmtot=dir([filedir,'*.gmm']);gmmnum=length(gmmtot);% all gmm file counts

label=strcat('zx_mob_',x,'_13-256_kmeans');
codebook=8;%if use vq 

tot2520=fopen(strcat(rootdir,label,'tot_cat.txt'),'wb');
each_mode=fopen(strcat(rootdir,label,'_centercat.txt'),'wb');

total=cell(gmmnum,1);%%%%need change 2520
mean_center=cell(nspks,1);
for j= 1 : nspks
            model_index=strcat(model_ids{j},'*.gmm'); %model_index=strcat(model_ids{j},'*_txt.gmsv');    
            filelist=dir([filedir,model_index]);
            filenum=length(filelist);
            sum=0;
            samplenum=filenum;%%%change follow your need
            for k=1:filenum
                a=filelist(k).name;findchar=strfind(a,'.gmm');
                tmpname=a(1:findchar-1); 
                totalname=strcat(filedir,filelist(k).name);

             %% if use gmm excrated by Miscrosoft adapt_gmm then use this 
             %tmp=load(totalname); 

           %%
             %%if use zx_main01_MFCC.m to get the spkr gmms
            [C,M,W,N,D] = load_mixture_model_diagb(totalname); %M IS N*D
             tmp=M';
             tmp=tmp(:);
             tmp=tmp';
             %% use the cut the frame contain 0 method to vq 

        %      [d]=READHTK(totalname);
        %         [z,x]=size(d);
        %         MFCC_zerocut=[];
        %         for row =1:z
        %             rowline=d(row,:);
        %             count_zero=size(find(rowline==0),2);%%find and count the frame who has 0 elements
        %             if count_zero==0
        %                 MFCC_zerocut=[MFCC_zerocut;rowline];% put the no 0 frame into new matrix
        %             end
        %         end
        %         v=MFCC_zerocut';
        %          code{k} = vqlbg(v, codebook); % Train VQ codebook
        %         tmp=code{k}(:)';
            %%

                sum=sum+tmp;
                total{k+samplenum*(j-1)}=tmp;

            % dlmwrite(txtname,tmp);
            %% save the mean gmsv of each speaker.
             %txtname=strcat('/home/zzpp220/DATA/bn/gmsv_208.1024.1024.13.21-13/',tmpname,'_iv_gmsv.txt'); 
           %long_fid = fopen(txtname,'wb');
           % total_precise_array(long_fid,tmp);
            %fclose(long_fid);
            end
            avg=sum/samplenum;
            mean_center{j}=avg;
            %al=cat(1,total{:});
            %an=cat(1,mean_center{:});

end

cat_total=cat(1,total{:});
cat_mean=cat(1,mean_center{:});

    %%
total_precise_array(tot2520,cat_total);
total_precise_array(each_mode,cat_mean);
    %%
    %% send to kmeans
    %%send to kmeans
     %a=load('cat_total.mat'); b=load('cat_mean.mat');%
[cluster_labels,newname]=sendto_kmeans(rootdir,cat_total,cat_mean,label,nspks);
    %[cluster_labels,newname]=sendto_kmeans(rootdir,a.cat_total,b.cat_mean,label);
    %%
    %%send to accuracy&&nmi

    
send_to_accury(true_labels,cluster_labels,label,rootdir);
fclose(tot2520);
fclose(each_mode);
    %%
end
                                                                                                        