
# http://blog.phytools.org/2011/03/prune-tree-to-list-of-taxa.html
# library(devtools)
# install_github("liamrevell/phytools")
library(phytools)
library(ape)

# test code
#tree<-rtree(10)
#write.tree(tree)
#species<-c("t2","t4","t6","t8","t10")
#pruned.tree<-drop.tip(tree,tree$tip.label[-match(species, tree$tip.label)])
#write.tree(pruned.tree)

# ML tree
MLTree <- read.newick(file="RAxML_bipartitions.allseq_JGI_1086.351.1KFG.tre")
# microsporidia
microsporidia <- c("Nempa1","Antlo1","Entbi1","Nosce1","Enccu1","Encin1","Encro1","Enche1")
pruned.tree<-drop.tip(MLTree, MLTree$tip.label[match(microsporidia,MLTree$tip.label)]);
write.tree(pruned.tree,file="1KFG.RAxML.JGI1086.343_pruned.tre")

# BS trees
BSTrees <- read.newick(file="1KFG.JGI11086.351.BS.trees.gz")
microsporidia <- c("Nempa1","Antlo1","Entbi1","Nosce1","Enccu1","Encin1","Encro1","Enche1")
pruned.trees<-lapply(BSTrees,drop.tip,tip=microsporidia)
class(pruned.trees)<-"multiPhylo"
plot(pruned.trees)
write.tree(pruned.trees,file="1KFG.JGI11086.343_pruned.BS.trees")

