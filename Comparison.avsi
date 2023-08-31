function comparison(clip "clp", clip "clp2", int "mode", int "slide", int "color", string "input", string "output") {

###################################################################################################
##                                          Comparison                                           ##
##                                        V1 By Kurayami                                         ##
##                                       January 03 2022                                         ##
###################################################################################################



cmatrix = height(clp) <720 ? "rec601" :\
               2160 > height(clp) >= 720 ? "rec709" :\
               "rec2020"
               
ocs = "Converttoyv12" + "(matrix="  + Chr(34) + cmatrix + chr(34) + ")"

bitscheck = clp.BitsPerComponent() > 8 ? clp.convertto8bit : clp 
bitscheck2 = clp2.BitsPerComponent() > 8 ? clp.convertto8bit : clp2 

mode = Default(mode, 1)
color = Default(color, $FFFFFF)
input = Default(input, "input")
output = Default(output, "output")

slide = (mode==3) ? Default(slide, Height(clp)/2) : Default(slide, width(clp)/2)


clp = clp.converttorgb32
clp2 = clp2.converttorgb32


a = StackHorizontal(clp.Subtitle(input, size=clp.Height()/15).crop(0,0,-clp.width()+slide,0), BlankClip(clp, color=color).crop(0,0,-clp.width()+2,0))
b = clp2.crop(slide+2,0,0,0).Subtitle(output, size=clp2.Height()/15)

ab = stackhorizontal(a, b).eval(ocs)

c = StackVertical(clp.Subtitle(input, size=clp.Height()/15).crop(0,0,0,-clp.height()+slide), BlankClip(clp, color=color).crop(0,0,0,-clp.height()+2))
d = clp2.crop(0,C.Height(),0,0).Subtitle(output, size=a.Height()/15)

cd = StackVertical(c, d).eval(ocs)


compare = (mode == 1) ? StackHorizontal(clp.Subtitle(input, size=clp.Height()/15), clp2.Subtitle(output, size=clp2.Height()/15)) :\ 
                 (mode == 2) ? ab :\ 
                 (mode == 3) ? cd :\ 
                 Assert(false, "mode cant be greater than 3, what other fucking kind of comparison do you want")



return compare

}






function fourcomp(clip a, clip b, clip c, clip d, string "clip1", string "clip2", string "clip3", string "clip4") {


###################################################################################################
##                                           Fourcomp                                            ##
##                                        V1 By Kurayami                                         ##
##                                       January 03 2022                                         ##
###################################################################################################


clip1 = Default(clip1, "clip1")
clip2 = Default(clip2,"clip2")
clip3 = default(clip3, "clip3")
clip4 = Default(clip4, "clip4")

a = a.Subtitle(clip1, size=a.Height()/16)
b = b.Subtitle(clip2, size=a.Height()/16)
c = c.Subtitle(clip3, size=a.Height()/16)
d = d.Subtitle(clip4, size=a.Height()/16)

stack1 = StackHorizontal(a,b)
stack2 = StackHorizontal(c,d)
StackVertical(stack1,stack2)

}
