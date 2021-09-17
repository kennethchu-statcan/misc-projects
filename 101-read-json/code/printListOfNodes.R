
printListOfNodes <- function(
    list.nodes = NULL,
    txt.output = NULL
    ) {

    thisFunctionName <- "printListOfNodes";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if ( !is.null(txt.output) ) {
        file.output <- file(description = txt.output,  open = "wt");
        sink(file = file.output,  type = "output" );
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.nodes[['Root']]$print_node();
    for ( child.guid in list.nodes[['Root']]$get_offspring_IDs() ) {
        printListOfNodes_print.children.nodes(
            guid       = child.guid,
            list.nodes = list.nodes,
            indent     = '    '
            );
        }
    base::cat("\n\n");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if ( !is.null(txt.output) ) {
        sink(file = NULL, type = "output" );
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }

##################################################
printListOfNodes_print.children.nodes <- function(
    guid       = NULL,
    list.nodes = NULL,
    indent     = '  '
    ) {
    list.nodes[[guid]]$print_node(indent = indent);
    if ( length(list.nodes[[guid]]$get_offspring_IDs()) > 0 ) {
        for ( child.guid in list.nodes[[guid]]$get_offspring_IDs() ) {
            printListOfNodes_print.children.nodes(
                guid       = child.guid,
                list.nodes = list.nodes,
                indent     = indent
                );
            }
        }
    }
