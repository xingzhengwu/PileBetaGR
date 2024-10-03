runShinyPileBetaGR <- function(launch.browser = T) {
#R4.4.0 
#developed by Dr Xing Zheng Wu xingzhengwu@gmail.com or xingzhengwu@163.com @copyright2024/10/2
library(shiny)
library(httr)
		selectedFileChoices <- list("7215 Case CFAP Mihalik etal 2023" = "https://figshare.com/ndownloader/files/47197483",
									 "772 Case A1 ACIP Park etal 2012" = "https://figshare.com/ndownloader/files/46410769",
                                     "772 Case A2 DDP Park etal 2012" = "https://figshare.com/ndownloader/files/46410775",
                                     "772 Case B1 PCDP Prakoso 2016" = "https://figshare.com/ndownloader/files/46410772",
                                     "772 Case B2 PCDP Northern Prakoso 2016" = "https://figshare.com/ndownloader/files/46410766",
                                     "772 Case B3 PCDP Southern Prakoso 2016" = "https://figshare.com/ndownloader/files/46410778",
                                     "772 Case C1 PP ZoneA Zhou etal 2019" = "https://figshare.com/ndownloader/files/46410781",
                                     "772 Case C2 SP ZoneC Zhou etal 2019" = "https://figshare.com/ndownloader/files/46410784",
                                     "9368 Case P01 CFA Brandl 2005" = "https://figshare.com/ndownloader/files/47195527",
                                     "9368 Case P02 Driven Evangelista etal 1977" = "https://figshare.com/ndownloader/files/47195524",
                                     "9368 Case P03 PCP HHET 2018" = "https://figshare.com/ndownloader/files/47195530",
                                     "9368 Case P04 PHC HHET 2019" = "https://figshare.com/ndownloader/files/47195533",
                                     "9368 Case P05 CFG HHET 2020" = "https://figshare.com/ndownloader/files/47195536",
                                     "9368 Case P06 PHC HJCT 2018" = "https://figshare.com/ndownloader/files/47195539",
                                     "9368 Case P07 PHC HJCT 2019" = "https://figshare.com/ndownloader/files/47195542",
                                     "9368 Case P08 Open-ended Karlsrud 2013" = "https://figshare.com/ndownloader/files/47195545",
                                     "9368 Case P09 Cast in place Lu etal 2019" = "https://figshare.com/ndownloader/files/47195548",
                                     "9368 Case P10 Bored Mahakhotchasenichai etal 2018" = "https://figshare.com/ndownloader/files/47195551",
                                     "9368 Case P11 Bored Sun etal 2014" = "https://figshare.com/ndownloader/files/47195554",
                                     "9368 Case P12 Drilled shaft Tawfik etal 2015" = "https://figshare.com/ndownloader/files/47195557")

ui <- fluidPage(
  titlePanel("PileBetaGR4.3.2: Geometric reliability analysis for piles !"),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(id = "your_tabset_id",
        tabPanel("Demo", 
		br(), 
			selectInput("selectedFile", "Choose a Figshare File:",    choices  = selectedFileChoices),
		   fluidRow(
                            column(12,
							actionButton("loadQs", "Refresh plot"),
							downloadButton("downloadQpssData", "Download data")
							)
					),
          br(), 
		   h5("The data is sourced from two publications (772) https://doi.org/10.1680/jgeen.20.00204 "),
		   h5("and (9368) https://doi.org/10.1061/IJGNAI.GMENG-8372"),
		   h5("These files (*.qpss) can be downloadedby (772) https://doi.org/10.6084/m9.figshare.25556721"),
		   h5("and (9368) https://doi.org/10.6084/m9.figshare.25855843"),
		  br(),
		  h4("Pearson's Rho only works with the BetaPlot option selected"),
				sliderInput(inputId = "bins",
                    label = "Correlation Coefficient:",
                    min = -0.8, max = 0.2, value = -0.3),
					radioButtons(inputId ="optimization_solver", 
					             label = "Optimization Solver:",
								 choices  =  c("Extended coefficient method (ECM)" = "ECM",	 "Interval bisection method (IBM)" = "IBM",  "Sequential quadratic programming method (SQP)" = "SQP"),selected = "IBM"),br(),

					fluidRow(
						 column(12,
						helpText("Note: normal distribution of p1 and p2 is assumed; ", 
								br(),
								"Developed by Dr xingzhengwu@163.com ")
								)
							)
				),
        tabPanel("YouInput", h5("Input Qs data (*.qpss or *.txt file) by your own;", br(), 
				"The source data file can be edited by any text editor even with the qpss file", br(), 
				"The uncertainies of p1 and p2 in the power law regression for Qs curves are considered", br(), 
				"Developed by Dr xingzhengwu@163.com"),
				    # br() element to introduce extra vertical spacing ----
					br(),
				  fileInput('file1In', 'Upload *.qpss File which is composed by Q1 s1 Q2 s2 Q3 s3 for first stage (first row) the same for the 2nd row',
	                accept=c('text/csv','text/comma-separated-values,text/plain', '.qpss'),multiple = TRUE),
					br(),

					h4("The follow only works with the BetaPlot option selected"),
					radioButtons(inputId ="FsIn", 
					             label = "Set up of the factor of safety Fs:",
								 choices  =  c("2" = "2",	 "3" = "3")),
					br(),
				 # Input: Select the allowable settlements ----
					radioButtons(inputId ="allowsettle", 
					             label = "Allowable settlement sa (mm):",
								 choices  =  c("40" = "40",	 "25" = "25")),br(),
					selectInput("variableP12D", "Variable p1:",  c("norm",   "lnorm",  "gamma",  "weibull" , "bestfit"),selected=c("norm")),
					selectInput("variableP22D", "Variable p2:",  c( "norm",   "lnorm",  "gamma",  "weibull" , "bestfit"),selected=c("norm"))
								
				),
			tabPanel("3D", h5("Considering another random variable (dead load) ;",br(), 
					"The theory can be referred to https://doi.org/10.1680/jgeen.20.00204",br(),
					"Developed by Dr xingzhengwu@163.com"),
					br(),                				
						fileInput('file3D', 'Upload *.qpss File which is composed by Q1 s1 Q2 s2 Q3 s3 for first stage (first row) the same for the 2nd row',
						accept=c('text/csv','text/comma-separated-values,text/plain', '.qpss'),multiple = TRUE),

					br(),
					h4("The follow only works with the BetaPlot option selected"),
				sliderInput(inputId = "binsGrid3",   label = "Length out:",  min = 20, max = 70, value = 30),
				    # br() element to introduce extra vertical spacing ----
					br(),
					selectInput("variableP13D", "Variable p1:",  c("norm",   "lnorm",  "gamma",  "weibull" , "bestfit"),selected=c("norm")),
					selectInput("variableP23D", "Variable p2:",  c( "norm",   "lnorm",  "gamma",  "weibull" , "bestfit"),selected=c("norm")),
					selectInput("DeadLoad3D", "Dead load: Qdead/Qmax =",  c("0.25" ,   "0.33" ,  "0.5" ,"1" ),selected=c("0.5"))

				),
				tabPanel("4D", h5("Considering the uncertain in both the dead and live loads;",br(), 
					"The theory can be referred to https://doi.org/10.1680/jgeen.20.00204",br(),
					"Developed by Dr xingzhengwu@163.com"),
				br(),
					fileInput('file4D', 'Upload *.qpss File which is composed by Q1 s1 Q2 s2 Q3 s3 for first stage (first row) the same for the 2nd row',
					accept=c('text/csv','text/comma-separated-values,text/plain', '.qpss'),multiple = TRUE),
				br(),
					h4("The follow only works with the BetaPlot option selected"),
				sliderInput(inputId = "binsGrid4",   label = "Length out:",  min = 20, max = 70, value = 30),
				    # br() element to introduce extra vertical spacing ----
					br(),
					selectInput("variableP14D", "Variable p1:",  c("norm",   "lnorm",  "gamma",  "weibull" , "bestfit"),selected=c("norm")),
					selectInput("variableP24D", "Variable p2:",  c( "norm",   "lnorm",  "gamma",  "weibull" , "bestfit"),selected=c("norm")),
					checkboxGroupInput(inputId="DeadLoad4D","Dead load: Qdead/Qmax =",c("0.5","0.55","0.6","0.65"),selected = c("0.5","0.55","0.6","0.65")),
					selectInput("LiveLoad4D", "Live load: Qlive/Qdead =",  c("0.4","0.5","0.6"),selected=c("0.5"))
				)
	  ),
   ),
    mainPanel(

      tabsetPanel(type = "tabs",
                  tabPanel("QsCurve", plotOutput(outputId = "QsCurve",height="600px")),
                  tabPanel("BetaPlot", plotOutput(outputId = "BetaPlot",height="600px")),
                  tabPanel("Summary", tableOutput("Summary"))
      )
    )
  )
)

