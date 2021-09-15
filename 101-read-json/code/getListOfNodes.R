
getListOfNodes <- function(
    list.input              = NULL,
    DF.localization         = NULL,
    DF.item.to.localization = NULL
    ) {

    thisFunctionName <- "getListOfNodes";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(DF.localization)\n");
    print( str(DF.localization)   );

    cat("\nstr(DF.item.to.localization)\n");
    print( str(DF.item.to.localization)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nested <- examineData_nested(
        list.input = list.input
        );

    DF.nested <- DF.nested[DF.nested[,'key1'] != 'Reference',];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nested[DF.nested[,'key3'] == 'if',  'key3'] <- 'condition.if';
    DF.nested[DF.nested[,'key3'] == 'then','key3'] <- 'condition.then';

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(DF.nested)\n");
    print( str(DF.nested)   );

    cat("\nunique(DF.nested[,'key1'])\n");
    print( unique(DF.nested[,'key1'])   );

    cat("\ntable(DF.nested[,c('key1','key3')])\n");
    print( table(DF.nested[,c('key1','key3')])   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    current.depth  <- 0;
    current.nodeID <- 'Root';

    DF.nested[,'depth'] <- NA;
    DF.nested[DF.nested[,'key2'] == current.nodeID,'depth'] <- current.depth;

    list.nodes <- list();
    list.attributes <- getListOfNodes_get.attributes(
        DF.input                = DF.nested[DF.nested[,'key2'] == current.nodeID,],
        DF.localization         = DF.localization,
        DF.item.to.localization = DF.item.to.localization
        );
    list.nodes[[ current.nodeID ]] <- node$new(
        nodeID         = current.nodeID,
        depth          = current.depth,
        type           = list.attributes[['type'          ]],
        properties     = list.attributes[['properties'    ]],
        parent         = list.attributes[['parent'        ]],
        children       = list.attributes[['children'      ]],
        rows           = list.attributes[['rows'          ]],
        columns        = list.attributes[['columns'       ]],
        displayLogic   = list.attributes[['displayLogic'  ]],
        enterLogic     = list.attributes[['enterLogic'    ]],
        condition.if   = list.attributes[['condition.if'  ]],
        condition.then = list.attributes[['condition.then']]
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    current.nodeIDs <- setdiff(unique(DF.nested[,'key2']),current.nodeID);
    while ( length(current.nodeIDs) > 0 & sum(DF.nested[!is.na(DF.nested[,'depth']) & DF.nested[,'depth'] == current.depth,'key3'] == 'children') > 0 ) {

        DF.temp         <- DF.nested[!is.na(DF.nested[,'depth']) & DF.nested[,'depth'] == current.depth,];
        # children.IDs  <- unique(DF.temp[DF.temp[,'key3'] == 'children','value']);
        children.IDs    <- unique(DF.temp[DF.temp[,'key3'] %in% c('children','rows','columns','displayLogic','enterLogic','condition.if','condition.then'),'value']);
        current.nodeIDs <- setdiff(current.nodeIDs,children.IDs);

        current.depth <- current.depth + 1;
        DF.nested[DF.nested[,'key2'] %in% children.IDs,'depth'] <- current.depth;

        for ( nodeID in children.IDs ) {
            list.attributes <- getListOfNodes_get.attributes(
                DF.input                = DF.nested[DF.nested[,'key2'] == nodeID,],
                DF.localization         = DF.localization,
                DF.item.to.localization = DF.item.to.localization
                );
            list.nodes[[ nodeID ]] <- node$new(
                nodeID         = nodeID,
                depth          = current.depth,
                type           = list.attributes[['type'          ]],
                properties     = list.attributes[['properties'    ]],
                parent         = list.attributes[['parent'        ]],
                children       = list.attributes[['children'      ]],
                rows           = list.attributes[['rows'          ]],
                columns        = list.attributes[['columns'       ]],
                displayLogic   = list.attributes[['displayLogic'  ]],
                enterLogic     = list.attributes[['enterLogic'    ]],
                condition.if   = list.attributes[['condition.if'  ]],
                condition.then = list.attributes[['condition.then']]
                );
            }

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( list(DF.nodes = DF.nested , list.nodes = list.nodes) );

    }

##################################################
getListOfNodes_get.attributes <- function(
    DF.input                = NULL,
    DF.localization         = NULL,
    DF.item.to.localization = NULL
    ) {

    list.attributes <- list();
    list.attributes[[ 'type' ]] <- DF.input[1,'key1'];

    attribute.types <- c(
        'parent',
        'properties',
        'children',
        'rows',
        'columns',
        'displayLogic',
        'enterLogic',
        'condition.if',
        'condition.then'
        )

    for ( attribute.type in attribute.types ) {

        list.attributes[[ attribute.type ]] <- NULL;

        DF.attributes <- DF.input[DF.input[,'key3'] == attribute.type,];

        temp.indexes <- unique(DF.attributes[,'index']);
        list.indexes <- list();
        for ( temp.index in temp.indexes ) {

            DF.temp <- DF.attributes[DF.attributes[,'index'] == temp.index,];

            temp.key4s <- unique(DF.temp[,'key4']);
            list.key4s <- list();
            for ( temp.key4 in temp.key4s ) {
                temp.value <- DF.temp[DF.temp[,'key4'] == temp.key4,'value'];
                if ( temp.value %in% DF.localization[,"ID"] ) {
                    DF.one.row <- DF.localization[DF.localization[,"ID"] == temp.value,];
                    temp.value <- paste0(temp.value," (",DF.one.row[,"english"],", ",DF.one.row[,"french" ],")");
                    }
                # if ( temp.value %in% c('68d20178-66cb-4971-b041-a1b24ff0cecb')) {
                #     cat("\n");
                #     cat("\n# temp.value: ",temp.value,"\n");
                #     cat("\n# temp.value %in% DF.item.to.localization[,'ID']: ",temp.value %in% DF.item.to.localization[,"ID"],"\n");
                #     cat("\n# DF.item.to.localization[,'ID']\n");
                #     print(   DF.item.to.localization[,"ID"]   );
                #     }
                if ( temp.value %in% DF.item.to.localization[,"ID"] ) {
                    DF.one.row <- DF.item.to.localization[DF.item.to.localization[,"ID"] == temp.value,];
                    DF.one.row <- DF.one.row[,setdiff(colnames(DF.one.row),"ID")];
                    # temp.value <- paste0(temp.value," (",DF.one.row[,"english"],", ",DF.one.row[,"french"],")");
                    temp.value <- paste0(temp.value," (",paste(DF.one.row,collapse=", "),")");
                    paste(DF.temp[2,],collapse=", ")
                    }
                list.key4s[[ temp.key4 ]] <- temp.value;
                }
            list.indexes[[ temp.index ]] <- list.key4s;

            }
        list.attributes[[ attribute.type ]] <- list.indexes;

        }

    return( list.attributes );

    }
