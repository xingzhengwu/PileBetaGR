\name{Power law regression}
\alias{Power Law}
\title{
	Solving of regression parameters for the power law function 
}
\description{
	Application to a load displacement curve
}
\arguments{
  \item{p1}{
	scale parameter
}
  \item{p2}{
	shape parameter
}
}
\details{
	The case study demostrates the solution with a nls (nonlinear least squares) function.
}
\value{
	Returns p1 and p2.
}
\references{
	Wu XZ. 2017. Implementing multivariate fitting and reliability analyses for geotechnical engineering problems in R. Georisk, 11(2):173-188.
}
\note{
	
	Please read the following references for the original data (adopted from):
  
}
\seealso{

	Wu X.Z., Xin J.X. 2019. Probabilistic analysis of site-specific load-displacement behaviour of cement-fly ash-gravel piles. Soils and Foundations, 59(5):1613-1630.
}
\author{
Xingzheng Wu \email{xingzhengwu@gmail.com}

}
\examples{
	##---- Should be DIRECTLY executable !! ----
	##--	listing the code.
	library(PileBetaGR) #for dataset
	data(CurveMihalikQpssBridge)
	ResList<-	CurveMihalikQpssBridge

	nLines<-length(ResList[1,])/2
	ParsS<-matrix(nrow=nLines,ncol=3)
	for (kk in 1:nLines) {
		ResSettle<-cbind(ResList[,kk*2-1],ResList[,kk*2] )
		xy0<- ResSettle
		n_maxSett<-which.max(ResSettle[,1])
		xy<-xy0[1:n_maxSett,]
		xx0<-xy[,2];yy0<-xy[,1]
		parab_nlm1<-nls(yy0~aa00*xx0^bb00,start = list(aa00=5638,bb00=0.64))
		ParsS[kk,2]<-round(summary(parab_nlm1)$par[2],6)
		ParsS[kk,1]<-round(summary(parab_nlm1)$par[1],6)
		ParsS[kk,3]<-xy0[n_maxSett,1]
	}
	MeanMaxTestLoad<-mean(ParsS[,3])
	ParsS 
	#p1 p2 maxLoad for each curve
}
\keyword{Algorithm}
\keyword{Regression}
\keyword{Power law}

