
getReferentIDToElementID <- function(
    DF.nested = NULL
    ) {

    thisFunctionName <- "getReferentIDToElementIDs";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested[DF.nested[,'key2'] == 'Referents',];
    DF.output <- DF.output[DF.output[,'key4'] == 'id',c('key3','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^key3$",  replacement = "referentID");
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement =  "elementID");

    cat("\n# DF.output\n");
    print(   DF.output   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.output );

    }

##################################################
