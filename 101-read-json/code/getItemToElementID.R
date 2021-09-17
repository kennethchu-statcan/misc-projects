
getItemToElementID <- function(
    DF.nested                  = NULL,
    DF.referentID.to.elementID = NULL
    ) {

    thisFunctionName <- "getItemToElementID";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested[DF.nested[,'key1'] != 'Reference',];
    DF.output <- DF.output[DF.output[,'key4'] %in% c('datapointValue','displayTarget','gotoTarget'),c('key4','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement = "ID")

    DF.references <- DF.nested[        DF.nested[,'key2'] == 'References',];
    DF.references <- DF.references[DF.references[,'key4'] == 'referentId',c('key3','value')];
    colnames(DF.references) <- gsub(x = colnames(DF.references), pattern = "^key3$",  replacement = "ID");
    colnames(DF.references) <- gsub(x = colnames(DF.references), pattern = "^value$", replacement = "referentId");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(x = DF.output, y = DF.references, by = "ID")
    DF.output <- DF.output[,setdiff(colnames(DF.output),"key4")];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x     = DF.output,
        y     = DF.referentID.to.elementID,
        all.x = TRUE,
        by.x  = 'referentId',
        by.y  = 'ID'
        );
    DF.output <- DF.output[,c('ID', 'referentId',	'elementID')];

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
