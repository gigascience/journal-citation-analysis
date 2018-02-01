pdf("Rst.pdf")
par(xpd=NA,mar=par()$mar+c(0, 0, 0, 12))

idx <- 1
mtitle <- "Number of papers published per year with BGI"
minst <- matrix(0, 2, 6)
rows <- c("non-BGI", "BGI")
cols <- c("2012", "2013", "2014", "2015", "2016", "2017")
dimnames(minst) <- list(rows, cols)
for(i in 2012:2017) {
	ifname <- paste("savedrecs_", i, sep="")
	ifname <- paste(ifname, ".txt", sep="")
	print(ifname)
	D <- read.table(ifname,sep="\t",quote="",fill=TRUE,row.names=NULL,header=TRUE)
	nrec <- length(D[, c("C1")])
	for(j in 1:nrec) {
		if(length(grep('BGI', D[j, c("C1")], ignore.case=T)) > 0 || length(grep('Beijing Inst Genom', D[j, c("C1")], ignore.case=T)) > 0) {
			minst[2, idx] <- minst[2, idx] + 1
		} else {
			minst[1, idx] <- minst[1, idx] + 1
		}
	}
	idx <- idx + 1
}
color <- c("#A6CEE3","#1F78B4")
barplot(minst, xlab="Year", ylab="Number", ylim=c(0,300), col=color, main=mtitle, beside=TRUE)
legend(par()$usr[2], mean(par()$usr[3:4]), legend=rownames(minst), fill=color, xpd=NA, xjust=0, yjust=0.5)

idx <- 1
mtitle <- "Number of papers published per year by BGI"
minst <- matrix(0, 2, 6)
rows <- c("GIGASCIENCE", "Others")
cols <- c("2012", "2013", "2014", "2015", "2016", "2017")
dimnames(minst) <- list(rows, cols)
for(i in 2012:2017) {
	ifname <- paste("savedrecs_", i, sep="")
	ifname <- paste(ifname, ".txt", sep="")
	print(ifname)
	D <- read.table(ifname,sep="\t",quote="",fill=TRUE,row.names=NULL,header=TRUE)
	nrec <- length(D[, c("C1")])
	for(j in 1:nrec) {
		if(length(grep('BGI', D[j, c("C1")], ignore.case=T)) > 0 || length(grep('Beijing Inst Genom', D[j, c("C1")], ignore.case=T)) > 0) {
			if(length(grep('GIGASCIENCE', D[j, c("TI")], ignore.case=T)) > 0) {
				minst[1, idx] <- minst[1, idx] + 1
			} else {
				minst[2, idx] <- minst[2, idx] + 1
			}
		} 
	}
	idx <- idx + 1
}
color <- c("#A6CEE3","#1F78B4")
barplot(minst, xlab="Year", ylab="Number", ylim=c(0,130), col=color, main=mtitle, beside=TRUE)
legend(par()$usr[2], mean(par()$usr[3:4]), legend=rownames(minst), fill=color, xpd=NA, xjust=0, yjust=0.5)

mtitle <- "Most highly cited papers published in GigaScience"
for(i in 2012:2017) {
	ifname <- paste("savedrecs_", i, sep="")
	ifname <- paste(ifname, "_citation_report.txt", sep="")
	print(ifname)
	D <- read.table(ifname,sep=",",quote="\"",fill=TRUE,row.names=NULL,header=TRUE)
	nrec <- length(D[, c("Title")])
	
	minst <- matrix(0, nrec, 8)
	colnames(minst) <- c("ID", "2012", "2013", "2014", "2015", "2016", "2017", "Total")
	
	for(j in 1:nrec) {
		for(k in i:2017) {
			iyear <- paste("X", k, sep="")
			if(is.na(D[j, c(iyear)])) {
				minst[j, c(as.character(k))] <- 0
			} else {
				minst[j, c(as.character(k))] <- D[j, c(iyear)] 
			}
			minst[j, c("Total")] <- minst[j, c("Total")] + minst[j, c(as.character(k))]
			minst[j, c("ID")] <- j
		}
	}
	
	ofname <- paste("savedrecs_", i, sep="")
	ofname <- paste(ofname, "_citation_report.out", sep="")
	sink(ofname) 
	for(k in i:2017) {
		minstord <- minst[order(minst[,c(as.character(k))]),]
		maxv <- minstord[nrec,c(as.character(k))]
		print(sprintf("The maximum cite-number is %d in year %d. Paper names are as follows:", as.numeric(maxv), k))
		for(p in nrec:1) {
			if(minstord[p,c(as.character(k))] < maxv) {
				break
			}
			print(sprintf("    %s", as.character(D[minstord[p,c("ID")],c("Title")])))
		}
	}
	sink()
}

print("All done.")
dev.off()