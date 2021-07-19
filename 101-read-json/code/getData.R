
getData <- function(
    input.file   = NULL,
    RData.output = "data-oidexit.RData"
    ) {

    thisFunctionName <- "getData";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    require(dplyr);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if ( file.exists(RData.output) ) {

        cat(paste0("\n# ",RData.output," already exists; loading this file ...\n"));
        list.json.raw.data <- readRDS(file = RData.output);
        cat(paste0("\n# Loading complete: ",RData.output,"\n"));

    } else {

        list.json.raw.data <- getData_json(
            input.file = input.file
            );

        saveRDS(
            file   = RData.output,
            object = list.json.raw.data
            );

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( list.json.raw.data );

    }

##################################################
getData_json <- function(
    input.file = NULL
    ) {
    require(rjson);
    list.fromJSON <- rjson::fromJSON(file = input.file);
    return( list.fromJSON );
    }
