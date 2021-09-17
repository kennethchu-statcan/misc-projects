
getGuidToElementID <- function(
    DF.nested                  = NULL,
    DF.referentID.to.elementID = NULL
    ) {

    thisFunctionName <- "getGuidToElementID";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested[DF.nested[,'key1'] != 'Reference',];
    DF.output <- DF.output[DF.output[,'key3'] %in% c('properties'),c('key2','key4','value')];
    DF.output <- DF.output[DF.output[,'key4'] %in% c('id'),c('key2','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^key2$",  replacement = "guid"      );
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement = "referentID");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x     = DF.output,
        y     = DF.referentID.to.elementID,
        all.x = TRUE,
        by.x  = 'referentID',
        by.y  = 'referentID'
        );
    DF.output <- DF.output[,c('guid','referentID','elementID')];

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
