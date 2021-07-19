
require(R6);

node <- R6::R6Class(

    classname = "node",

    public = list(

        # instantiation attributes
        type           = NULL,
        parent         = NULL,
        children       = NULL,
        columns        = NULL,
        displayLogic   = NULL,
        enterLogic     = NULL,
        properties     = NULL,
        rows           = NULL,
        condition.if   = NULL,
        condition.then = NULL,

        # derived attributes

        # methods
        initialize = function(
            type           = NULL,
            parent         = NULL,
            children       = NULL,
            columns        = NULL,
            displayLogic   = NULL,
            enterLogic     = NULL,
            properties     = NULL,
            rows           = NULL,
            condition.if   = NULL,
            condition.then = NULL
            ) {
                self$type           <- type;
                self$parent         <- parent;
                self$children       <- children;
                self$columns        <- columns;
                self$displayLogic   <- displayLogic;
                self$enterLogic     <- enterLogic;
                self$properties     <- properties;
                self$rows           <- rows;
                self$condition.if   <- condition.if;
                self$condition.then <- condition.then;
            },

        print_node = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            base::cat("\n");
            base::cat(base::paste0(base::rep(indent,self$depth),collapse="") );
            base::cat(base::paste0("(",self$nodeID,") "));
            if (0 == self$nodeID) {
                base::cat("[root]");
                }
            else {
                base::cat(base::paste0("[",
                    self$birthCriterion$varname,   " ",
                    self$birthCriterion$comparison," ",
                    #FUN.format(self$birthCriterion$threshold),
                    self$birthCriterion$threshold,
                    "]"));
                }
            base::cat(base::paste0(", impurity = ",FUN.format(self$impurity)));
            base::cat(base::paste0(", np.count = ",FUN.format(base::length(self$np.rowIDs))));
            base::cat(base::paste0(", p.count = ", FUN.format(base::length(self$p.rowIDs))));
            }

        ), # public = list()

    private = list() # private = list()

    );
