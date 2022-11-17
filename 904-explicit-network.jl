using PhyloNetworks;    
using CSV, DataFrames;     

CF=readTableCF("/home/maccamp/mccloud-rrt/outputs/904/reduced-btsp.csv");    

using PhyloPlots;    
treefile = joinpath("/home/maccamp/mccloud-rrt/outputs/904/reduced.newick");
tree = readTopology(treefile);     
#plot(tree, :R, showEdgeLength=true);

T=readTopologyLevel1(treefile);    

# Using snaq!
net0 = snaq!(T,CF, hmax=0, filename="/home/maccamp/mccloud-rrt/outputs/network/net0", seed=1234);      
writeTopology(net0, "/home/maccamp/mccloud-rrt/outputs/network/bestnet-h0.tre")

net1 = snaq!(T,CF, hmax=1, filename="/home/maccamp/mccloud-rrt/outputs/network/net1", seed=1234);  
writeTopology(net1, "/home/maccamp/mccloud-rrt/outputs/network/bestnet-h1.tre")

net2 = snaq!(T,CF, hmax=2, filename="/home/maccamp/mccloud-rrt/outputs/network/net2", seed=1234);      
writeTopology(net2, "/home/maccamp/mccloud-rrt/outputs/network/bestnet-h2.tre")

net3 = snaq!(T,CF, hmax=3, filename="/home/maccamp/mccloud-rrt/outputs/network/net3", seed=1234);      
writeTopology(net3, "/home/maccamp/mccloud-rrt/outputs/network/bestnet-h3.tre")

net4 = snaq!(T,CF, hmax=4, filename="/home/maccamp/mccloud-rrt/outputs/network/net4", seed=1234);      
writeTopology(net4, "/home/maccamp/mccloud-rrt/outputs/network/bestnet-h4.tre")

net5 = snaq!(T,CF, hmax=4, filename="/home/maccamp/mccloud-rrt/outputs/network/net5", seed=1234);      
writeTopology(net5, "/home/maccamp/mccloud-rrt/outputs/network/bestnet-h5.tre")

using RCall      
imagefilename = "outputs/network/snaqplot-net0.pdf"
R"pdf"(imagefilename, width=4, height=3) 
R"par"(mar=[0,0,0,0]) 
plot(net0, showgamma=true, showedgenumber=true);
R"dev.off()"; 

using RCall     
imagefilename = "outputs/network/snaqplot-net1.pdf"
R"pdf"(imagefilename, width=4, height=3) 
R"par"(mar=[0,0,0,0]) 
plot(net1, showgamma=true, showedgenumber=true); 
R"dev.off()"; 

using RCall      
imagefilename = "outputs/network/snaqplot-net2.pdf"
R"pdf"(imagefilename, width=4, height=3) 
R"par"(mar=[0,0,0,0]) # to reduce margins 
plot(net2, showgamma=true, showedgenumber=true);
R"dev.off()"; 

using RCall      
imagefilename = "outputs/network/snaqplot-net3.pdf"
R"pdf"(imagefilename, width=4, height=3) 
R"par"(mar=[0,0,0,0]) # to reduce margins 
plot(net3, showgamma=true, showedgenumber=true);
R"dev.off()"; 

scores = [net0.loglik, net1.loglik, net2.loglik, net3.loglik, net4.loglik, net5.loglik]
hmax = collect(0:5)

using RCall      
imagefilename1 = "outputs/network/hscores.pdf"
R"pdf"(imagefilename1, width=4, height=3) 
R"par"(mar=[0,0,0,0]) 
R"plot"(hmax, scores, type="b", ylab="network score", xlab="hmax", col="blue");
R"dev.off()";

exit()