#
server <- function(input, output,session) {
	valuesWu <- reactiveValues()
	  loadFileDataOnWebSelection <- eventReactive(input$loadQs, {
		req(input$selectedFile)
		res <- httr::GET(input$selectedFile)
		ResList00 <- read.csv(text = httr::content(res, "text"), header = FALSE, sep = " ")
		return(as.matrix(ResList00))
	  })

  output$QsCurve <- renderPlot({
	  	current_tab <- input$your_tabset_id
		DrawOutCurves<-function(ResList){
				nLines<-length(ResList[1,])/2
				matQload<-c()
				matSdisp<-c()
				for (kk in 1:nLines) {
					ResSettle<-cbind(ResList[,kk*2-1],ResList[,kk*2])
					matQload<-cbind(matQload,ResList[,kk*2-1])
					matSdisp<-cbind(matSdisp,ResList[,kk*2])
				}
				MaxTestLoad<-max(matQload)  #4880
				MaxTestDisp<-max(matSdisp)
				plot(0,0,col="white",xlim=c(0,MaxTestLoad),ylim=c(MaxTestDisp,0),yaxt = "n",xaxt="n",xlab="", ylab="")
				axis(2,at=seq(0,MaxTestDisp,5),label=seq(0,MaxTestDisp,5),cex.axis=1)
				axis(3,at=seq(0,MaxTestLoad,500),label=seq(0,MaxTestLoad,500),cex.axis=1)
				mtext(expression(italic(s)~~(mm)),side=2,line=2.85,cex=0.8)
				mtext(expression(italic(Q)~~(kN)),side=3,line=2.85,cex=0.8)
				nLines<-length(ResList[1,])/2
				cols <- hcl.colors(nLines, "Temps")
				for (kk in 1:nLines) {
					points(ResList[,kk*2-1],ResList[,kk*2],col=cols[kk],lwd=1.5,type='b')
				} 
		}
	  	if (current_tab  == "Demo") {
			ResList00<- loadFileDataOnWebSelection()  #readInDemoQscurveData()
				valuesWu$ResList <-ResList00
				DrawOutCurves(ResList00)
		}
		else if (current_tab  == "YouInput") {
				if(is.null(dataYouIn())){
					plot(0, 0, type = "n", axes = FALSE, ann = FALSE)
					text(0.05, 0.5, "Please input the qpss or txt file firstly.", cex = 2)
			}else{ 
				ResList <-as.matrix(dataYouIn()) #as.matrix(read.table(file$datapath,sep=""))
				valuesWu$ResList <-ResList
				DrawOutCurves(ResList)
			} #endif
		}	
		else if (current_tab  == "3D") {
				if(is.null(dataIn3D())){
					plot(0, 0, type = "n", axes = FALSE, ann = FALSE)
					text(0.05, 0.5, "Please input the qpss or txt file firstly.", cex = 2)
				}else{ 
					ResList <-as.matrix(dataIn3D()) #as.matrix(read.table(file$datapath,sep=""))
					valuesWu$ResList <-ResList
					DrawOutCurves(ResList)
					}
		}
		else if (current_tab  == "4D") {
				if(is.null(dataIn4D())){
					plot(0, 0, type = "n", axes = FALSE, ann = FALSE)
					text(0.05, 0.5, "Please input the qpss or txt file firstly.", cex = 2)
				}else{ 
					ResList <-as.matrix(dataIn4D()) #as.matrix(read.table(file$datapath,sep=""))
					valuesWu$ResList <-ResList
					DrawOutCurves(ResList)
					}
		}
  })
  output$BetaPlot <- renderPlot({
               
							FittingMargsAICs<-function(CFAI01){
							  library(fitdistrplus)
							  mode(CFAI01)="numeric" # change type of data from 'list' to 'number' mode
							  minAICs<-matrix(c(fitdist(CFAI01, "norm",method="mme")$aic,fitdist(CFAI01, "lnorm")$aic,fitdist(CFAI01, "gamma",method="mme")$aic,fitdist(CFAI01, "weibull")$aic),ncol=4)
							  whichmin<-which(minAICs == min(minAICs), arr.ind = TRUE)
							  if (whichmin[2]==1) {
								parmrg11<-fitdist(CFAI01, "norm",method="mme")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "norm",method="mme")[1]$estimate[2]
								bestDist1<-"norm"
							  }
							  if (whichmin[2]==2) {
								parmrg11<-fitdist(CFAI01, "lnorm")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "lnorm")[1]$estimate[2]
								bestDist1<-"lnorm"
							  }
							  if (whichmin[2]==3) {
								parmrg11<-fitdist(CFAI01,"gamma",method="mme")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "gamma",method="mme")[1]$estimate[2]
								bestDist1<-"gamma"
							  }
							  if (whichmin[2]==4) {
								parmrg11<-fitdist(CFAI01, "weibull")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "weibull")[1]$estimate[2]
								bestDist1<-"weibull"
							  }
							  list(parmrg11=parmrg11,parmrg12=parmrg12, bestDist1=bestDist1,minAICs=minAICs)
							}

							SpecMargsPars<-function(CFAI01,strMargDist){

							  #library(MASS) # package 'MASS' is loaded
							  if (strMargDist=="norm") {
								parmrg11<-fitdist(CFAI01, "norm",method="mme")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "norm",method="mme")[1]$estimate[2]
							  }
							  if (strMargDist=="lnorm") {
								parmrg11<-fitdist(CFAI01, "lnorm")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "lnorm")[1]$estimate[2]
							  }
							  if (strMargDist=="weibull") {
								parmrg11<-fitdist(CFAI01, "weibull")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "weibull")[1]$estimate[2]
							  }
							  if (strMargDist=="gamma") {
								parmrg11<-fitdist(CFAI01,"gamma",method="mme")[1]$estimate[1]
								parmrg12<-fitdist(CFAI01, "gamma",method="mme")[1]$estimate[2]
							  }
							  list(parmrg11=parmrg11,parmrg12=parmrg12)
							}
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
						}
	current_tab <- input$your_tabset_id
  	if ( current_tab  == "Demo") {
		TmpSettleAllow<-40  #as.numeric(input$allowsettle)
		ResList<- loadFileDataOnWebSelection()  # readInDemoQscurveData()
				library(fitdistrplus)
				transferBiNorm2Environ<-function(beta_star,rho12,Parametersp11,Parametersp12,Parametersp21,Parametersp22){
					n_point=200
					angle = seq(0, 2*pi, length.out = n_point+1)
					u1mat=rep(beta_star, each=n_point+1)*cos(angle)
					u2mat=rep(beta_star, each=n_point+1)*sin(angle)
					y1mat=pnorm(u1mat)
					y2mat=pnorm(u2mat*sqrt(1-rho12 ^2)+rho12*u1mat)
					p1mat=qnorm(y1mat,Parametersp11,Parametersp12)
					p2mat=qnorm(y2mat,Parametersp21,Parametersp22)
					list(p1mat=p1mat,p2mat=p2mat)
				}
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
						Parametersp11<-as.numeric(fitdist(ParsS[,1], "norm",method="mme")[1]$estimate[1])
						Parametersp12<-as.numeric(fitdist(ParsS[,1], "norm",method="mme")[1]$estimate[2])
						bestDist01<-"norm"
						Parametersp21<-as.numeric(fitdist(ParsS[,2], "norm",method="mme")[1]$estimate[1])
						Parametersp22<-as.numeric(fitdist(ParsS[,2], "norm",method="mme")[1]$estimate[2])
						bestDist02<-"norm"
						maxP1<-max(ParsS[,1])
						maxP2<-max(ParsS[,2])
					rho12<-  input$bins  #-0.77
					TmpFsSetUp<- 2 #as.numeric(input$FsIn)
					FosS<-TmpFsSetUp  
					ffk<-function (p1Spec,p2Spec,MeanMaxTestLoad){
					  SettleAllowable<-TmpSettleAllow #40
					  Rq<-p1Spec*SettleAllowable**p2Spec
					  Sq<-MeanMaxTestLoad/FosS
					  F0STotal<-Rq-Sq
					  F0STotal
					}
						fff2d<-function(p1Spec,p2Spec,MsFactor){ 
								SettleAllowable<-40  #40 mm
								Rq<-p1Spec*SettleAllowable**p2Spec    #power law relation Qua
								Sq<-MsFactor  #QLD
								FOSTotal<-Rq-Sq #g = Qua − QLD
								FOSTotal	
						}

						fLSF2d <- function(beta_star) {
								res_x<-transferUnit2Physical2d(beta_star,rho12)
								p1Spec <- res_x[[1]]
								p2Spec <- res_x[[2]]

								SettleAllowable<-40  #40 mm
								Rq<-p1Spec*SettleAllowable**p2Spec    #power law relation Qua
								Sq<-MsFactor  #QLD
								FOSTotal<-min(Rq-Sq) #g = Qua − QLD
								return(FOSTotal)
						}
							BFfzeroWu<- function(fLSF, aLower, bUpper) {
								num = 10
								eps = 1e-03
								hIncre = abs(bUpper - aLower)/num
								iBFf = 0
								jBFf = 0
								a1 = b1 = 0
								while (iBFf <= num) {
										a1 = aLower + iBFf * hIncre
										b1 = a1 + hIncre
										if (fLSF(a1) == 0) {
											print(a1)
											print(fLSF(a1))
										}
										else if (fLSF(b1) == 0) {
											print(b1)
											print(fLSF(b1))
										}
										else if (fLSF(a1) * fLSF(b1) < 0) {
											repeat {
												if (abs(b1 - a1) < eps) 
												  break
												xBFf <- (a1 + b1)/2
												if (fLSF(a1) * fLSF(xBFf) < 0) 
												  b1 <- xBFf
												else a1 <- xBFf
											}
											print(jBFf + 1)
											jBFf = jBFf + 1
											return((a1 + b1)/2)
											return(fLSF((a1 + b1)/2))
										}
										iBFf = iBFf + 1
								}
								if (jBFf == 0) 
									print("finding root is fail")
									else return(list((a1 + b1)/2,fLSF((a1 + b1)/2)))
							}
						transferUnit2Physical2d<-function(beta_star,rho12){
								if (!is.numeric(beta_star) || length(beta_star) != 1) {
									stop("beta_star must be a numerical value")
								}
						  
								u<-seq(0, 2*pi, length.out = 30)
								u1mat <- beta_star*cos(u)
								u2mat <- beta_star*sin(u)
								xx1<- qnorm(pnorm(u1mat), mean1, sd1)    #
								ρ21 <- rho12 #as.numeric(matrix(RR[2, 1], nr = 1))
								Uc2<-ρ21*u1mat
								zegmac2<-sqrt(1-ρ21 ^2)
								asx2<-u2mat*zegmac2+Uc2
								xx2<-qnorm(pnorm(asx2), mean2, sd2)  #
								list(xx1,xx2)
						}
				iSolverCase<-input$optimization_solver  #2
				mean1<-Parametersp11
				sd1<-Parametersp12
				mean2<-Parametersp21
				sd2<-Parametersp22
				MsFactor<-MeanMaxTestLoad/FosS
								if (iSolverCase=="ECM") {
									betaMatrix<-seq(0,10,0.01)
									for (ijk in 1:1000) {
										beta_star=betaMatrix[ijk]
										res_x<-transferUnit2Physical2d(beta_star,rho12)
										xx1Mat <- res_x[[1]]
										xx2Mat <- res_x[[2]]
										 asz1<-fff2d(xx1Mat,xx2Mat,MsFactor)
										 if (any(asz1<0)) { 
											  xx1<-xx1Mat[which.min(asz1)]
											  xx2<-xx2Mat[which.min(asz1)]
												beta_star_crit<-beta_star
												break #	
											}#end if
									} #end for
								}
								if (iSolverCase=="IBM") {
									
									if(!require(NLRoot)) install.packages("NLRoot")
									library(NLRoot)
									aLower <- c(0) #beta=0
									bUpper <- c(10) #beta=10
										ResBM <- BFfzeroWu(fLSF2d, aLower, bUpper)
									beta_star_crit <- as.numeric(ResBM)
								}
								if (iSolverCase=="SQP") {
											if(!require(NlcOptim)) install.packages("NlcOptim")
											library(NlcOptim)
											objective_function <- function(beta_star) {
												return(beta_star[1])
											}
								
											constraint_function <- function(beta_star) {
													beta_star <- beta_star[1]
													res_xMat <- transferUnit2Physical2d(beta_star,rho12)
												  p1Spec <- res_xMat[[1]]
												  p2Spec <- res_xMat[[2]]
												  SettleAllowable <- 40  # 40 mm
												  Rq <- p1Spec * SettleAllowable^p2Spec  # power law relation Qua
												  Sq <- MsFactor  # QLD
													FOSTotal <- min(Rq - Sq)  #any one is less than zero
												  return(list(ceq=NULL,c=FOSTotal))  #see NlcOptim.pdf page 3
											}
											start_values <- c(1.24)  # 
											lower_bounds <- c(0)  # 
											upper_bounds <- c(8)
											ResSO <- solnl(X = start_values, objfun = objective_function, confun = constraint_function, lb = lower_bounds, ub = upper_bounds)
											beta_star_crit <- as.numeric(ResSO$par)
											beta_star_crit
								}
								if (iSolverCase=="") {
									iSolverCase<-"444"
								}
								if (iSolverCase=="444") {
										beishu2<-20
										beishu1<-0

										for(kk in 1:1000){
											beta<-(beishu1+beishu2)/2
											beta_star=beta
											ECxy<-transferBiNorm2Environ(beta_star,rho12,Parametersp11,Parametersp12,Parametersp21,Parametersp22)
											KK_f<-ffk(ECxy$p1mat,ECxy$p2mat,MeanMaxTestLoad) #MsFactor
											KK_f0<-KK_f[KK_f>=0]
											KK_fL<-length(KK_f0)
											if(KK_fL==length(KK_f)){
													beishu1<-beta
											 }else{
													beishu2<-beta
											}       
											if(abs(beishu1-beishu2)<0.00001){	   
													xx1 <- ECxy$p1mat[which.min(KK_f)]
													xx2 <- ECxy$p2mat[which.min(KK_f)]
													break
											}
										}
										beta_star_crit<-beta
								}
					betaReal<-round(beta_star_crit,2)
					print (betaReal)
					plot(0,0,col="white",xlim=c(0,maxP1*1.5),ylim=c(0.0,maxP2*1.5),xlab=expression(paste(~~italic(p[1]))),
						 ylab=expression(paste(~~italic(p[2]))),pch=8,cex=0.7,xaxt="n",yaxt="n")
					axis(1,at=seq(0,maxP1*1.5,200),label=seq(0,maxP1*1.5,200));
					axis(2,at=seq(0.0,maxP2*1.5,0.2),label=seq(0.0,maxP2*1.5,0.2))
					points(ParsS[,1],ParsS[,2],col=hcl.colors(nLines, "Temps"),pch=3,lty=1,lwd=1.5) #observed points
					ECxyOne<-transferBiNorm2Environ(1,rho12,Parametersp11,Parametersp12,Parametersp21,Parametersp22)
					ECxy<-transferBiNorm2Environ(beta_star_crit,rho12,Parametersp11,Parametersp12,Parametersp21,Parametersp22)
					points(cbind(ECxyOne$p1mat,ECxyOne$p2mat),type='l',lty=1,col="pink",lwd=5)
					points(mean(ParsS[,1]),mean(ParsS[,2]),pch=1,col="darkred")
					points(ECxy$p1mat[which.min(ffk(ECxy$p1mat,ECxy$p2mat,MeanMaxTestLoad))],ECxy$p2mat[which.min(ffk(ECxy$p1mat,ECxy$p2mat,MeanMaxTestLoad))],pch=10,cex=1,col="blue3") #design point
					points(cbind(ECxy$p1mat,ECxy$p2mat),type="l",lty=2,col="deepskyblue3",lwd=2) # critical ellipse
					leg5<-paste("Observed regression parameters",sep="")
					leg7<-paste("design point",sep="")
					legend("bottomleft", c(leg5,leg7),pch=c(4,10), col=c("forestgreen","blue3"),cex=1,bg = "white")
					legend("topright", legend =c(bquote(italic(β) == .(betaReal)),bquote(italic(β) == 1)),lty=c(2,1), col=c("deepskyblue3","pink"),lwd=c(2,5),cex=1,bg = "white")	
	}
	else if ( current_tab  == "YouInput") {
				if(is.null(dataYouIn())){
					plot(0, 0, type = "n", axes = FALSE, ann = FALSE)
					text(0.5, 0.5, "Please input the qpss or txt file firstly.", cex = 2)
			}else{ 
							library(fitdistrplus)
							transferStand2Environ<-function(beta_star,rho12,bestDist01,Parametersp11,Parametersp12,bestDist02,Parametersp21,Parametersp22){
								n_point=200
								angle = seq(0, 2*pi, length.out = n_point+1)
								u1mat=rep(beta_star, each=n_point+1)*cos(angle)
								u2mat=rep(beta_star, each=n_point+1)*sin(angle)
								y1mat=pnorm(u1mat)
								y2mat=pnorm(u2mat*sqrt(1-rho12 ^2)+rho12*u1mat)
								p1mat=qmargdist(y1mat,bestDist01,Parametersp11,Parametersp12)
								p2mat=qmargdist(y2mat,bestDist02,Parametersp21,Parametersp22)
								list(p1mat=p1mat,p2mat=p2mat)
						}
				dd <- reactive({
						SettleAllowed <- switch(input$allowsettle, 40, 25)
						FsSetUp <- switch(input$FsIn, 2, 3)
					})
					TmpSettleAllow<-as.numeric(input$allowsettle)
					ResList <-as.matrix(dataYouIn()) #as.matrix(read.table(file$datapath,sep=""))
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
					distType01<- input$variableP12D  # "norm"
					if (distType01=="bestfit") {
						fit01<-FittingMargsAICs(ParsS[,1])
						Parametersp11<-fit01$parmrg11
						Parametersp12<-fit01$parmrg12
						bestDist01<-fit01$bestDist1
					}else{
						bestDist01<-distType01 #"norm"
						fit01<-SpecMargsPars(ParsS[,1],bestDist01)
						Parametersp11<-fit01$parmrg11
						Parametersp12<-fit01$parmrg12
					}
					distType02<- input$variableP22D  # "norm"
					if (distType02=="bestfit") {
						fit02<-FittingMargsAICs(ParsS[,2])
						Parametersp21<-fit02$parmrg11
						Parametersp22<-fit02$parmrg12
						bestDist02<-fit02$bestDist1
					}else{  #specify distr
						bestDist02<-distType02 #"norm"
						fit02<-SpecMargsPars(ParsS[,2],bestDist02)
						Parametersp21<-fit02$parmrg11
						Parametersp22<-fit02$parmrg12
					}
						maxP1<-max(ParsS[,1])
						maxP2<-max(ParsS[,2])
					rho12<--0.77
					TmpFsSetUp<- as.numeric(input$FsIn)
					FosS<-TmpFsSetUp  
					ffk<-function (p1Spec,p2Spec,MeanMaxTestLoad){
					  SettleAllowable<-TmpSettleAllow #40
					  Rq<-p1Spec*SettleAllowable**p2Spec
					  Sq<-MeanMaxTestLoad/FosS
					  F0STotal<-Rq-Sq
					  F0STotal
					}
					fff<-function(p2Spec,MeanMaxTestLoad){
					  SettleAllowable<-TmpSettleAllow #40
					  q1=MeanMaxTestLoad/FosS
					  q1/(SettleAllowable**p2Spec)
					} #limit state function
					beishu2<-20
					beishu1<-0
					for(kk in 1:1000){
						beta<-(beishu1+beishu2)/2
						beta_star=beta
						ECxy<-transferStand2Environ(beta_star,rho12,bestDist01,Parametersp11,Parametersp12,bestDist02,Parametersp21,Parametersp22)
						KK_f<-ffk(ECxy$p1mat,ECxy$p2mat,MeanMaxTestLoad) #MsFactor
						KK_f0<-KK_f[KK_f>=0]
						KK_fL<-length(KK_f0)
						if(KK_fL==length(KK_f)){
								beishu1<-beta
						 }else{
								beishu2<-beta
						}       
						if(abs(beishu1-beishu2)<0.00001){	   
								xx1 <- ECxy$p1mat[which.min(KK_f)]
								xx2 <- ECxy$p2mat[which.min(KK_f)]
								break
						}
					}
					betaReal<-round(beta,2)
					print (betaReal)
					plot(0,0,col="white",xlim=c(0,maxP1*1.5),ylim=c(0.0,maxP2*1.5),xlab=expression(paste(~~italic(p[1]))),
						 ylab=expression(paste(~~italic(p[2]))),pch=8,cex=0.7,xaxt="n",yaxt="n")
					axis(1,at=seq(0,maxP1*1.5,200),label=seq(0,maxP1*1.5,200));
					axis(2,at=seq(0.0,maxP2*1.5,0.2),label=seq(0.0,maxP2*1.5,0.2))
					points(ParsS[,1],ParsS[,2],col=hcl.colors(nLines, "Temps"),pch=3,lty=1,lwd=1.5) #observed points
					
					#drawing beta=1 profile
					ECxyOne<-transferStand2Environ(1,rho12,bestDist01,Parametersp11,Parametersp12,bestDist02,Parametersp21,Parametersp22)

					points(cbind(ECxyOne$p1mat,ECxyOne$p2mat),type='l',lty=1,col="pink",lwd=5)
					points(mean(ParsS[,1]),mean(ParsS[,2]),pch=1,col="darkred")
					#points(xy0,col="darkorange2",type="l",lwd=3) # #limit state curve
					points(xx1,xx2,pch=10,cex=1,col="blue3") #design point
					points(cbind(ECxy$p1mat,ECxy$p2mat),type="l",lty=2,col="deepskyblue3",lwd=2) # critical ellipse
					leg5<-paste("Observed regression parameters",sep="")
					leg7<-paste("design point",sep="")
					legend("bottomleft", c(leg5,leg7),pch=c(4,10), col=c("forestgreen","blue3"),cex=1,bg = "white")
					legend("topright", legend =c(bquote(italic(β) == .(betaReal)),bquote(italic(β) == 1)),lty=c(2,1), col=c("deepskyblue3","pink"),lwd=c(2,5),cex=1,bg = "white")	
				} #endif

	} else if ( current_tab  == "3D")  {
					if(is.null(dataIn3D())){
							plot(0, 0, type = "n", axes = FALSE, ann = FALSE)
							text(0.5, 0.5, "Please input the qpss or txt file firstly.", cex = 2)
					}else{ 
						options(repos = c(CRAN = "https://cran.r-project.org"))
					install.packages("pracma")
						library(pracma)  #inpoly function 2012/10/8
						library(copula)
					install.packages("gtools")
						library(gtools)
						library(misc3d)
						library(ptinpoly)
						library(fitdistrplus) #declare fitdistplus package for marginal distributions
					install.packages("plot3D")
						library(plot3D) #scatter3D
						fff<-function(p1Spec,p2Spec,MsFactor){ 
									SettleAllowable<-40  #40 mm
									Rq<-p1Spec*SettleAllowable**p2Spec    #power law relation Qua
									Sq<-MsFactor  #QLD 
									FOSTotal<-Rq-Sq #g = Qua − QLD
									FOSTotal	
							}
						numgrid3<-input$binsGrid3 #30
						transferUnit2Physical3D<-function(beta_star){
							M  <- mesh(seq(0, 2*pi, length.out = numgrid3),   seq(0,   pi, length.out = numgrid3))
							u  <- M$x ; v  <- M$y
							u1mat <- beta_star*cos(u)*sin(v)
							u2mat <- beta_star*sin(u)*sin(v)
							u3mat <- beta_star*cos(v)
							xx1=qmargdist(pnorm(u1mat),bestDist01,Parametersp11,Parametersp12)
							ρ21<-matrix(RR[2,1],nr=1)  
							ρ21=as.numeric(ρ21)
							Uc2=ρ21*u1mat
							zegmac2=sqrt(1-ρ21 ^2)
							asx2=u2mat*zegmac2+Uc2
							xx2=qmargdist(pnorm(asx2),bestDist02,Parametersp21,Parametersp22)
							ρ12<-matrix(RR[1,2],nr=1)
							ρ12<-as.numeric(ρ12)
							ρ13<-matrix(RR[1,3],nr=1)
							ρ13<-as.numeric(ρ13)
							ρ23<-matrix(RR[2,3],nr=1)
							ρ23<-as.numeric(ρ23)
							Uc3=((ρ13-ρ12*ρ23)*u1mat+(ρ23-ρ12*ρ13)*u2mat)/(1-ρ12 ^2)
							zegmac3=sqrt(1-ρ12 ^2-ρ13 ^2-ρ23 ^2+2*ρ12*ρ13*ρ23)/sqrt(1-ρ12 ^2)
							asx3=u3mat*zegmac3+Uc3
							xx3=qlnorm(pnorm(asx3), meanlog=mean3, sdlog=sd3) #
							list(xx1,xx2,xx3)
						}
						ResList <-as.matrix(dataIn3D()) #as.matrix(read.table(file$datapath,sep=""))
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
							distType01<-input$variableP13D # "gamma" #variableP13D
							if (distType01=="bestfit") {
								fit01<-FittingMargsAICs(ParsS[,1])
								Parametersp11<-fit01$parmrg11
								Parametersp12<-fit01$parmrg12
								bestDist01<-fit01$bestDist1
							}else{
								bestDist01<-distType01 #"norm"
								fit01<-SpecMargsPars(ParsS[,1],bestDist01)
								Parametersp11<-fit01$parmrg11
								Parametersp12<-fit01$parmrg12
							}
							distType02<- input$variableP23D # "weibull"  #variableP23D
							if (distType02=="bestfit") {
								fit02<-FittingMargsAICs(ParsS[,2])
								Parametersp21<-fit02$parmrg11
								Parametersp22<-fit02$parmrg12
								bestDist02<-fit02$bestDist1
							}else{  #specify distr
								bestDist02<-distType02 #"norm"
								fit02<-SpecMargsPars(ParsS[,2],bestDist02)
								Parametersp21<-fit02$parmrg11
								Parametersp22<-fit02$parmrg12
							}
								maxP1<-max(ParsS[,1])
								maxP2<-max(ParsS[,2])
						mean33Tmp<-MeanMaxTestLoad*as.numeric(input$DeadLoad3D) #Qmax/2 
						cov33<-0.1
						sd33Tmp<-mean33Tmp*cov33
						meanlog<-log(mean33Tmp*mean33Tmp/sqrt(mean33Tmp*mean33Tmp+sd33Tmp*sd33Tmp))
						sdlog<-sqrt(log((mean33Tmp*mean33Tmp+sd33Tmp*sd33Tmp)/(mean33Tmp*mean33Tmp)))
						mean3=round(meanlog,2); sd3=round(sdlog,2)
						RR<-cor(ParsS[,1:3])
						RR[1,3]<-0; RR[3,1]<-0
						RR[2,3]<-0; RR[3,2]<-0
						beta0<-0
						betam<-10
						jloop=0
						while (TRUE) {
							jloop<-jloop+1
							beta=(betam+beta0)/2
							beta_star=beta
							res_x<-transferUnit2Physical3D(beta_star)
								xx1 <- res_x[[1]]
								xx2 <- res_x[[2]]
								xx3 <- res_x[[3]]
							 asz1<-fff(xx1,xx2,xx3)
							 if (length(xx1)==length(asz1[asz1>0])) { 
									beta0<-beta	
								}else{
									betam<-beta
								}#end if
							  if(betam-beta0<=0.00001){
								  beta<-beta0
								  xxx11<-xx1[which.min(asz1)]
								  xxx22<-xx2[which.min(asz1)]
								  xxx33<-xx3[which.min(asz1)]
								  break
							  } #end if
						} #end while
							beta0=beta
							beta_star=beta0
							res_p<-transferUnit2Physical3D(beta_star)
								xx1_p <- res_p[[1]]
								xx2_p <- res_p[[2]]
								xx3_p <- res_p[[3]]
							beta0=1
							beta_star=beta0
							res_u<-transferUnit2Physical3D(beta_star)
								xx1_u <- res_u[[1]]
								xx2_u <- res_u[[2]]
								xx3_u <- res_u[[3]]
						surf3D(xx1_p,xx2_p,xx3_p,alpha =1 , phi =20,theta=120,ticktype = "detailed",colkey = FALSE, facets = FALSE,col = jet.col(n = 1000, alpha = 0.5),
						bty = "g",lwd=4,xlim=c(min(xx1_p),max(xx1_p)*1.2), ylim=c(min(xx2_p),max(xx2_p)*1.2), zlim =c(min(xx3_p),max(xx3_p)*1.2),xlab = "", ylab = "",zlab="")
						surf3D(xx1_u,xx2_u,xx3_u,alpha =1 , phi =20,theta=120,ticktype = "detailed",colkey = FALSE, facets = FALSE,col = jet.col(n = 1000, alpha = 0.5),add=TRUE)
						scatter3D(xxx11,xxx22,xxx33,pch=10,cex =3 ,add=TRUE,col="blue3")
						plotdev(alpha = 0.3)
						text(-0.18,-0.45,expression(italic(p[2])),cex=1.0,srt=0)
						text(0.32,-0.38,expression(italic(p[1])),cex=1.0,srt=0)
						text(-0.50,-0.05,expression(italic(Q[design])~"/"~kN),cex=1.0,srt=95)
						leg1<-expression(paste("inner contour"~italic(β)~"=1"))
						realBeta<-round(beta,2)
						leg2<-substitute(paste("outer contour" ~ italic(β) ~ "=" ~ b, sep=""),  list(b = realBeta))
						legend("topright", c(leg1,leg2),cex=1,bg = "white",bty="c",x.intersp=0.1,y.intersp=0.8)
						leg3<-paste("design point",sep="")
						legend("bottomleft", c(leg3),pch=c(10), col=c("blue3"),cex=0.95,bg = "white")
					}
	
	}else if ( current_tab  == "4D") {

					if(is.null(dataIn4D())){
							plot(0, 0, type = "n", axes = FALSE, ann = FALSE)
							text(0.5, 0.5, "Please input the qpss or txt file firstly.", cex = 2)
					}else{ 
						library(pracma)  #inpoly function 2012/10/8
						library(copula)
						library(gtools)
						library(misc3d)
						library(ptinpoly)
						library(fitdistrplus) #
						library(plot3D) #scatter3D
								numgrid4<- input$binsGrid4
						TransferUnit2Phy4D<-function(beta_star){
									  dgumbel <- function(x,a,b) 1/b*exp((a-x)/b)*exp(-exp((a-x)/b))
									  pgumbel <- function(q,a,b) exp(-exp((a-q)/b))
									  qgumbel <- function(p,a,b) a-b*log(-log(p))
									M  <- mesh(seq(0, 2*pi, length.out = numgrid4), 
											   seq(0,   pi, length.out = numgrid4))
									u  <- M$x ; v  <- M$y
									u1mat <- beta_star*cos(u)*sin(v)
									u2mat <- beta_star*sin(u)*sin(v)
									u3mat <- beta_star*cos(v)
									xx1=qmargdist(pnorm(u1mat),bestDist01,Parametersp11,Parametersp12)
									ρ21<-matrix(RR[2,1],nr=1)  
									ρ21=as.numeric(ρ21)
									Uc2=ρ21*u1mat
									zegmac2=sqrt(1-ρ21 ^2)
									asx2=u2mat*zegmac2+Uc2
									xx2=qmargdist(pnorm(asx2),bestDist02,Parametersp21,Parametersp22)
									ρ12<-matrix(RR[1,2],nr=1)
									ρ12<-as.numeric(ρ12)
									ρ13<-matrix(RR[1,3],nr=1)
									ρ13<-as.numeric(ρ13)
									ρ23<-matrix(RR[2,3],nr=1)
									ρ23<-as.numeric(ρ23)
									Uc3=((ρ13-ρ12*ρ23)*u1mat+(ρ23-ρ12*ρ13)*u2mat)/(1-ρ12 ^2)
									zegmac3=sqrt(1-ρ12 ^2-ρ13 ^2-ρ23 ^2+2*ρ12*ρ13*ρ23)/sqrt(1-ρ12 ^2)
									asx3=u3mat*zegmac3+Uc3
									xx3=qgumbel(pnorm(asx3), a=mean3, b=sd3) #
								list(xx1,xx2,xx3)
						}
						par(mfrow = c(2, 2))	
							ResList <-as.matrix(dataIn4D()) #as.matrix(read.table(file$datapath,sep=""))
						for (ijk in 1:4) {
								fff<-function(p1Spec,p2Spec,MsFactor){ 
											SettleAllowable<-40  #40 mm
											Rq<-p1Spec*SettleAllowable**p2Spec    #power law relation Qua
											Sq<-(MsFactor1+MsFactor)  #QLD  live + dead
											FOSTotal<-Rq-Sq #g = Qua − QLD
											FOSTotal	
									}
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
							distType01<-  input$variableP14D #"gamma"
							if (distType01=="bestfit") {
								fit01<-FittingMargsAICs(ParsS[,1])
								Parametersp11<-fit01$parmrg11
								Parametersp12<-fit01$parmrg12
								bestDist01<-fit01$bestDist1
							}else{
								bestDist01<-distType01 #"norm"
								fit01<-SpecMargsPars(ParsS[,1],bestDist01)
								Parametersp11<-fit01$parmrg11
								Parametersp12<-fit01$parmrg12
							}
							distType02<- input$variableP24D #"weibull"
							if (distType02=="bestfit") {
								fit02<-FittingMargsAICs(ParsS[,2])
								Parametersp21<-fit02$parmrg11
								Parametersp22<-fit02$parmrg12
								bestDist02<-fit02$bestDist1
							}else{  #specify distr
								bestDist02<-distType02 #"norm"
								fit02<-SpecMargsPars(ParsS[,2],bestDist02)
								Parametersp21<-fit02$parmrg11
								Parametersp22<-fit02$parmrg12
							}
								maxP1<-max(ParsS[,1])
								maxP2<-max(ParsS[,2])
								QdeadTmp<-ParsS[1,3]/2 #Qmax/2 =Qdesign =Qdead
								CoV44Tmp<-0.2 #live load
								if (ijk==1) {
									MsFactor1=QdeadTmp*1.00  #1350
									QliveTmp<-MsFactor1*as.numeric(input$LiveLoad4D) # 
									mean44Tmp<-QliveTmp
									sd44Tmp<-mean44Tmp*CoV44Tmp
									 sd3=sqrt(6)*sd44Tmp/pi ; 
									mean3=mean44Tmp-0.5772*sd3 
								}
								if (ijk==2) {
									MsFactor1=QdeadTmp*1.1 #1500
									QliveTmp<-MsFactor1*as.numeric(input$LiveLoad4D)
									mean44Tmp<-QliveTmp
									sd44Tmp<-mean44Tmp*CoV44Tmp
									 sd3=sqrt(6)*sd44Tmp/pi ; 
									mean3=mean44Tmp-0.5772*sd3 
								}
								if (ijk==3) {
									MsFactor1=QdeadTmp*1.2
									QliveTmp<-MsFactor1*as.numeric(input$LiveLoad4D)
									mean44Tmp<-QliveTmp
									sd44Tmp<-mean44Tmp*CoV44Tmp
									 sd3=sqrt(6)*sd44Tmp/pi ; 
									mean3=mean44Tmp-0.5772*sd3 
								}
								if (ijk==4) {
									MsFactor1=QdeadTmp*1.3
									QliveTmp<-MsFactor1*as.numeric(input$LiveLoad4D)
									mean44Tmp<-QliveTmp
									sd44Tmp<-mean44Tmp*CoV44Tmp
									 sd3=sqrt(6)*sd44Tmp/pi ; 
									mean3=mean44Tmp-0.5772*sd3 
								}
								RR<-cor(ParsS[,1:3])
								RR[1,3]<-0; RR[3,1]<-0
								RR[2,3]<-0; RR[3,2]<-0
								beta0<-0
								betam<-10
								jloop=0
								while (TRUE) {
									jloop<-jloop+1
									beta=(betam+beta0)/2
									beta_star=beta
									res_x<-TransferUnit2Phy4D(beta_star)
									xx1<-res_x[[1]]
									xx2<-res_x[[2]]
										xx3<-res_x[[3]]
									 asz1<-fff(xx1,xx2,xx3)
									 if (length(xx1)==length(asz1[asz1>0])) { 
											beta0<-beta	
										}else{
											betam<-beta
										}#end if
									  if(betam-beta0<=0.00001){
										  beta<-beta0
										  xxx11<-xx1[which.min(asz1)]
										  xxx22<-xx2[which.min(asz1)]
										  xxx33<-xx3[which.min(asz1)]
										  break
									  } #end if
								} #end while
									beta0=beta
									beta_star=beta0
									res_p<-TransferUnit2Phy4D(beta_star)
									xx1_p<-res_p[[1]]
									xx2_p<-res_p[[2]]
										xx3_p<-res_p[[3]]
								par(mar = c(2, 1, 1, 1))
								surf3D(xx1_p,xx2_p,xx3_p,alpha =1 , phi =20,theta=120,ticktype = "detailed",colkey = FALSE, facets = FALSE,col = jet.col(n = 1000, alpha = 0.5),
								bty = "g",lwd=4,xlim=c(min(xx1_p),max(xx1_p)*1.2), ylim=c(min(xx2_p),max(xx2_p)*1.2), zlim =c(min(xx3_p),max(xx3_p)*1.2),xlab = "", ylab = "",zlab="")

								text(-0.18,-0.48,expression(italic(p[2])),cex=1.0,srt=0)
								text(0.35,-0.35,expression(italic(p[1])),cex=1.0,srt=0)
								text(-0.36,0.00,expression(italic(Q[live])~"/"~kN),cex=1.0,srt=90)
								legend("bottomleft",c(expression(paste(~~italic(β)~~"=")),round(beta,2)),x.intersp=0.0001,ncol=2,cex=0.95,bg = "white")
								legend("topright",c(expression(paste(~~italic(Q[dead])~~"=")),round(MsFactor1,2)),x.intersp=0.0001,ncol=2,cex=0.95,bg = "white")
						}
				} #else
		} #4D
  })

		output$downloadQpssData <- downloadHandler(
			  filename = function() {
				selected_name <- names(selectedFileChoices)[which(selectedFileChoices == input$selectedFile)]
				paste0(selected_name, ".txt")  # 
			},
			  content = function(file) {
				req(input$selectedFile)  #
				res <- httr::GET(input$selectedFile)  # 
				writeLines(httr::content(res, "text"), con = file)  # 
			  }
		)
	dataYouIn <- reactive({
		file1 <- input$file1In
		if(is.null(file1)){return()} 
		read.table(file1$datapath,sep="")
	})
	dataIn3D <- reactive({
		file3 <- input$file3D
		if(is.null(file3)){return()} 
		read.table(file3$datapath,sep="")
	})
	dataIn4D <- reactive({
		file4 <- input$file4D
		if(is.null(file4)){return()} 
		read.table(file4$datapath,sep="")
	})
	output$Summary <- renderTable({

		current_tab <- input$your_tabset_id
	  	if (current_tab  == "Demo") {
			#do nothing
			ResList00<- loadFileDataOnWebSelection()   # 
			ncols <- ncol(ResList00)
				halfncols<-ncols/2
			colnames_list <- c()
			for (icols in 1:halfncols) {
				colnames_list <- c(colnames_list, paste("Q", icols, sep=""), paste("s", icols, sep=""))
			}
			  if (length(colnames_list) == ncols) {
				colnames(ResList00) <- colnames_list
			  } else {
				warning("The number of generated column names does not match the number of columns in the data.")
			  }
			ResList00
		}
		else if (current_tab  == "YouInput") {

			file1 <- input$file1In
			if (is.null(file1)) {
				return(NULL)
			} else {
				data <- read.table(file1$datapath, sep="")
				# You may need to process the data here if necessary
				ncols <- ncol(data)/2
				colnames_list <- c()
				for (icols in 1:ncols) {
					colnames_list <- c(colnames_list, paste("Q", icols, sep=""), paste("s", icols, sep=""))
				}
				colnames(data) <- colnames_list
			   data
				}
		}		else if (current_tab  == "3D") {
						file3D <- input$file3D
						if (is.null(file3D)) {
							return(NULL)
						} else {
							data <- read.table(file3D$datapath, sep="")
							ncols <- ncol(data)/2
							colnames_list <- c()
							for (icols in 1:ncols) {
								colnames_list <- c(colnames_list, paste("Q", icols, sep=""), paste("s", icols, sep=""))
							}
							colnames(data) <- colnames_list
						   data
					}
		}		else if (current_tab  == "4D") {
					
						file4D <- input$file4D
						if (is.null(file4D)) {
							return(NULL)
						} else {
							data <- read.table(file4D$datapath, sep="")
							ncols <- ncol(data)/2
							colnames_list <- c()
							for (icols in 1:ncols) {
								colnames_list <- c(colnames_list, paste("Q", icols, sep=""), paste("s", icols, sep=""))
							}
							colnames(data) <- colnames_list
						   data
					}
	    }
   })
}
shinyApp(ui = ui, server = server)
}
