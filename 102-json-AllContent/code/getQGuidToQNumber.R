
getQGuidToQNumber <- function(
    DF.nested = NULL
    ) {

    thisFunctionName <- "getQGuidToQNumber";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested;
    DF.output <- DF.output[DF.output[,'key1'] == 'Question',      ];
    DF.output <- DF.output[DF.output[,'key3'] == 'properties',    ];
    DF.output <- DF.output[DF.output[,'key4'] == 'questionNumber',];
    DF.output <- DF.output[,c('key2','value')];
    colnames(DF.output) <- c('guid','questionNumber');
    DF.output <- unique(DF.output);

    cat("\n# str(DF.output)\n");
    print(   str(DF.output)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.output );

    }

##################################################
