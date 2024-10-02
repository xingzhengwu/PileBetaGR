\name{PileBetaGR-package}
\Rdversion{4.12}
\alias{PileBetaGR-package}
\alias{PileBetaGR}
\docType{package}
\title{PileBetaGR-package}
\description{Regression parameters of pile loading-settlements curves, some useful functions for geometric reliability analysis for piles}
\details{
	\tabular{ll}{
		Package: \tab PileBetaGR\cr
		Type: \tab Package\cr
		Version: \tab 1.0\cr
		Date: \tab 2024-1-02\cr
		License: \tab GNU 4.12 or later\cr
		LazyLoad: \tab yes\cr
	}
}
\author{
	Xing Zheng Wu
	Maintainer:  <xingzhengwu@gmail.com>
}
\references{
	Wu X.Z., Liu H. Development of environmental contours from site-specific regression parameters of load-settlement curves for piles: the global database. 
	                International Journal of Geomechanics, 2023, 23(9):04023148.
	Wu X.Z., Liu H., Wang R.K. Determination of geometric reliability index of piles at site-specific scale: case studies. Proceedings of the Institution of 
			Civil Engineers: Geotechnical Engineering, 2023, 176(2):118-131. 
	Wu X.Z., Xin J.X. Geometric reliability analysis of composite foundations comprising cement-fly ash-gravel piles at site-specific scale. Journal of Testing 
			and Evaluation, 2021, 49(4):2779-2799.
	Wu X.Z., Xin J.X. Probabilistic analysis of site-specific load-displacement behaviour of cement-fly ash-gravel piles. Soils and Foundations, 2019, 59(5):1613-1630.
}
\keyword{ package}
\examples{

	## listing the data for regression parameters of CFG pile in Wu and Xin 2019
	CFGRegPars
	## listing the data for regression parameters of pile-soil intermediate in Wu ad Xin 2021
	PSIRegPars
	## llisting the data for regression parameters of piles in Wu et al 2023
	P1P2GERegPars
	## listing the data for regression parameters of piles in Wu and Liu 2023
	P1P2GlobeRegPars
	## listing the data for load displacement curves of piles in Wu and Liu 2023
	CurveGlobeQpssP01

}
