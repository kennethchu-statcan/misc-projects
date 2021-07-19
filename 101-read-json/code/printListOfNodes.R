
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
    for ( child.ID in as.vector(unlist(list.nodes[['Root']]$children)) ) {
        printListOfNodes_print.children.nodes(
            nodeID     = child.ID,
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
    nodeID     = NULL,
    list.nodes = NULL,
    indent     = '  '
    ) {
    list.nodes[[nodeID]]$print_node(indent = indent);
    if ( length(list.nodes[[nodeID]]$children) > 0 ) {
        for ( child.ID in as.vector(unlist(list.nodes[[nodeID]]$children)) ) {
            printListOfNodes_print.children.nodes(
                nodeID     = child.ID,
                list.nodes = list.nodes,
                indent     = indent
                );
            }
        }
    }
