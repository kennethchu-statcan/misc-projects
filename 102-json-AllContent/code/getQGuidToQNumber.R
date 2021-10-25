
getQGuidToQNumber <- function(
    DF.nested = NULL
    ) {

    thisFunctionName <- "getQGuidToQNumber";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.QGuid.to.QNumber <- DF.nested;
    DF.QGuid.to.QNumber <- DF.QGuid.to.QNumber[DF.QGuid.to.QNumber[,'key1'] == 'Question',      ];
    DF.QGuid.to.QNumber <- DF.QGuid.to.QNumber[DF.QGuid.to.QNumber[,'key3'] == 'properties',    ];
    DF.QGuid.to.QNumber <- DF.QGuid.to.QNumber[DF.QGuid.to.QNumber[,'key4'] == 'questionNumber',];
    DF.QGuid.to.QNumber <- DF.QGuid.to.QNumber[,c('key2','value')];
    colnames(DF.QGuid.to.QNumber) <- c('guid','questionNumber');

    cat("\n# str(DF.QGuid.to.QNumber)\n");
    print(   str(DF.QGuid.to.QNumber)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.QGuid.to.QNumber );

    }

##################################################
