\name{SolveBetaG2d}
\alias{Solve critical two dimensional probability density contour}
\title{
	Derivation of the critical two dimensional contour using the segmented searching algorithm by Dr Wu Xing Zheng
}
\description{
	Solve the critical contour and reliability index associated with two variables
}
\arguments{
  \item{p1}{
	scale parameter of the power law regression
}
  \item{p2}{
	shape parameter of the power law regression
}
  \item{rho}{
	correlation coefficient between p1 and p2
}
}
\details{
	The case study discusses the solution of the critical joint probability density contour with a correlated bivariate distribution.
}
\value{
	Returns a geometric reliability index.
}
\references{
	Wu X.Z., Liu H. 2023. Development of environmental contours from site-specific regression parameters of load-settlement curves for piles: the global database. International Journal of Geomechanics, 23(9):04023148.
}
\note{
	
	This subroutine can be run after calling the contour-based reliability method, i.e., CBRM-Wu.

	Please read the following references:

	[1] Wang R.K., Wu X.Z. Solving the geometric reliability index for a case involving multivariate random variables in the original physical space. Quality and Reliability Engineering International, 2023, 39(7): 3102-3118.
 
	[2] Wu X.Z., Ma C.Z., Wang R.K., Li W.C. Development of environmental contours from rainfall intensity and duration data for slopes. Natural Hazards, 2023, 116(1):1001-1027.

	[3] Wu X.Z., Ma C.Z., Wang R.K., Zhang J.  Multivariate reliability method using the environment contour model based on C-vine copulas. Ocean Engineering, 2024, 299:117282,1-15.

}
\author{
Xingzheng Wu \email{xingzhengwu@gmail.com}

}
\examples{
	##---- Should be DIRECTLY executable !! ----
	library(fitdistrplus)
	library(PileBetaGR)
	beta_star<-2.3 #can be specified as any value
	Rho12<--0.67 #Wu and Liu 2023
	data(P1P2MihalikRegPars)
	#P1P2MihalikRegPars
	ParsS<-matrix(NA, nrow=nrow(P1P2MihalikRegPars),ncol=3)

	ParsS[,1:2]<-as.matrix(P1P2MihalikRegPars[,9:10])
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
	transferStand2Environ<-function(beta_star,Rho12,bestDist01,Parametersp11,Parametersp12,
			bestDist02,Parametersp21,Parametersp22){
		n_point=200
		angle = seq(0, 2*pi, length.out = n_point+1)
		u1mat=rep(beta_star, each=n_point+1)*cos(angle)
		u2mat=rep(beta_star, each=n_point+1)*sin(angle)
		y1mat=pnorm(u1mat)
		y2mat=pnorm(u2mat*sqrt(1-Rho12 ^2)+Rho12*u1mat)
		#		p1mat=qgamma(y1mat,shape=Parametersp11,rate=Parametersp12)	
		p1mat=qmargdist(y1mat,bestDist01,Parametersp11,Parametersp12)
		#		p2mat=qweibull(y2mat,shape=Parametersp21,scale=Parametersp22)
		p2mat=qmargdist(y2mat,bestDist02,Parametersp21,Parametersp22)
		list(p1mat=p1mat,p2mat=p2mat)
	}

	FosS<-2.0
	TmpSettleAllow<-40
	MeanMaxTestLoad<-mean(as.numeric(as.matrix(P1P2MihalikRegPars[,11])))
	fff2d<-function(p1Spec,p2Spec,MeanMaxTestLoad){ 
		SettleAllowable<-TmpSettleAllow
		Rq<-p1Spec*SettleAllowable**p2Spec    #power law relation Qua
		Sq<-MeanMaxTestLoad/FosS  
		FOSTotal<-Rq-Sq #g = Qua - QLD
		FOSTotal	
	}
	#Segmented Searching Method by Xingzheng Wu
	betaMin<-0
	betaMax<-10
	jloop=0
	Increment<-1.0
	iCountLoop<-1
	for (jloop in 1:11){
		beta_mat<-seq(betaMin,betaMax,Increment)
		beta_star<-beta_mat[jloop]
		res_x<-transferStand2Environ(beta_star,Rho12,bestDist01,Parametersp11,Parametersp12,
				bestDist02,Parametersp21,Parametersp22)
		xx1 <- res_x[[1]]
		xx2 <- res_x[[2]]
		asz1<-fff2d(xx1,xx2,MeanMaxTestLoad)
		if (any(asz1<0)){
			xxx11<-xx1[which.min(asz1)]
			xxx22<-xx2[which.min(asz1)]
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
}
\keyword{Algorithm}
\keyword{Environmental contour}
\keyword{Geometric reliability index}
\keyword{2d}
