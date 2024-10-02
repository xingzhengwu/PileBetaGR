\name{2dContour}
\alias{two dimensional probability density contour}
\title{
	Construction of the two dimensional contour using inverse Nataf transformation 
}
\description{
	Application to a solve the critical contour and reliability index associated with two variables
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
	The case study discusses the generation of joint probability density contour with a correlated bivariate distribution.
}
\value{
	Returns a probability density contour.
}
\references{
	Wu X.Z., Liu H. 2023. Development of environmental contours from site-specific regression parameters of load-settlement curves for piles: the global database. International Journal of Geomechanics, 23(9):04023148.
}
\note{
	
	This subroutine can be run after calling the contour-based reliability method, i.e., CBRM-Wu.

	Please read the following references:

	[1] Wang R.K., Wu X.Z. Solving the geometric reliability index for a case involving multivariate random variables in the original physical space. Quality and Reliability Engineering International, 2023, 39(7):3102-3118.
 
	[2] Wu X.Z., Ma C.Z., Wang R.K., Li W.C. Development of environmental contours from rainfall intensity and duration data for slopes. Natural Hazards, 2023, 116(1):1001-1027.

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
	P1P2MihalikRegPars
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
	
	ECxy<-transferStand2Environ(beta_star,Rho12,bestDist01,Parametersp11,Parametersp12,
			bestDist02,Parametersp21,Parametersp22)
	ECxy
	plot(ECxy$p1mat,ECxy$p2mat)
}
\keyword{Algorithm}
\keyword{Environmental contour}
\keyword{Inverse Nataf transformation}
\keyword{2d}
