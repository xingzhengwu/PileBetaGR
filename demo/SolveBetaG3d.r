#Solution of the geometric reliability index using Wu and Liu (2023) 's algorithm with three random variables

	# author Xingzheng Wu email xingzhengwu@gmail.com
	#references
	#[1] Wu X.Z., Liu H. 2023. Development of environmental contours from site-specific regression parameters of load-settlement curves for piles: the global database. International Journal of Geomechanics, 23(9):04023148.
	#[2] Wang R.K., Wu X.Z. Solving the geometric reliability index for a case involving multivariate random variables in the original physical space. Quality and Reliability Engineering International, 2023, 39(7): 3102-3118.
	#[3] Wu X.Z., Ma C.Z., Wang R.K., Li W.C. Development of environmental contours from rainfall intensity and duration data for slopes. Natural Hazards, 2023, 116(1):1001-1027.
	#[4] Wu X.Z., Ma C.Z., Wang R.K., Zhang J. Multivariate reliability method using the environment contour model based on C-vine copulas. Ocean Engineering, 2024, 299:117282,1-15.
	#2024/10/1
	##--	listing the code.
	##---- Should be DIRECTLY executable !! ----
	library(fitdistrplus)
	library(PileBetaGR)
	beta_star<-2.3 #can be specified as any value
	rho12<--0.67 #Wu and Liu 2023
	data(P1P2MihalikRegPars)
	P1P2MihalikRegPars
	ParsS<-matrix(NA, nrow=nrow(P1P2MihalikRegPars),ncol=3)

	ParsS[,1:3]<-as.matrix(P1P2MihalikRegPars[,9:11])
	Parametersp11<-fitdist(as.numeric(ParsS[,1]), "norm",method="mme")[1]$estimate[1]
	Parametersp12<-fitdist(as.numeric(ParsS[,1]), "norm",method="mme")[1]$estimate[2]
	bestDist01<-"norm"
	Parametersp21<-fitdist(as.numeric(ParsS[,2]), "norm",method="mme")[1]$estimate[1]
	Parametersp22<-fitdist(as.numeric(ParsS[,2]), "norm",method="mme")[1]$estimate[2]
	bestDist02<-"norm"
	qmargdist<-function(yyTmp, bestDist, Par01, Par02){
		if (bestDist=="norm") {
			qmargd<-qnorm(yyTmp,Par01,Par02)
		}else if ((bestDist=="lnorm")) {
			qmargd<-qlnorm(yyTmp,Par01,Par02)
		}else if ((bestDist=="gamma")) {
			qmargd<-qgamma(yyTmp,Par01,Par02)
		}else if ((bestDist=="weibull")) {
			qmargd<-qweibull(yyTmp,Par01,Par02)
		}
		return(qmargd)
	}

	MeanMaxTestLoad<-mean(as.numeric(ParsS[,3]))
	mean33Tmp<-MeanMaxTestLoad*0.5 #Qmax/2
	cov33<-0.1
	sd33Tmp<-mean33Tmp*cov33
	meanlog<-log(mean33Tmp*mean33Tmp/sqrt(mean33Tmp*mean33Tmp+sd33Tmp*sd33Tmp))
	#meanlog
	sdlog<-sqrt(log((mean33Tmp*mean33Tmp+sd33Tmp*sd33Tmp)/(mean33Tmp*mean33Tmp)))
	#sdlog
	mean3=round(meanlog,2); sd3=round(sdlog,2)

	numgrid3<-30
	transferUnit2Physical3D<-function(beta_star){
		M  <- mesh(seq(0, 2*pi, length.out = numgrid3),   seq(0,   pi, length.out = numgrid3))
		u  <- M$x ; v  <- M$y
		
		u1mat <- beta_star*cos(u)*sin(v)
		u2mat <- beta_star*sin(u)*sin(v)
		u3mat <- beta_star*cos(v)
		#i=1------------------------------------------------------
		xx1=qmargdist(pnorm(u1mat),bestDist01,Parametersp11,Parametersp12)
		#i=2------------------------------------------------------
		Rho21<-matrix(RR[2,1],nr=1)  
		Rho21=as.numeric(Rho21)
		Uc2=Rho21*u1mat
		zegmac2=sqrt(1-Rho21 ^2)
		asx2=u2mat*zegmac2+Uc2
		xx2=qmargdist(pnorm(asx2),bestDist02,Parametersp21,Parametersp22)
		#i=3-------------------------------------------------------
		Rho12<-matrix(RR[1,2],nr=1)
		Rho12<-as.numeric(Rho12)
		Rho13<-matrix(RR[1,3],nr=1)
		Rho13<-as.numeric(Rho13)
		Rho23<-matrix(RR[2,3],nr=1)
		Rho23<-as.numeric(Rho23)
		Uc3=((Rho13-Rho12*Rho23)*u1mat+(Rho23-Rho12*Rho13)*u2mat)/(1-Rho12 ^2)
		zegmac3=sqrt(1-Rho12 ^2-Rho13 ^2-Rho23 ^2+2*Rho12*Rho13*Rho23)/sqrt(1-Rho12 ^2)
		asx3=u3mat*zegmac3+Uc3
		xx3=qlnorm(pnorm(asx3), meanlog=mean3, sdlog=sd3) 
		list(xx1,xx2,xx3)
	}
	library(plot3D) 
	RR<-matrix(NA,nrow=3,ncol=3)
	RR[1,1]<-1; RR[2,2]<-1;	RR[3,3]<-1
	RR[1,2]<--0.67; RR[2,1]<--0.67
	RR[1,3]<-0; RR[3,1]<-0
	RR[2,3]<-0; RR[3,2]<-0

	res_x<-transferUnit2Physical3D(beta_star)
	xx1_p <- res_x[[1]]
	xx2_p <- res_x[[2]]
	xx3_p <- res_x[[3]]

	FosS<-1.0
	TmpSettleAllow<-40
	fff2d<-function(p1Spec,p2Spec,MeanMaxTestLoad){ 
		SettleAllowable<-TmpSettleAllow
		Rq<-p1Spec*SettleAllowable**p2Spec    #power law relation Qua
		Sq<-MeanMaxTestLoad/FosS  
		FOSTotal<-Rq-Sq #g = Qua - QLD
		FOSTotal	
	}
	#Segmented Searching Method
	betaMin<-0
	betaMax<-10
	jloop=0
	Increment<-1.0
	iCountLoop<-1
	for (jloop in 1:11){
		beta_mat<-seq(betaMin,betaMax,Increment)
		beta_star<-beta_mat[jloop]
		res_x<-transferUnit2Physical3D(beta_star)
		xx1 <- res_x[[1]]
		xx2 <- res_x[[2]]
		xx3 <- res_x[[3]]
		asz1<-fff2d(xx1,xx2,xx3)
		if (any(asz1<0)){
			xxx11<-xx1[which.min(asz1)]
			xxx22<-xx2[which.min(asz1)]
			xxx33<-xx3[which.min(asz1)]
			betaMin<-beta_star-Increment
			betaMax<-beta_star
			Increment<-Increment*0.1
			iCountLoop<-iCountLoop+1
			if (iCountLoop>5) break #0.0001 precision
		}
	}
	realBetaG<-round(beta_star,3)
	realBetaG
	iCountLoop
