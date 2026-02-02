library(tidyverse)
library(stringr)
library(dplyr)
library(gtools)

id<-read.table("idlist_vM20.tsv",sep="\t",header=T)
samples<-read.csv("Samplesheet.csv",header = T)
List<-list.files(pattern="\\.genes.results$")%>%
  mixedsort()

d <- do.call(cbind,
         lapply(List,
                     FUN=function(x) { 
            aColumn <- read.table(x,header=T)[,c("gene_id","transcript_id.s.","expected_count","TPM","FPKM")];
            sample <-gsub("_vM20.genes.results","",x)
			colnames(aColumn)[3] = paste(sample,"expected_count",sep="|");
			colnames(aColumn)[4] = paste(sample,"TPM",sep="|");
            		colnames(aColumn)[5] = paste(sample,"FPKM",sep="|");
			aColumn;
             }
            )
        )

d <- d[,!duplicated(colnames(d))]
d<- d%>% select("gene_id","transcript_id.s.",ends_with("expected_count"),ends_with("TPM"),ends_with("FPKM"))
d2<-dplyr::left_join(id,d,by=c("ensembl_id"="gene_id"))

mhu01spleen<-samples%>%filter(MHU=="MHU01"&tissue=="Spleen")%>%select(MHU,Group,tissue,Run)
mhu01spleendata<-d2%>%select("ensembl_id",
                           "gene_name",
                           "chr",
                           "start",
                           "end",
                           "score",
                           "strand",
                           "frame",
                           "gene_type",
                           "transcript_id.s.",
                           starts_with(mhu01spleen$Run))

write.table(mhu01spleen,"mhu1_spleen_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu01spleendata,"mhu1_spleen_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)

mhu01thymus<-samples%>%filter(MHU=="MHU01"&tissue=="Thymus")%>%select(MHU,Group,tissue,Run)
mhu01thymusdata<-d2%>%select("ensembl_id",
                             "gene_name",
                             "chr",
                             "start",
                             "end",
                             "score",
                             "strand",
                             "frame",
                             "gene_type",
                             "transcript_id.s.",
                             starts_with(mhu01thymus$Run))

write.table(mhu01thymus,"mhu1_thymus_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu01thymusdata,"mhu1_thymus_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)


mhu01bone<-samples%>%filter(MHU=="MHU01"&tissue=="Bone")%>%select(MHU,Group,tissue,Run)
mhu01bonedata<-d2%>%select("ensembl_id",
                          "gene_name",
                          "chr",
                          "start",
                          "end",
                          "score",
                          "strand",
                          "frame",
                          "gene_type",
                          "transcript_id.s.",
                          starts_with(mhu01bone$Run))

write.table(mhu01bone,"mhu1_bone_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu01bonedata,"mhu1_bone_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)

mhu04bone<-samples%>%filter(MHU=="MHU04"&tissue=="Bone")%>%select(MHU,Group,tissue,Run)
mhu04bonedata<-d2%>%select("ensembl_id",
                           "gene_name",
                           "chr",
                           "start",
                           "end",
                           "score",
                           "strand",
                           "frame",
                           "gene_type",
                           "transcript_id.s.",
                           starts_with(mhu04bone$Run))

write.table(mhu04bone,"mhu4_bone_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu04bonedata,"mhu4_bone_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)

mhu04spleen<-samples%>%filter(MHU=="MHU04"&tissue=="Spleen")%>%select(MHU,Group,tissue,Run)
mhu04spleendata<-d2%>%select("ensembl_id",
                             "gene_name",
                             "chr",
                             "start",
                             "end",
                             "score",
                             "strand",
                             "frame",
                             "gene_type",
                             "transcript_id.s.",
                             starts_with(mhu04spleen$Run))

write.table(mhu04spleen,"mhu4_spleen_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu04spleendata,"mhu4_spleen_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)

mhu04thymus<-samples%>%filter(MHU=="MHU04"&tissue=="Thymus")%>%select(MHU,Group,tissue,Run)
mhu04thymusdata<-d2%>%select("ensembl_id",
                             "gene_name",
                             "chr",
                             "start",
                             "end",
                             "score",
                             "strand",
                             "frame",
                             "gene_type",
                             "transcript_id.s.",
                             starts_with(mhu04thymus$Run))

write.table(mhu04thymus,"mhu4_thymus_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu04thymusdata,"mhu4_thymus_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)

mhu05spleen<-samples%>%filter(MHU=="MHU05"&tissue=="Spleen")%>%select(MHU,Group,tissue,Run)
mhu05spleendata<-d2%>%select("ensembl_id",
                             "gene_name",
                             "chr",
                             "start",
                             "end",
                             "score",
                             "strand",
                             "frame",
                             "gene_type",
                             "transcript_id.s.",
                             starts_with(mhu05spleen$Run))

write.table(mhu05spleen,"mhu5_spleen_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu05spleendata,"mhu5_spleen_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)

mhu05thymus<-samples%>%filter(MHU=="MHU05"&tissue=="Thymus")%>%select(MHU,Group,tissue,Run)
mhu05thymusdata<-d2%>%select("ensembl_id",
                             "gene_name",
                             "chr",
                             "start",
                             "end",
                             "score",
                             "strand",
                             "frame",
                             "gene_type",
                             "transcript_id.s.",
                             starts_with(mhu05thymus$Run))

write.table(mhu05spleen,"mhu5_thymus_DRA016428.samplesheet.txt",sep="\t", quote=F,row.names=F)
write.table(mhu05thymusdata,"mhu5_thymus_DRA016428.genes.results.txt",sep="\t", quote=F,row.names=F)
