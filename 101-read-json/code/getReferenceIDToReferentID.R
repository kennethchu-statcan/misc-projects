
getReferenceIDToReferentID <- function(
    DF.nested = NULL
    ) {

    thisFunctionName <- "getReferenceIDToReferentID";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested[DF.nested[,'key2'] == 'References',];
    DF.output <- DF.output[DF.output[,'key4'] == 'referentId',c('key3','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^key3$",  replacement = "referenceID");
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement =  "referentID");

    cat("\n# str(DF.output)\n");
    print(   str(DF.output)   );

    cat("\n# DF.output\n");
    print(   DF.output   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.output );

    }

##################################################
