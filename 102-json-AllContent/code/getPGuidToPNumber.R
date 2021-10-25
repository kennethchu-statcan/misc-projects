
getPGuidToPNumber <- function(
    DF.nested = NULL
    ) {

    thisFunctionName <- "getPGuidToPNumber";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested;
    DF.output <- DF.output[DF.output[,'key1'] == 'Page',      ];
    DF.output <- DF.output[DF.output[,'key3'] == 'properties',];
    DF.output <- DF.output[DF.output[,'key4'] == 'pageNumber',];
    DF.output <- DF.output[,c('key2','value')];
    colnames(DF.output) <- c('guid','pageNumber');
    DF.output <- unique(DF.output);

    cat("\n# str(DF.output)\n");
    print(   str(DF.output)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.output );

    }

##################################################
